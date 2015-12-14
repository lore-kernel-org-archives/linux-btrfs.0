Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ns211617.ip-188-165-215.eu ([188.165.215.42]:43075 "EHLO
	mx.speed47.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751061AbbLNTaf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Dec 2015 14:30:35 -0500
Received: from rc.speed47.net (nginx [192.168.80.2])
	by box.speed47.net (Postfix) with ESMTP id 88D3814C
	for <linux-btrfs@vger.kernel.org>; Mon, 14 Dec 2015 20:24:30 +0100 (CET)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Mon, 14 Dec 2015 20:24:30 +0100
From: =?UTF-8?Q?St=C3=A9phane_Lesimple?= <stephane_btrfs@lesimple.fr>
To: linux-btrfs@vger.kernel.org
Subject: btrfs-progs: enhanced btrfsck progress patch proposition
Message-ID: <730b5422ecf3fea01f938b3eb1d50e8c@all.all>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I've been forking btrfs-progs locally to add an enhanced progress 
indicator, based on the work from Silvio Fricke posted here in 
September. I'm using it routinely, it has been of help when I was 
debugging my multi-Tb btrfs system, where I often had to use btrfs 
check. So I thought it might be of interest to others.

The patch replaces the .oOo. progress indicator with a count of the 
walked items (depending on the "thing" being inspected, this way if the 
walks stops or there's an infinite loop somewhere, you'll notice), adds 
an elapsed time indicator, and a step counter (currently 6).

Once you're used to your FS, you'll know roughly how many remaining time 
to expect. Here's how it looks like:

Opening filesystem to check...
Checking filesystem on /dev/mapper/luks-WD30EZRX-WCAWZ3013164
UUID: 428b20da-dcb1-403e-b407-ba984fd07ebd
[1/6] checking extents (0:00:59 elapsed, 199559 chunk items checked)
[2/6] checking free space cache (0:00:30 elapsed, 2547 cache objects 
checked)
[3/6] checking fs roots (0:02:33 elapsed, 19731 tree blocks checked)
[4/6] checking csums (0:01:37 elapsed, 391340 csums checked)
[5/6] checking root refs (0:00:00 elapsed, 7 root refs checked)
[6/6] checking quota groups skipped (not enabled on this FS)
found 2786490501673 bytes used err is 0
total csum bytes: 2717987856
total tree bytes: 3270934528
total fs tree bytes: 324255744
total extent tree bytes: 35897344
btree space waste bytes: 208202162
file data blocks allocated: 2783900614656
  referenced 2783900614656
btrfs-progs v4.2.3-dirty

It's available here https://github.com/speed47/btrfs-progs/tree/progress

Or, alternatively:

$ git clone https://github.com/speed47/btrfs-progs.git
$ cd btrfs-progs
$ git checkout origin/progress

The master branch is the kdave's one.
The patch is kind of hacky (especially for the qgroup step, which I'm 
not proud of), but if it builds interest here, I'll clean it up and post 
it the right way to the mailing-list.

Regards,

-- 
Stéphane.
