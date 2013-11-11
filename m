Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:52493 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751138Ab3KKWwg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Nov 2013 17:52:36 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Vg0LS-0000wM-OA
	for linux-btrfs@vger.kernel.org; Mon, 11 Nov 2013 23:52:34 +0100
Received: from cpc21-stap10-2-0-cust974.12-2.cable.virginm.net ([86.0.163.207])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 11 Nov 2013 23:52:34 +0100
Received: from m_btrfs by cpc21-stap10-2-0-cust974.12-2.cable.virginm.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 11 Nov 2013 23:52:34 +0100
To: linux-btrfs@vger.kernel.org
From: Martin <m_btrfs@ml1.co.uk>
Subject: Re: [PATCH] Btrfs-progs: allow --init-extent-tree to work when extent
 tree is borked
Date: Mon, 11 Nov 2013 22:52:23 +0000
Message-ID: <l5rn2s$m3p$1@ger.gmane.org>
References: <1382724100-5276-1-git-send-email-jbacik@fusionio.com> <l4ed62$8r3$1@ger.gmane.org> <20131025183134.GA4543@localhost.localdomain> <l4hifj$ni1$1@ger.gmane.org> <20131028151148.GB4543@localhost.localdomain> <l5eq5s$m8l$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
In-Reply-To: <l5eq5s$m8l$1@ger.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/11/13 01:25, Martin wrote:
> On 28/10/13 15:11, Josef Bacik wrote:

>> Ok I've sent
>>
>> [PATCH] Btrfs-progs: rework open_ctree to take flags, add a new one
>>
>> which should address your situation.  Thanks,
> 
> 
> Josef,
> 
> Tried your patch:
> 
> ####
> Signed-off-by: Josef Bacik <jbacik@fusionio.com>
> 
>  13 files changed, 75 insertions(+), 113 deletions(-)
> 
> diff --git a/btrfs-convert.c b/btrfs-convert.c
> index 26c7b5f..ae10eed 100644
> ####
> 
> And the patching fails due to mismatching code...
> 
> I have the Gentoo source for:
> 
> Btrfs v0.20-rc1-358-g194aa4a
> 
> (On Gentoo 3.11.5, will be on 3.11.6 later today.)
> 
> 
> What are the magic incantations to download your version of source code
> to try please? (Patched or unpatched?)

OK so Chris Mason and the Gentoo sys-fs/btrfs-progs-9999 came to the
rescue to give:


# btrfs version
Btrfs v0.20-rc1-591-gc652e4e


This time:

# btrfsck --repair --init-extent-tree /dev/sdc

quickly gave:

parent transid verify failed on 911904604160 wanted 17448 found 17449
parent transid verify failed on 911904604160 wanted 17448 found 17449
parent transid verify failed on 911904604160 wanted 17448 found 17449
parent transid verify failed on 911904604160 wanted 17448 found 17449
Ignoring transid failure
btrfs unable to find ref byte nr 910293991424 parent 0 root 1  owner 2
offset 0
btrfs unable to find ref byte nr 910293995520 parent 0 root 1  owner 1
offset 1
btrfs unable to find ref byte nr 910293999616 parent 0 root 1  owner 0
offset 1
leaf free space ret -297791851, leaf data size 3995, used 297795846
nritems 2
checking extents
btrfsck: extent_io.c:609: free_extent_buffer: Assertion `!(eb->refs <
0)' failed.
enabling repair mode
Checking filesystem on /dev/sdc
UUID: 38a60270-f9c6-4ed4-8421-4bf1253ae0b3
Creating a new extent tree
Failed to find [910293991424, 168, 4096]
Failed to find [910293995520, 168, 4096]
Failed to find [910293999616, 168, 4096]


>From that, I've tried running again:

# btrfsck --repair /dev/sdc

giving thus far:

parent transid verify failed on 911904604160 wanted 17448 found 17450
parent transid verify failed on 911904604160 wanted 17448 found 17450
parent transid verify failed on 911904604160 wanted 17448 found 17450
parent transid verify failed on 911904604160 wanted 17448 found 17450
Ignoring transid failure


... And it is still running a couple of days later.

GDB shows:

(gdb) bt
#0  0x000000000042d576 in read_extent_buffer ()
#1  0x000000000041ee79 in btrfs_check_node ()
#2  0x0000000000420211 in check_block ()
#3  0x0000000000420813 in btrfs_search_slot ()
#4  0x0000000000427bb4 in btrfs_read_block_groups ()
#5  0x0000000000423e40 in btrfs_setup_all_roots ()
#6  0x000000000042406d in __open_ctree_fd ()
#7  0x0000000000424126 in open_ctree_fs_info ()
#8  0x000000000041812e in cmd_check ()
#9  0x0000000000404904 in main ()


So... Has it looped or is it busy? There is no activity on /dev/sdc.


Which comes to a request:

Can the options "-v" (for verbose) and "-s" (to continuously show
status) be added to btrfsck to give some indication of progress and what
is happening? The "-s" should report progress by whatever appropriate
real-time counts as done by such as "badblocks -s".


I'll leave running for a little while longer before trying a mount.

Hope of interest.

Thanks,
Martin





