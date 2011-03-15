From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 1/2] Btrfs: add datacow flag in inode flag
Date: Tue, 15 Mar 2011 16:06:49 -0600
Message-ID: <E3D32D88-C93F-4B5A-8CCF-810A9519AE9D@dilger.ca>
References: <4D6F52DE.5080508@cn.fujitsu.com> <1300220702-sup-5062@think> <20110315205724.GB10360@lst.de>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Cc: Chris Mason <chris.mason@oracle.com>,
	liubo <liubo2009@cn.fujitsu.com>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Theodore Tso <tytso@mit.edu>
To: Christoph Hellwig <hch@lst.de>, Amir Goldstein <amir73il@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20110315205724.GB10360@lst.de>
List-ID: <linux-btrfs.vger.kernel.org>

On 2011-03-15, at 2:57 PM, Christoph Hellwig wrote:
> On Tue, Mar 15, 2011 at 04:26:50PM -0400, Chris Mason wrote:
>>  #define FS_EXTENT_FL         0x00080000 /* Extents */
>>  #define FS_DIRECTIO_FL       0x00100000 /* Use direct i/o */
>> +#define FS_NOCOW_FL          0x00800000 /* Do not cow file */
>> +#define FS_COW_FL            0x01000000 /* Cow file */
>>  #define FS_RESERVED_FL       0x80000000 /* reserved for ext2 lib */
> 
> I'm fine with it.  I'll defer the check for conflicts with extN-specific flags
> to Ted, though.

Looking at the upstream e2fsprogs I see in that range:

> #define EXT4_EXTENTS_FL           0x00080000 /* Inode uses extents */
> #define EXT4_EA_INODE_FL          0x00200000 /* Inode used for large EA */
> #define EXT4_EOFBLOCKS_FL         0x00400000 /* Blocks allocated beyond EOF */
> #define EXT4_SNAPFILE_FL          0x01000000 /* Inode is a snapshot */
> #define EXT4_SNAPFILE_DELETED_FL  0x04000000 /* Snapshot is being deleted */
> #define EXT4_SNAPFILE_SHRUNK_FL   0x08000000 /* Snapshot shrink has completed */
> #define EXT2_RESERVED_FL          0x80000000 /* reserved for ext2 lib */
> 
> #define EXT2_FL_USER_VISIBLE      0x004BDFFF /* User visible flags */

so there is a conflict with FS_COW_FL and EXT4_SNAPFILE_FL.  I don't know the semantics of those two flags enough to say for sure whether it is reasonable that they alias to each other, but at first glance "COW" and "SNAPSHOT" don't seem completely unrelated.

It also isn't clear to me whether the SNAPFILE_DELETED_FL and SNAPFILE_SHRUNK_FL really need to be persistent flags that are stored on disk, or if they are state flags that should only be stored in the in-memory inode?  Not having them in the limited remaining inode flag space would be better...  Amir?

Cheers, Andreas





