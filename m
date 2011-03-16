From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 1/2] Btrfs: add datacow flag in inode flag
Date: Wed, 16 Mar 2011 11:06:31 +0200
Message-ID: <AANLkTin3+kjzjN8LE+Sbc8ngVHLFpmU=n9tNKMY0EPrU@mail.gmail.com>
References: <4D6F52DE.5080508@cn.fujitsu.com>
	<1300220702-sup-5062@think>
	<20110315205724.GB10360@lst.de>
	<E3D32D88-C93F-4B5A-8CCF-810A9519AE9D@dilger.ca>
	<1300232002-sup-6976@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Andreas Dilger <adilger@dilger.ca>, Christoph Hellwig <hch@lst.de>,
	liubo <liubo2009@cn.fujitsu.com>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Theodore Tso <tytso@mit.edu>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1300232002-sup-6976@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 16, 2011 at 1:35 AM, Chris Mason <chris.mason@oracle.com> w=
rote:
> Excerpts from Andreas Dilger's message of 2011-03-15 18:06:49 -0400:
>> On 2011-03-15, at 2:57 PM, Christoph Hellwig wrote:
>> > On Tue, Mar 15, 2011 at 04:26:50PM -0400, Chris Mason wrote:
>> >> =A0#define FS_EXTENT_FL =A0 =A0 =A0 =A0 0x00080000 /* Extents */
>> >> =A0#define FS_DIRECTIO_FL =A0 =A0 =A0 0x00100000 /* Use direct i/=
o */
>> >> +#define FS_NOCOW_FL =A0 =A0 =A0 =A0 =A00x00800000 /* Do not cow =
file */
>> >> +#define FS_COW_FL =A0 =A0 =A0 =A0 =A0 =A00x01000000 /* Cow file =
*/
>> >> =A0#define FS_RESERVED_FL =A0 =A0 =A0 0x80000000 /* reserved for =
ext2 lib */
>> >
>> > I'm fine with it. =A0I'll defer the check for conflicts with extN-=
specific flags
>> > to Ted, though.
>>
>> Looking at the upstream e2fsprogs I see in that range:
>>
>> > #define EXT4_EXTENTS_FL =A0 =A0 =A0 =A0 =A0 0x00080000 /* Inode us=
es extents */
>> > #define EXT4_EA_INODE_FL =A0 =A0 =A0 =A0 =A00x00200000 /* Inode us=
ed for large EA */
>> > #define EXT4_EOFBLOCKS_FL =A0 =A0 =A0 =A0 0x00400000 /* Blocks all=
ocated beyond EOF */
>> > #define EXT4_SNAPFILE_FL =A0 =A0 =A0 =A0 =A00x01000000 /* Inode is=
 a snapshot */
>> > #define EXT4_SNAPFILE_DELETED_FL =A00x04000000 /* Snapshot is bein=
g deleted */
>> > #define EXT4_SNAPFILE_SHRUNK_FL =A0 0x08000000 /* Snapshot shrink =
has completed */
>> > #define EXT2_RESERVED_FL =A0 =A0 =A0 =A0 =A00x80000000 /* reserved=
 for ext2 lib */
>> >
>> > #define EXT2_FL_USER_VISIBLE =A0 =A0 =A00x004BDFFF /* User visible=
 flags */
>>
>> so there is a conflict with FS_COW_FL and EXT4_SNAPFILE_FL. =A0I don=
't know the semantics of those two flags enough to say for sure whether=
 it is reasonable that they alias to each other, but at first glance "C=
OW" and "SNAPSHOT" don't seem completely unrelated.

EXT4_SNAPFILE_FL indicates a special system snapshot file, so it has
no equivalence relation with FS_COW_FL.
Please use 0x02000000 for FS_COW_FL.

EXT4_SNAPFILE_DELETED_FL is a persistent state of a snapshot file,
which is no longer
available as a mountable device, but cannot be unlinked because it
holds changed data sets
needed by older snapshots.

EXT4_SNAPFILE_SHRUNK_FL is a persistent state of a (deleted) snapshot
file, which has
undergone a "shrink" process to free all change sets not needed by
older snapshots.
The persistence of the flag is needed to avoid tedious shrinking when
it is not needed.


>
> In the btrfs case FS_COW_FL means to do COW even when there are no
> snapshots. =A0FS_NOCOW_FL means to do cow only when there are snapsho=
ts.
>

I am interested in FS_NOCOW_FL as well, but for my implementation it wo=
uld mean
do not do COW on rewrites even when there are snapshots, so a user can
create a pre-allocated
"island of blocks", which are pinned to a physical location, for raw
VM image for example.


Thanks,
Amir.
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
