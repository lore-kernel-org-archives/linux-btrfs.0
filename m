Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:6307 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932596AbaKMOnr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Nov 2014 09:43:47 -0500
Message-ID: <5464C399.5040903@fb.com>
Date: Thu, 13 Nov 2014 09:43:37 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Qu Wenruo <quwenruo@cn.fujitsu.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: About leaf corruption recovery(currently only fs/subvol tree
 recovery)
References: <546473A6.2070905@cn.fujitsu.com>
In-Reply-To: <546473A6.2070905@cn.fujitsu.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/13/2014 04:02 AM, Qu Wenruo wrote:
> Hi all,
>
> I'm trying to implement leaf corruption recovery.
>
> *CURRENT BEHAVIOR*
> Btrfs now heavily rely on chunk level duplication to protect its tree
> block(meta data).
> That's completely good and works quite well.
>
> However small device with mixed single chunk will suffer from the lack
> of duplication and when any
> bit flip happens in tree block, the whole 16K leaf/node will be
> unreadable and finally cause
> metadata corruption.
>
> *OBJECT*
> I hope btrfsck can repair such bit flip even with the cost of data lose.
> (It will of course introduce data loss according to the following method)
>
> And the ultimate object will be making a randomly slightly(0.2% of all
> bytes?) damaged btrfs
> can pass btrfsck after repair.
>
> *RECOVERY METHOD*
> Current recovery method is consist of the following procedure:
> 1) find and record the unreadable extent buffers during normal fsck routine
> With the record of the unreadable extent buffers, we can calculates the
> inode number range where
> next step will drop.
>
> 2) *delete* the slot pointing to the leaf in parent node
> Yes, delete the corrupted leaves, at least this is the cleanest and
> easiest method.
> After the step, the metadata tree should at least be iteratable now.
>
> 3) cleanup the mess done in 2)
> Need to do the following things in case btrfsck complains later
> 3.1) salvage data from extent tree in the deleting range.
> Although fs/subvol leaf is deleted, extent data is still there, using
> EXTENT_ITEM in extent tree
> may still recover some data.
> Personally I prefer to create a lost+found dir in the root of its
> subvolume and use inode number as
> file name to restore them.
>
> 3.2) Remove backref to the inodes in deleting ranges and move them if
> needed.
> It is clear we need to remove the invalid backref, but if some inodes in
> deleting ranges casuing
> its children files unaccessible from the subvolume root, then these
> files should be moved to 'lost+found' too,
> even they are completely undamaged.
>
> Although after the above steps, metadata like filename, access bits,
> owner, xattrs or inlined data will be
> lost and some files/dirs will be moved to lost+found, it should at least
> btrfsck not complain any more.
>
> *NEED ADVICE*
> Any concern about the above recovery is welcomed, especially when some
> guy like me want to
> implement such an aggressive recovery method.
>

So we already have a way to fix weird problems with blocks in btrfsck, 
see try_to_fix_bad_block.  This doesn't fix everything, but it could 
easily be expanded to just add anybody who can't be fixed to a list to 
be deleted and then see what fsck comes up with.  If the block is in the 
extent tree for example it's pretty easy to recover, fs tree's can 
rebuild some missing stuff, csum tree doesn't do anything yet.

I think the best bet is to track these bad blocks and then adjust what 
we do based on which tree they are in.  For example we don't want fsck 
just randomly re-generating data csums, but if we've found a bad block 
in the csum tree then we definitely want to re-generate the data csum in 
that case.  But for the extent tree we can be sure that we'll put stuff 
back in the right way, so you can just remove that block and know the 
normal fsck code will fix things.  Thanks,

Josef
