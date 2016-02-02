Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yk0-f182.google.com ([209.85.160.182]:34412 "EHLO
	mail-yk0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755163AbcBBXjQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Feb 2016 18:39:16 -0500
Received: by mail-yk0-f182.google.com with SMTP id u9so4427487ykd.1
        for <linux-btrfs@vger.kernel.org>; Tue, 02 Feb 2016 15:39:16 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAPcyv4gtcL_WwZpmiAUhO5h4q3YyXinkpz9SwKm5SBA9-1kE9Q@mail.gmail.com>
References: <1454454702-11889-1-git-send-email-ross.zwisler@linux.intel.com>
	<20160202231931.GR17997@ZenIV.linux.org.uk>
	<CAPcyv4gtcL_WwZpmiAUhO5h4q3YyXinkpz9SwKm5SBA9-1kE9Q@mail.gmail.com>
Date: Tue, 2 Feb 2016 15:39:15 -0800
Message-ID: <CAPcyv4gqq0guubnddRPmDVA0N1=vfh3w6jPf4GsuYs0D29nS4w@mail.gmail.com>
Subject: Re: [PATCH] dax: allow DAX to look up an inode's block device
From: Dan Williams <dan.j.williams@intel.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.com>,
        Jeff Layton <jlayton@poochiereds.net>,
        Matthew Wilcox <willy@linux.intel.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-nvdimm <linux-nvdimm@ml01.01.org>,
        XFS Developers <xfs@oss.sgi.com>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

[ adding btrfs, resend with the correct list address  ]

On Tue, Feb 2, 2016 at 3:19 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Tue, Feb 02, 2016 at 04:11:42PM -0700, Ross Zwisler wrote:
>
>> However, for raw block devices and for XFS with a real-time device, the
>> value in inode->i_sb->s_bdev is not correct.  With the code as it is
>> currently written, an fsync or msync to a DAX enabled raw block device will
>> cause a NULL pointer dereference kernel BUG.  For this to work correctly we
>> need to ask the block device or filesystem what struct block_device is
>> appropriate for our inode.
>>
>> To that end, add a get_bdev(struct inode *) entry point to struct
>> super_operations.  If this function pointer is non-NULL, this notifies DAX
>> that it needs to use it to look up the correct block_device.  If
>> i_sb->get_bdev() is NULL DAX will default to inode->i_sb->s_bdev.
>
> Umm...  It assumes that bdev will stay pinned for as long as inode is
> referenced, presumably?  If so, that needs to be documented (and verified
> for existing fs instances).  In principle, multi-disk fs might want to
> support things like "silently move the inodes backed by that disk to other
> ones"...

I assume btrfs is the only fs we have that might reassign the bdev for
a given inode on the fly?  Hopefully we don't need anything stronger
than rcu_read_lock() to pin the result as valid.

At least in this case the initial user is dax-fsync where the
->get_bdev() answer should be static for the life of the inode, and
btrfs does not currently interface with dax.  But yes, we need to get
the expected semantics clear.

On Tue, Feb 2, 2016 at 3:38 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> [ adding btrfs ]
>
> On Tue, Feb 2, 2016 at 3:19 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>> On Tue, Feb 02, 2016 at 04:11:42PM -0700, Ross Zwisler wrote:
>>
>>> However, for raw block devices and for XFS with a real-time device, the
>>> value in inode->i_sb->s_bdev is not correct.  With the code as it is
>>> currently written, an fsync or msync to a DAX enabled raw block device will
>>> cause a NULL pointer dereference kernel BUG.  For this to work correctly we
>>> need to ask the block device or filesystem what struct block_device is
>>> appropriate for our inode.
>>>
>>> To that end, add a get_bdev(struct inode *) entry point to struct
>>> super_operations.  If this function pointer is non-NULL, this notifies DAX
>>> that it needs to use it to look up the correct block_device.  If
>>> i_sb->get_bdev() is NULL DAX will default to inode->i_sb->s_bdev.
>>
>> Umm...  It assumes that bdev will stay pinned for as long as inode is
>> referenced, presumably?  If so, that needs to be documented (and verified
>> for existing fs instances).  In principle, multi-disk fs might want to
>> support things like "silently move the inodes backed by that disk to other
>> ones"...
>
> I assume btrfs is the only fs we have that might reassign the bdev for
> a given inode on the fly?  Hopefully we don't need anything stronger
> than rcu_read_lock() to pin the result as valid.
>
> At least in this case the initial user is dax-fsync where the
> ->get_bdev() answer should be static for the life of the inode, and
> btrfs does not currently interface with dax.  But yes, we need to get
> the expected semantics clear.
