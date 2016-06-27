Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:33470 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751673AbcF0R2S (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Jun 2016 13:28:18 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
	by mailout.nyi.internal (Postfix) with ESMTP id 796062066B
	for <linux-btrfs@vger.kernel.org>; Mon, 27 Jun 2016 13:28:17 -0400 (EDT)
Received: from [192.168.1.129] (unknown [2.235.201.237])
	by mail.messagingengine.com (Postfix) with ESMTPA id AF184CCD34
	for <linux-btrfs@vger.kernel.org>; Mon, 27 Jun 2016 13:28:16 -0400 (EDT)
To: linux-btrfs@vger.kernel.org
From: Francesco Turco <fturco@fastmail.fm>
Subject: Btrfs full balance command fails due to ENOSPC (bug 121071)
Message-ID: <a3dcbcfc-a8b5-6a54-f600-63dd2d9162b5@fastmail.fm>
Date: Mon, 27 Jun 2016 19:28:15 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Note: I already filed bug 121071 but perhaps I should have written to
this mailing list first.

I get the ENOSPC error when running a btrfs full balance command for my
root partition, even if it seems I have a lot of free/unallocated space.

# btrfs filesystem show /
Label: none  uuid: 27150b83-7d90-4031-8e83-581315b9a254
	Total devices 1 FS bytes used 10.79GiB
	devid    1 size 25.00GiB used 13.31GiB path /dev/mapper/Desktop-root
# btrfs filesystem df /
Data, single: total=11.00GiB, used=10.40GiB
System, DUP: total=32.00MiB, used=16.00KiB
Metadata, DUP: total=1.12GiB, used=392.08MiB
GlobalReserve, single: total=144.00MiB, used=0.00B
# btrfs balance start --full-balance /
ERROR: error during balancing '/': No space left on device
There may be more info in syslog - try dmesg | tail
# dmesg | tail
[29807.441930] BTRFS info (device dm-2): found 13206 extents
[29807.879845] BTRFS info (device dm-2): relocating block group
47542435840 flags 1
[29827.116083] BTRFS info (device dm-2): found 12909 extents
[29830.500110] BTRFS info (device dm-2): found 12909 extents
[29830.976485] BTRFS info (device dm-2): relocating block group
46468694016 flags 1
[29848.924188] BTRFS info (device dm-2): found 5129 extents
[29851.533076] BTRFS info (device dm-2): found 5129 extents
[29851.994787] BTRFS info (device dm-2): relocating block group
46435139584 flags 34
[29852.399460] BTRFS info (device dm-2): found 1 extents
[29852.657983] BTRFS info (device dm-2): 1 enospc errors during balance

I have successfully balanced both the boot and home partitions before.
Only root gives me problems.

Is there anything I can try? Should I run the command from a live CD? Is
this a real bug or a mistake from an unexperienced btrfs user like me?

Thanks.

-- 
Website: http://www.fturco.net/
GPG key: 6712 2364 B2FE 30E1 4791 EB82 7BB1 1F53 29DE CD34
