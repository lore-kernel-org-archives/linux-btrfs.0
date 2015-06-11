Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49302 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751634AbbFKTqP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Jun 2015 15:46:15 -0400
Message-ID: <5579E583.4020209@suse.com>
Date: Thu, 11 Jun 2015 15:46:11 -0400
From: Jeff Mahoney <jeffm@suse.com>
MIME-Version: 1.0
To: Chris Mason <clm@fb.com>, fdmanana@gmail.com
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 1/4] btrfs: skip superblocks during discard
References: <1434036062-21597-1-git-send-email-jeffm@suse.com>	<1434036062-21597-2-git-send-email-jeffm@suse.com>	<CAL3q7H5Hsv2HvBgu_kOEDwXK_53+_1GH9WC_Upa+X8Lhd7sXng@mail.gmail.com>	<5579D0A2.7000407@suse.com> <CAL3q7H7Q-789EkzcBGzMWuAXDJ9t3E-qeMJkRKYASb6NSr7JTQ@mail.gmail.com> <5579DE52.2060502@suse.com> <5579E069.6060404@fb.com> <5579E13A.5030903@suse.com> <5579E301.6050908@fb.com>
In-Reply-To: <5579E301.6050908@fb.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 6/11/15 3:35 PM, Chris Mason wrote:
> On 06/11/2015 03:27 PM, Jeff Mahoney wrote:
>> On 6/11/15 3:24 PM, Chris Mason wrote:
>>> On 06/11/2015 03:15 PM, Jeff Mahoney wrote:
>>>> On 6/11/15 2:44 PM, Filipe David Manana wrote:
>>>>> On Thu, Jun 11, 2015 at 7:17 PM, Jeff Mahoney 
>>>>> <jeffm@suse.com> wrote: On 6/11/15 12:47 PM, Filipe David 
>>>>> Manana wrote:
>>>>>>>> On Thu, Jun 11, 2015 at 4:20 PM,  <jeffm@suse.com> 
>>>>>>>> wrote:
>>>>>>>>> From: Jeff Mahoney <jeffm@suse.com>
>>>>>>>>> 
>>>>>>>>> Btrfs doesn't track superblocks with extent
>>>>>>>>> records so there is nothing persistent on-disk to
>>>>>>>>> indicate that those blocks are in use.  We track
>>>>>>>>> the superblocks in memory to ensure they don't get
>>>>>>>>> used by removing them from the free space cache
>>>>>>>>> when we load a block group from disk.  Prior to
>>>>>>>>> 47ab2a6c6a (Btrfs: remove empty block groups
>>>>>>>>> automatically), that was fine since the block group
>>>>>>>>> would never be reclaimed so the superblock was
>>>>>>>>> always safe. Once we started removing the empty
>>>>>>>>> block groups, we were protected by the fact that
>>>>>>>>> discards weren't being properly issued for unused
>>>>>>>>> space either via FITRIM or -odiscard. The block
>>>>>>>>> groups were still being released, but the blocks
>>>>>>>>> remained on disk.
>>>>>>>>> 
>>>>>>>>> In order to properly discard unused block groups, 
>>>>>>>>> we need to filter out the superblocks from the 
>>>>>>>>> discard range. Superblocks are located at fixed 
>>>>>>>>> locations on each device, so it makes sense to 
>>>>>>>>> filter them out in btrfs_issue_discard, which is 
>>>>>>>>> used by both -odiscard and FITRIM.
>>>>>>>>> 
>>>>>>>>> Signed-off-by: Jeff Mahoney <jeffm@suse.com> --- 
>>>>>>>>> fs/btrfs/extent-tree.c | 50 
>>>>>>>>> ++++++++++++++++++++++++++++++++++++++++++++------ 
>>>>>>>>> 1 file changed, 44 insertions(+), 6 deletions(-)
>>>>>>>>> 
>>>>>>>>> diff --git a/fs/btrfs/extent-tree.c 
>>>>>>>>> b/fs/btrfs/extent-tree.c index 0ec3acd..75d0226 
>>>>>>>>> 100644 --- a/fs/btrfs/extent-tree.c +++ 
>>>>>>>>> b/fs/btrfs/extent-tree.c @@ -1884,10 +1884,47 @@ 
>>>>>>>>> static int remove_extent_backref(struct 
>>>>>>>>> btrfs_trans_handle *trans, return ret; }
>>>>>>>>> 
>>>>>>>>> -static int btrfs_issue_discard(struct block_device
>>>>>>>>> *bdev, - u64 start, u64 len) +#define in_range(b,
>>>>>>>>> first, len) ((b)
>>>>>>>>>> = (first) && (b) < (first) + (len))
>>>>>>>> 
>>>>>>>> Hi Jeff,
>>>>>>>> 
>>>>>>>> So this will work if every caller behaves well and 
>>>>>>>> passes a region whose start and end offsets are a 
>>>>>>>> multiple of the sector size (4096) which currently 
>>>>>>>> matches the superblock size.
>>>>>>>> 
>>>>>>>> However, I think it would be safer to check for the 
>>>>>>>> case where the start offset of a superblock mirror
>>>>>>>> is < (first) and (sb_offset + sb_len) > (first).
>>>>>>>> Just to deal with cases where for example the 2nd
>>>>>>>> half of the sb starts at offset (first).
>>>>>>>> 
>>>>>>>> I guess this sectorsize becoming less than 4096 will
>>>>>>>>  happen sooner or later with the subpage sectorsize 
>>>>>>>> patch set, so it wouldn't hurt to make it more
>>>>>>>> bullet proof already.
>>>> 
>>>>> Is that something anyone intends to support?  While I 
>>>>> suppose the subpage sector patch /could/ be used to allow 
>>>>> file systems with a node size under 4k, the intention is 
>>>>> the other way around -- systems that have higher order
>>>>> page sizes currently don't work with btrfs file system
>>>>> created on systems with smaller order page sizes like x86.
>> 
>>> The best use of smaller node sizes is just to test the 
>>> subpagesize patches on more common hardware.  I wouldn't
>>> expect anyone to use a 1K node size in production.
>> 
>> Any chance we can enforce that?  Like with a compile-time
>> option? :)
> 
> We can make mkfs.btrfs advise strongly against it ;)
> 
> But, since I wasn't horribly clear, I'd love one extra if
> statement in the discard function.  Silently eating bytes is
> horribly hard to track down.

