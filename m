Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-33-i4.italiaonline.it ([212.48.25.218]:35943 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752852AbcLZLEu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 26 Dec 2016 06:04:50 -0500
From: Giuseppe Della Bianca <bepi@adria.it>
To: Xin Zhou <xin.zhou@gmx.com>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: [CORRUPTION FILESYSTEM] Corrupted and unrecoverable file system during the snapshot receive
Date: Mon, 26 Dec 2016 12:04:26 +0100
Message-ID: <3040771.5eLdPxENH3@exnet.gdb.it>
In-Reply-To: <trinity-3b871d96-6d50-44af-9f6d-3fbf2f7fbfd8-1482610539986@3capp-mailcom-bs13>
References: <1479730155.5832e3eb3fde8@webmail.adria.it> <26479704.a8Su2NvQ2R@exnet.gdb.it> <trinity-3b871d96-6d50-44af-9f6d-3fbf2f7fbfd8-1482610539986@3capp-mailcom-bs13>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi.

I agree with Duncan, and I add:

- For remote transfer is used ssh.
  ssh is designed to ensure integrity of data.
- Remote transfer uses a Gigabit Ethernet, it is never congested.
- I had the same problems with a local btrfs receive.
- The script currently has 907 lines of code, many of which are to ensure the 
detection and display of btrfs tools errors.
- The script stops executing when btrs tools return an error code.
- Is not possible that the script does not display error messages or ignore 
error code of btrfs tools.

An example of today:

(2016-12-26 10:53:51) Start btrfsManage
. . . Start managing SEND ' / ' filesystem ' root ' snapshot in ' /dev/sda2 '

Sending ' root-2016-12-04_18:13:57.35 ' source snapshot to ' btrfsreceive ' subvolume
. . . btrfs send -p /tmp/tmp.xJWkEN1U23/btrfssnapshot/root/root-2016-12-03_18:07:09.34 /tmp/tmp.xJWkEN1U23/btrfssnapshot/root/root-2016-12-04_18:13:57.35 | btrfs receive /tmp/tmp.pWWKP4vfAy/btrfsreceive/root/.part/
. . . At subvol /tmp/tmp.xJWkEN1U23/btrfssnapshot/root/root-2016-12-04_18:13:57.35
. . . ERROR: truncate usr/share/locale/it/LC_MESSAGES/kio4.mo failed: Read-only file system
. . . At snapshot root-2016-12-04_18:13:57.35
. . . _EC_ERR_ 1
. . . _EC_ERR_ 141

(2016-12-26 10:54:28) End btrfsManage
. . . End managing SEND ' / ' filesystem ' root ' snapshot in ' /dev/sda2 '
WITH ERRORS


Checking filesystem on /dev/sda2
UUID: 44f1de7e-a65b-41ce-8ff4-20f7ed83e106
checking extents
ref mismatch on [62408097792 16384] extent item 0, found 1
Backref 62408097792 parent 1060 root 1060 not found in extent tree
backpointer mismatch on [62408097792 16384]
owner ref check failed [62408097792 16384]
ref mismatch on [77565509632 16384] extent item 0, found 1
Backref 77565509632 parent 1060 root 1060 not found in extent tree
backpointer mismatch on [77565509632 16384]
]zac[
Backref 77826916352 parent 1060 root 1060 not found in extent tree
backpointer mismatch on [77826916352 16384]
owner ref check failed [77826916352 16384]
ref mismatch on [77853933568 16384] extent item 0, found 1
Backref 77853933568 parent 1060 root 1060 not found in extent tree
backpointer mismatch on [77853933568 16384]
owner ref check failed [77853933568 16384]
checking free space cache
checking fs roots
warning line 3822
checking csums
checking root refs
found 135128678400 bytes used err is 0
total csum bytes: 126946572
total tree bytes: 5132206080
total fs tree bytes: 4744757248
total extent tree bytes: 240795648
btree space waste bytes: 914832832
file data blocks allocated: 3311786532864
 referenced 703616266240



Is likely that mine is a special case.

But a special case, with a code change in other points, can become a problem for many.

It's not nice to say, but it seems I have to hope that my problem becomes a problem of many.

Meanwhile, I'll find my own workaround of a probable serious btrfs bug.


Thank you.

Gdb


> Hi,
> 
> Probably can try to use "-v" to enable more output print.
> A quick look at the send / receive code, it seems a little bit risky.
> It seems lack of specific error handlings, and in most cases, return the
> same error code. I think it might be helpful, when a transfer succeed, the
> command prints the transfer id, source / dest, and a specific "success"
> string.
> Such output could help the script to figure out if a transfer really
> succeed.
> 
> The code is relatively new to me, I did not see retry logic in stream
> handling, please correct me if I am wrong about this. So, I am not quite
> sure about the transfer behavior, if the system subject to network issues
> in heavy workload, in which packets missing or connect issues are not rare.
> 
> Since the test mentioned at the begining deletes the snapshots after a
> transfer, while most users keep the middle snapshot even in cascading
> transfer, probably the current btrfs and cmds still works for regular
> users.
> 
> Thanks,
> Xin
>  
>  
