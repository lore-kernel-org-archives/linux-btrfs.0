Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail02.iobjects.de ([188.40.134.68]:46798 "EHLO
	mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753412AbcCAMoG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Mar 2016 07:44:06 -0500
Received: from tux.wizards.de (p579D0048.dip0.t-ipconnect.de [87.157.0.72])
	by mail02.iobjects.de (Postfix) with ESMTPSA id A2173416015E
	for <linux-btrfs@vger.kernel.org>; Tue,  1 Mar 2016 13:44:03 +0100 (CET)
Received: from [192.168.100.223] (ragnarok [192.168.100.223])
	by tux.wizards.de (Postfix) with ESMTP id 2E29411C02BE
	for <linux-btrfs@vger.kernel.org>; Tue,  1 Mar 2016 13:44:03 +0100 (CET)
To: linux-btrfs <linux-btrfs@vger.kernel.org>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?=
	<holger.hoffstaette@googlemail.com>
Subject: btrfs-progs: initial scan-build results
Message-ID: <56D58E93.9000705@googlemail.com>
Date: Tue, 1 Mar 2016 13:44:03 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

With btrfs-progs needing & getting some more love I decided to run today's
master through clang's very awesome static analyzer [1] to see what a more
complete data flow analysis than gcc's -Wall yields. The results can be
found at [2] and are somewhat reason for concern. =:)

Please note that even though all messages are typically "real" in the sense
that they _could_ happen, it does not mean that they do during normal
operation, since some codepaths might just be dynamic/rare. That being said,
quite a few warnings seemed sufficiently serious to me that I decided to post
this. For example there's IMHO no sane way zero-sized allocations make any
sense.

IMHO most dead stores are seemingly the easiest to fix (just remove the
statement?), but some of them might actually be missing upstream error
handling - indicative of something more serious.

Dave, any suggestions on how best to proceed? Any preferences or would
another branch be more interesting? I tried to track devel but that
gets rebased frequently (or I'm doing something wrong).

Btw running scan-build is easy: get clang, './configure' as usual and
'scan-build make -jX' will create the report in /tmp/scan-build-<time>.

Let me know if this is helpful.

cheers,
Holger

[1] http://clang-analyzer.llvm.org/scan-build.html
[2] http://hoho.duckdns.org/~holger/btrfs-progs/scan-build-2016-03-01-130244-29106-1/

