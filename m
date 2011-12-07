From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: [PATCH 0/3] perf: parser fix for btrfs tracepoints
Date: Wed, 07 Dec 2011 10:31:51 +0900
Message-ID: <4EDEC207.90403@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Cc: linux-btrfs@vger.kernel.org,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
	Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

After playing with v3.2-rc4, I found that the perf command failed to
parse record contain data from (relatively new) btrfs tracepoints.

This patch set will improve parser code of perf command and allow
it to handle these data from btrfs tracepoints well.

Thanks,
H.Seto

Hidetoshi Seto (3):
      perf: parse greater/less than or equal
      perf: allow processing single op args
      perf: allow typecast for signed value

 tools/perf/util/trace-event-parse.c |   25 +++++++++++++++++++++++--
 1 files changed, 23 insertions(+), 2 deletions(-)
