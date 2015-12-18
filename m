Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from manchmal.in-ulm.de ([217.10.9.201]:58958 "EHLO
	manchmal.in-ulm.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752375AbbLRHgv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 Dec 2015 02:36:51 -0500
Date: Fri, 18 Dec 2015 08:28:11 +0100
From: Christoph Biedl <linux-kernel.bfrz@manchmal.in-ulm.de>
To: linux-btrfs@vger.kernel.org
Subject: ERROR: scrubbing <dev> failed for device id 1: ret=-1, errno=28 (No
 space left on device)
Message-ID: <1450423394@msgid.manchmal.in-ulm.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

checking all my btr file systems after seeing a lot of trouble on a
particular installation, I came across this:

# btrfs scrub start -B -c3 /mnt/schroot/
ERROR: scrubbing /mnt/schroot/ failed for device id 1: ret=-1, errno=28 (No space left on device)
scrub canceled for 89a02165-5975-46c7-8565-1247874531a2
        scrub started at Fri Dec 18 08:20:27 2015 and was aborted after 00:00:01
        total bytes scrubbed: 7.70MiB with 0 errors

btrfsck shows a *lot* of the "bad extent [458797056, 458801152), type
mismatch with chunk" messages that have been discussed here but
otherwise exits zero.

df shows 75% usage (4.4 of 6.5 Gibyte used)).

# btrfs fi df /mnt/schroot/
Data, single: total=5.17GiB, used=3.75GiB
System, DUP: total=8.00MiB, used=4.00KiB
System, single: total=4.00MiB, used=0.00B
Metadata, DUP: total=409.56MiB, used=143.44MiB
Metadata, single: total=8.00MiB, used=0.00B
GlobalReserve, single: total=48.00MiB, used=0.00B

This is btrfs-progs v4.3 running on kernel 4.3.3

Any idea how to proceed?

    Christoph
