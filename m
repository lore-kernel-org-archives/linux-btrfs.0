Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-po-06v.sys.comcast.net ([96.114.154.165]:50449 "EHLO
	resqmta-po-06v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750737AbaKBEtp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 2 Nov 2014 00:49:45 -0400
Message-ID: <5455B7E7.3020404@pobox.com>
Date: Sat, 01 Nov 2014 21:49:43 -0700
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: Tobias Holst <tobby@tobby.eu>, Rich Freeman <r-btrfs@thefreemanclan.net>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: filesystem corruption
References: <CAGwxe4hoJa6h3=qmsa6k+AzienjwZ2eifakKzhanXZVCru9koA@mail.gmail.com> <CAGwxe4inBLYrbq2t1T004dGR_vfE-GwgU=fho=SCDBa6LOkWow@mail.gmail.com> <CAGfcS_=f2TRGbeWpE186xE89jnXmPb=qiN6mPgjQGJRRX3UJ1g@mail.gmail.com> <CAGwxe4hC_BtPd41YCnFnyMD3TnOeuNgAZ1dZUFRUYuOkFjy0Yg@mail.gmail.com>
In-Reply-To: <CAGwxe4hC_BtPd41YCnFnyMD3TnOeuNgAZ1dZUFRUYuOkFjy0Yg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/31/2014 10:34 AM, Tobias Holst wrote:
> I am now using another system with kernel 3.17.2 and btrfs-tools 3.17
> and inserted one of the two HDDs of my btrfs-RAID1 to it. I can't add
> the second one as there are only two slots in that server.
>
> This is what I got:
>
>   tobby@ubuntu: sudo btrfs check /dev/sdb1
> warning, device 2 is missing
> warning devid 2 not found already
> root item for root 1746, current bytenr 80450240512, current gen
> 163697, current level 2, new bytenr 40074067968, new gen 163707, new
> level 2
> Found 1 roots with an outdated root item.
> Please run a filesystem check with the option --repair to fix them.
>
>   tobby@ubuntu: sudo btrfs check --repair /dev/sdb1
> enabling repair mode
> warning, device 2 is missing
> warning devid 2 not found already
> Unable to find block group for 0
> extent-tree.c:289: find_search_start: Assertion `1` failed.

The read-only snapshots taken under 3.17.1 are your core problem.

Now btrfsck is refusing to operate on the degraded RAID because degraded 
RAID is degraded so it's read-only. (this is an educated guess). Since 
btrfsck is _not_ a mount type of operation its got no "degraded mode" 
that would let you deal with half a RAID as far as I know.

In your case...

It is _known_ that you need to be _not_ running 3.17.0 or 3.17.1 if you 
are going to make read-only snapshots safely.
It is _known_ that you need to be running 3.17.2 to get a number of 
fixes that impact your circumstance.
It is _known_ that you need to be running btrfs-progs 3.17 to repair the 
read-only snapshot that are borked up, and that you must _not_ have 
previously tried to repair the problme with an older btrfsck.

Were I you, I would...

Put the two disks back in the same computer before something bad happens.

Upgrade that computer to 3.17.2 and 3.17 respectively.

Take a backup (because I am paranoid like that, though current threat 
seems negligible).

btrfsck your raid with --repair.

Alternately, if you previously tried to btrfsck the raid with a version 
prior to 3.17 tools after the read-only snapshot(s) problem, you will 
need to resort to mkfs.btrfs to solve the problem. But Hey! you have two 
disks, so break the RAID, then mkfs one of them, then copy the data, 
then re-make the RAID such that the new FS rules.

Enjoy your system no longer taking racy read-only snapshots... 8-)


