// +build acceptance

/*
 * Copyright 2019 The original author or authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     https://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package acceptance

import (
	"os"
	"testing"
)

func TestBuilder(t *testing.T) {
	tcs := &Testcases{
		Common: Testcase{
			Builder:     os.Getenv("BUILDER"),
			PackCmd:     []string{"pack"},
			Repo:        "https://github.com/projectriff/fats",
			Refspec:     "766043f94a84e30d210258bdfdecb1bc9ca011f1", // main as of 2020-03-09
			Input:       "builder",
			ContentType: "text/plain",
			Accept:      "text/plain",
			Output:      "BUILDER",
		},
		Testcases: []Testcase{
			{
				Name:    "java",
				SubPath: "functions/uppercase/java",
			},
			{
				Name:    "java-boot",
				SubPath: "functions/uppercase/java-boot",
			},
			{
				Name:    "node",
				SubPath: "functions/uppercase/node",
			},
			{
				Name:        "npm",
				SubPath:     "functions/uppercase/npm",
				SkipRebuild: true,
			},
			{
				Name:        "yarn",
				SubPath:     "functions/uppercase/yarn",
				SkipRebuild: true,
			},
			{
				Name:    "command",
				SubPath: "functions/uppercase/command",
			},
		},
	}

	tcs.Run(t)
}