Heh, yeah.  I'm making it bulletproof now.  If the goal is to also
catch potential misbehavior, I'm catching some other cases as well.  A
few extra conditionals will still take a small percentage of the time
a discard takes.

- -Jeff

- -- 
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.19 (Darwin)

iQIcBAEBAgAGBQJVeeWDAAoJEB57S2MheeWygMEQAMPCNf8ZIMfYRDkzbpW0mezB
6Vbu7PM5WNAqOU2XdJXq47Z+jvLzsbBG0Z1hDLdavkQiOfjOQeBDvwVQQwFPizJ9
lRA4HB6P0nMKVl4x4PcXzgRinrIIy46nFY7VFZBe/cO0aEq7bsB3/vjlRj4LKvsp
eeMg212Sc4V6yuVbSfLSgYTtMGcAsmE9rUWl+2+kV6aTGqZr72YG1033YVu9Y+0F
vnelEIKFSmYF1y7FqO8Ejpk7G6fOoKYXGIxjcyC5v6kAKygZkxuUFYt9wPgpxl4X
eTYnPwjRwE3qRHlZtCGmb0SKvIkFMeKaI5Dy8KXUSHu6Q4NZ8q+kftgzNTGHcEzD
EgGrsbMa3N6necDYsmKYrIWVq21Nj2vSZc7YmLDKYtVQJRH2ScPOvHQlosEX8JsA
h4DfSp8fLVWu8hAORrUvByrGfw7DkFOlv1bF4B76MokP7sb4ITnpBUJtW+0Uiw3x
n1OJ94RiFOXpxWvEYquZUnK/9k1cg/eCwDpaFTCSDrTOVfW78lnoso1VKhQ1CJLg
Ed3I77RA0jPE004hpwtLdGE2AMiOZfAMKTAPkErnnWMfcrBh9O8DUBWVXds3IBSg
mv6lKPz24P28ymOINkqFC22D1vyXBH4Xiel0ZuPHHjnrxPUwovrF//XRbwcc7lCf
jzsGyTnEnAf00/R8s7sP
=v4r5
-----END PGP SIGNATURE-----
