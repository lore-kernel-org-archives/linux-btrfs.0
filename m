From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: [PATCH 1/3] perf: parse greater/less than or equal
Date: Wed, 07 Dec 2011 10:36:49 +0900
Message-ID: <4EDEC331.7020506@jp.fujitsu.com>
References: <4EDEC207.90403@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Cc: linux-btrfs@vger.kernel.org,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
	Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4EDEC207.90403@jp.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Some btrfs tracepoints have complex format like following, but perf
command failed to parse it:

   print fmt: "%s",  ((REC->id >= min) || (REC->id <= max )) ?
        __print_symbolic(REC->id, { 1ULL, "ROOT_TREE" }, ... ) : "-"

  $ perf script
  Warning: unknown op '>='
  Warning: Error: expected type 5 but read 1
  Warning: failed to read event print fmt for btrfs_transaction_commit

This patch allow perf command to parse operation tokens, '>=' and '<='.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 tools/perf/util/trace-event-parse.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index 0a7ed5b..c2adc76 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -1229,6 +1229,8 @@ process_op(struct event *event, struct print_arg *arg, char **tok)
 		   strcmp(token, "/") == 0 ||
 		   strcmp(token, "<") == 0 ||
 		   strcmp(token, ">") == 0 ||
+		   strcmp(token, "<=") == 0 ||
+		   strcmp(token, ">=") == 0 ||
 		   strcmp(token, "==") == 0 ||
 		   strcmp(token, "!=") == 0) {
 
-- 
1.7.7.3
