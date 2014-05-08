Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:45130 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751841AbaEHBep (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 May 2014 21:34:45 -0400
Date: Wed, 7 May 2014 18:34:40 -0700
From: Marc MERLIN <marc@merlins.org>
To: Chris Mason <clm@fb.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: URGENT: my laptop's boot ssd btrfs crashed, what do you need off
 it?
Message-ID: <20140508013440.GH11401@merlins.org>
References: <20140507233959.GB11401@merlins.org>
 <536AD20E.70004@fb.com>
 <20140508004344.GE11401@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140508004344.GE11401@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 07, 2014 at 05:43:44PM -0700, Marc MERLIN wrote:
> A full dd image is not practical, it's 1TB and I have nowhere to put it.
> I could do an image if you'd like, and upload it when I have proper
> internet (I'm thinking it's likely going to be a 1GB upload)

In the meantime, here is fsck output:
legolas:/boot/grub# btrfsck /dev/mapper/disk1 2>&1 | tee /tmp/fsck
Check tree block failed, want=828930883584, have=10983188636980216968
Check tree block failed, want=828930883584, have=10983188636980216968
Check tree block failed, want=828930883584, have=12509109177217855588
Check tree block failed, want=828930883584, have=12509109177217855588
Check tree block failed, want=828930883584, have=12509109177217855588
read block failed check_tree_block
Couldn't read tree root
Critical roots corrupted, unable to fsck the FS
Checking filesystem on /dev/mapper/disk1
UUID: 4850ee22-bf32-4131-a841-02abdb4a5ba6

Let me know if I should try 
--init-csum-tree and/or --init-extent-tree

legolas:/# /sbin/btrfs-find-root /dev/mapper/disk1 
Super think's the tree root is at 828930883584, chunk root 20979712
Well block 12585312256 seems great, but generation doesn't match, have=410782, want=415424 level 0
(...)
Well block 828888629248 seems great, but generation doesn't match, have=415420, want=415424 level 0
Found tree root at 828930887680 gen 415424 level 0
legolas:/# 

I noted that:
828930887680 - 828930883584 = 4096

So I have a root tree that's bigger than what super is looking for?
Could that be my problem?

Can btrfs restore be used to navigate the filesystem and look for files and patterns
without dumping the entire filesystem, which I don't have room for?

In the meantime, I didn't get it to work anyway:
legolas:/var/local/space/nobck# btrfs restore -t 828930887680 /dev/mapper/disk1 restore
Couldn't setup extent tree
Couldn't read fs root: -2
extent buffer leak: start 828930887680 len 4096

Now, even if that worked, 
https://btrfs.wiki.kernel.org/index.php/Restore#Advanced_usage
says I can use -r to only restore a subvolume, but I don't know its objectid.
How would I do this?

(I don't actually really need the data, I'm just trying to learn what I
would do if I did)

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
