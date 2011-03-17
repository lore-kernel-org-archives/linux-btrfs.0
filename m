From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH 1/2] Btrfs: add datacow flag in inode flag
Date: Thu, 17 Mar 2011 10:21:21 -0400
Message-ID: <1300371584-sup-1674@think>
References: <4D6F52DE.5080508@cn.fujitsu.com> <1300220702-sup-5062@think> <20110315205724.GB10360@lst.de> <E3D32D88-C93F-4B5A-8CCF-810A9519AE9D@dilger.ca> <1300232002-sup-6976@think> <AANLkTin3+kjzjN8LE+Sbc8ngVHLFpmU=n9tNKMY0EPrU@mail.gmail.com> <4D816D81.4080208@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Cc: Amir Goldstein <amir73il@gmail.com>,
	Andreas Dilger <adilger@dilger.ca>,
	Christoph Hellwig <hch@lst.de>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Theodore Tso <tytso@mit.edu>
To: liubo <liubo2009@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <4D816D81.4080208@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from liubo's message of 2011-03-16 22:10:09 -0400:
> On 03/16/2011 05:06 PM, Amir Goldstein wrote:
> > On Wed, Mar 16, 2011 at 1:35 AM, Chris Mason <chris.mason@oracle.com> wrote:
> >> Excerpts from Andreas Dilger's message of 2011-03-15 18:06:49 -0400:
> >>> On 2011-03-15, at 2:57 PM, Christoph Hellwig wrote:
> >>>> On Tue, Mar 15, 2011 at 04:26:50PM -0400, Chris Mason wrote:
> >>>>>  #define FS_EXTENT_FL         0x00080000 /* Extents */
> >>>>>  #define FS_DIRECTIO_FL       0x00100000 /* Use direct i/o */
> >>>>> +#define FS_NOCOW_FL          0x00800000 /* Do not cow file */
> >>>>> +#define FS_COW_FL            0x01000000 /* Cow file */
> >>>>>  #define FS_RESERVED_FL       0x80000000 /* reserved for ext2 lib */
> >>>> I'm fine with it.  I'll defer the check for conflicts with extN-specific flags
> >>>> to Ted, though.
> >>> Looking at the upstream e2fsprogs I see in that range:
> >>>
> >>>> #define EXT4_EXTENTS_FL           0x00080000 /* Inode uses extents */
> >>>> #define EXT4_EA_INODE_FL          0x00200000 /* Inode used for large EA */
> >>>> #define EXT4_EOFBLOCKS_FL         0x00400000 /* Blocks allocated beyond EOF */
> >>>> #define EXT4_SNAPFILE_FL          0x01000000 /* Inode is a snapshot */
> >>>> #define EXT4_SNAPFILE_DELETED_FL  0x04000000 /* Snapshot is being deleted */
> >>>> #define EXT4_SNAPFILE_SHRUNK_FL   0x08000000 /* Snapshot shrink has completed */
> >>>> #define EXT2_RESERVED_FL          0x80000000 /* reserved for ext2 lib */
> >>>>
> >>>> #define EXT2_FL_USER_VISIBLE      0x004BDFFF /* User visible flags */
> >>> so there is a conflict with FS_COW_FL and EXT4_SNAPFILE_FL.  I don't know the semantics of those two flags enough to say for sure whether it is reasonable that they alias to each other, but at first glance "COW" and "SNAPSHOT" don't seem completely unrelated.
> > 
> > EXT4_SNAPFILE_FL indicates a special system snapshot file, so it has
> > no equivalence relation with FS_COW_FL.
> > Please use 0x02000000 for FS_COW_FL.
> 
> Fine with that, but it's up to Chris. :)

I'd rather not conflict unless we're critically short on space.

> > 
> > EXT4_SNAPFILE_DELETED_FL is a persistent state of a snapshot file,
> > which is no longer
> > available as a mountable device, but cannot be unlinked because it
> > holds changed data sets
> > needed by older snapshots.
> > 
> > EXT4_SNAPFILE_SHRUNK_FL is a persistent state of a (deleted) snapshot
> > file, which has
> > undergone a "shrink" process to free all change sets not needed by
> > older snapshots.
> > The persistence of the flag is needed to avoid tedious shrinking when
> > it is not needed.
> > 
> > 
> >> In the btrfs case FS_COW_FL means to do COW even when there are no
> >> snapshots.  FS_NOCOW_FL means to do cow only when there are snapshots.
> >>
> > 
> > I am interested in FS_NOCOW_FL as well, but for my implementation it would mean
> > do not do COW on rewrites even when there are snapshots, so a user can
> > create a pre-allocated
> > "island of blocks", which are pinned to a physical location, for raw
> > VM image for example.

I'm not sure how the island of blocks idea can work with snapshots?
Wouldn't the snapshot corrupt if anything in the island were changed?

-chris
