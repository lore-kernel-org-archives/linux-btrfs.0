From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: [PATCH 3/3] perf: allow typecast for signed value
Date: Wed, 07 Dec 2011 10:37:57 +0900
Message-ID: <4EDEC375.2090808@jp.fujitsu.com>
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

Still I got following warning with btrfs tracepoints:

  $ perf script
  Warning: Error: expected type 5 but read 4
  Warning: Error: expected type 5 but read 0

I found that the complained format is:

  print fmt: "%s", (REC->val >= (u64)-4) ? "-" : __print_symbolic(...)
                                     ~
In perf's parser, the typecast, which is processed in process_paren(),
only expects that (unsigned) token or another parenthesis will follow
to the typecast.  It should expect signed tokens can be there too.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 tools/perf/util/trace-event-parse.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index b709f78..032f3de 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -1645,10 +1645,11 @@ process_paren(struct event *event, struct print_arg *arg, char **tok)
 	type = read_token_item(&token);
 
 	/*
-	 * If the next token is an item or another open paren, then
-	 * this was a typecast.
+	 * If the next token is an item (might be signed, with single op "-")
+	 * or another open paren, then this was a typecast.
 	 */
 	if (event_item_type(type) ||
+	    (type == EVENT_OP && strcmp(token, "-") == 0) ||
 	    (type == EVENT_DELIM && strcmp(token, "(") == 0)) {
 
 		/* make this a typecast and contine */
-- 
1.7.7.3
