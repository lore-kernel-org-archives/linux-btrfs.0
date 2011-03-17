From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 1/2] Btrfs: add datacow flag in inode flag
Date: Thu, 17 Mar 2011 16:37:34 +0200
Message-ID: <AANLkTi=eUT8tm9v8ozDOc_W9MBGr=ccVRXYpASRFT4vZ@mail.gmail.com>
References: <4D6F52DE.5080508@cn.fujitsu.com>
	<1300220702-sup-5062@think>
	<20110315205724.GB10360@lst.de>
	<E3D32D88-C93F-4B5A-8CCF-810A9519AE9D@dilger.ca>
	<1300232002-sup-6976@think>
	<AANLkTin3+kjzjN8LE+Sbc8ngVHLFpmU=n9tNKMY0EPrU@mail.gmail.com>
	<4D816D81.4080208@cn.fujitsu.com>
	<1300371584-sup-1674@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: liubo <liubo2009@cn.fujitsu.com>,
	Andreas Dilger <adilger@dilger.ca>,
	Christoph Hellwig <hch@lst.de>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Theodore Tso <tytso@mit.edu>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1300371584-sup-1674@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 17, 2011 at 4:21 PM, Chris Mason <chris.mason@oracle.com> w=
rote:
> Excerpts from liubo's message of 2011-03-16 22:10:09 -0400:
>> On 03/16/2011 05:06 PM, Amir Goldstein wrote:
>> > On Wed, Mar 16, 2011 at 1:35 AM, Chris Mason <chris.mason@oracle.c=
om> wrote:
>> >> Excerpts from Andreas Dilger's message of 2011-03-15 18:06:49 -04=
00:
>> >>> On 2011-03-15, at 2:57 PM, Christoph Hellwig wrote:
>> >>>> On Tue, Mar 15, 2011 at 04:26:50PM -0400, Chris Mason wrote:
>> >>>>> =A0#define FS_EXTENT_FL =A0 =A0 =A0 =A0 0x00080000 /* Extents =
*/
>> >>>>> =A0#define FS_DIRECTIO_FL =A0 =A0 =A0 0x00100000 /* Use direct=
 i/o */
>> >>>>> +#define FS_NOCOW_FL =A0 =A0 =A0 =A0 =A00x00800000 /* Do not c=
ow file */
>> >>>>> +#define FS_COW_FL =A0 =A0 =A0 =A0 =A0 =A00x01000000 /* Cow fi=
le */
>> >>>>> =A0#define FS_RESERVED_FL =A0 =A0 =A0 0x80000000 /* reserved f=
or ext2 lib */
>> >>>> I'm fine with it. =A0I'll defer the check for conflicts with ex=
tN-specific flags
>> >>>> to Ted, though.
>> >>> Looking at the upstream e2fsprogs I see in that range:
>> >>>
>> >>>> #define EXT4_EXTENTS_FL =A0 =A0 =A0 =A0 =A0 0x00080000 /* Inode=
 uses extents */
>> >>>> #define EXT4_EA_INODE_FL =A0 =A0 =A0 =A0 =A00x00200000 /* Inode=
 used for large EA */
>> >>>> #define EXT4_EOFBLOCKS_FL =A0 =A0 =A0 =A0 0x00400000 /* Blocks =
allocated beyond EOF */
>> >>>> #define EXT4_SNAPFILE_FL =A0 =A0 =A0 =A0 =A00x01000000 /* Inode=
 is a snapshot */
>> >>>> #define EXT4_SNAPFILE_DELETED_FL =A00x04000000 /* Snapshot is b=
eing deleted */
>> >>>> #define EXT4_SNAPFILE_SHRUNK_FL =A0 0x08000000 /* Snapshot shri=
nk has completed */
>> >>>> #define EXT2_RESERVED_FL =A0 =A0 =A0 =A0 =A00x80000000 /* reser=
ved for ext2 lib */
>> >>>>
>> >>>> #define EXT2_FL_USER_VISIBLE =A0 =A0 =A00x004BDFFF /* User visi=
ble flags */
>> >>> so there is a conflict with FS_COW_FL and EXT4_SNAPFILE_FL. =A0I=
 don't know the semantics of those two flags enough to say for sure whe=
ther it is reasonable that they alias to each other, but at first glanc=
e "COW" and "SNAPSHOT" don't seem completely unrelated.
>> >
>> > EXT4_SNAPFILE_FL indicates a special system snapshot file, so it h=
as
>> > no equivalence relation with FS_COW_FL.
>> > Please use 0x02000000 for FS_COW_FL.
>>
>> Fine with that, but it's up to Chris. :)
>
> I'd rather not conflict unless we're critically short on space.
>
>> >
>> > EXT4_SNAPFILE_DELETED_FL is a persistent state of a snapshot file,
>> > which is no longer
>> > available as a mountable device, but cannot be unlinked because it
>> > holds changed data sets
>> > needed by older snapshots.
>> >
>> > EXT4_SNAPFILE_SHRUNK_FL is a persistent state of a (deleted) snaps=
hot
>> > file, which has
>> > undergone a "shrink" process to free all change sets not needed by
>> > older snapshots.
>> > The persistence of the flag is needed to avoid tedious shrinking w=
hen
>> > it is not needed.
>> >
>> >
>> >> In the btrfs case FS_COW_FL means to do COW even when there are n=
o
>> >> snapshots. =A0FS_NOCOW_FL means to do cow only when there are sna=
pshots.
>> >>
>> >
>> > I am interested in FS_NOCOW_FL as well, but for my implementation =
it would mean
>> > do not do COW on rewrites even when there are snapshots, so a user=
 can
>> > create a pre-allocated
>> > "island of blocks", which are pinned to a physical location, for r=
aw
>> > VM image for example.
>
> I'm not sure how the island of blocks idea can work with snapshots?
> Wouldn't the snapshot corrupt if anything in the island were changed?
>

It would corrupt, but only to the extent that the file to which you req=
uested
NOCOW may contain newer data. It cannot contain uninitialized data,
because truncating the file would leave it's blocks referenced by the s=
napshot.

Think of a large database file, which is already replicated and hot bac=
ked up
regularly. An arbitrary snapshot of that file will give you a copy for
disaster recovery
at best. Not sure this is worth the effort of COWing it and
fragmenting it beyond
recognition.

Amir.
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
