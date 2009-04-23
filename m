From: Chris Mason <chris.mason@oracle.com>
Subject: Re: LVM vs btrfs as a "volume manager" for SANs
Date: Thu, 23 Apr 2009 14:45:13 -0400
Message-ID: <1240512313.28015.14.camel@think.oraclecorp.com>
References: <49EF6DF7.9020406@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: Tomasz Chmielewski <mangoo@wpkg.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <49EF6DF7.9020406@wpkg.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 2009-04-22 at 21:20 +0200, Tomasz Chmielewski wrote:
> Right now, the majority of Linux users probably have LVM on their SAN 
> devices (i.e those being iSCSI targets).
> 
> Using LVM on a SAN device is easy: just create a new logical volume or 
> its snapshot, make it a target to iSCSI initiators, done.
> 

This is definitely one of the target use cases for btrfs.

> I was wondering how btrfs would fit here and if it could replace LVM.
> 
> 
> I see the following benefits of using btrfs instead of LVM:
> 
> - you can create sparse files which would grow as iSCSI initators use 
> more space (you can do it with ext3 now as well)
>
> - you can use btrfs compression, to further reduce used space and 
> perhaps increase speed (SANs are mostly IO bound, not CPU bound)
> 
> - LVM has a big performance hit when using snapshots; btrfs doesn't
> 
> 
> 
> However, with btrfs, I'm not sure about:
> 
> - what happens if SAN machine crashes while the iSCSI file images were 
> being written to; with LVM and its block devices, I'm somehow more 
> confident it wouldn't make more data loss than necessary

If iscsi is writing with O_DIRECT|O_SYNC it should work.  But, tuning
for this config is something we have to concentrate more on.

> 
> - taking snapshots of individual files (file images on SAN) is not 
> possible with btrfs? Probably they would have to be placed in separate 
> directories first to make snapshots - some minor manageability issue

Btrfs can't snapshot a single dir, but it can snapshot a single file.
See the bcp command included with btrfs-progs.

I'd also suggest using preallocated files (via fallocate) instead of
sparse files.  I will perform better in general.

-chris


