Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42477 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754595AbbFKSRL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Jun 2015 14:17:11 -0400
Message-ID: <5579D0A2.7000407@suse.com>
Date: Thu, 11 Jun 2015 14:17:06 -0400
From: Jeff Mahoney <jeffm@suse.com>
MIME-Version: 1.0
To: fdmanana@gmail.com
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 1/4] btrfs: skip superblocks during discard
References: <1434036062-21597-1-git-send-email-jeffm@suse.com>	<1434036062-21597-2-git-send-email-jeffm@suse.com> <CAL3q7H5Hsv2HvBgu_kOEDwXK_53+_1GH9WC_Upa+X8Lhd7sXng@mail.gmail.com>
In-Reply-To: <CAL3q7H5Hsv2HvBgu_kOEDwXK_53+_1GH9WC_Upa+X8Lhd7sXng@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 6/11/15 12:47 PM, Filipe David Manana wrote:
> On Thu, Jun 11, 2015 at 4:20 PM,  <jeffm@suse.com> wrote:
>> From: Jeff Mahoney <jeffm@suse.com>
>> 
>> Btrfs doesn't track superblocks with extent records so there is
>> nothing persistent on-disk to indicate that those blocks are in
>> use.  We track the superblocks in memory to ensure they don't get
>> used by removing them from the free space cache when we load a
>> block group from disk.  Prior to 47ab2a6c6a (Btrfs: remove empty
>> block groups automatically), that was fine since the block group
>> would never be reclaimed so the superblock was always safe.  Once
>> we started removing the empty block groups, we were protected by
>> the fact that discards weren't being properly issued for unused
>> space either via FITRIM or -odiscard.  The block groups were 
>> still being released, but the blocks remained on disk.
>> 
>> In order to properly discard unused block groups, we need to
>> filter out the superblocks from the discard range.  Superblocks
>> are located at fixed locations on each device, so it makes sense
>> to filter them out in btrfs_issue_discard, which is used by both
>> -odiscard and FITRIM.
>> 
>> Signed-off-by: Jeff Mahoney <jeffm@suse.com> --- 
>> fs/btrfs/extent-tree.c | 50
>> ++++++++++++++++++++++++++++++++++++++++++++------ 1 file
>> changed, 44 insertions(+), 6 deletions(-)
>> 
>> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c 
>> index 0ec3acd..75d0226 100644 --- a/fs/btrfs/extent-tree.c +++
>> b/fs/btrfs/extent-tree.c @@ -1884,10 +1884,47 @@ static int
>> remove_extent_backref(struct btrfs_trans_handle *trans, return
>> ret; }
>> 
>> -static int btrfs_issue_discard(struct block_device *bdev, -
>> u64 start, u64 len) +#define in_range(b, first, len)        ((b)
>> >= (first) && (b) < (first) + (len))
> 
> Hi Jeff,
> 
> So this will work if every caller behaves well and passes a region 
> whose start and end offsets are a multiple of the sector size
> (4096) which currently matches the superblock size.
> 
> However, I think it would be safer to check for the case where the 
> start offset of a superblock mirror is < (first) and (sb_offset + 
> sb_len) > (first).  Just to deal with cases where for example the
> 2nd half of the sb starts at offset (first).
> 
> I guess this sectorsize becoming less than 4096 will happen sooner
> or later with the subpage sectorsize patch set, so it wouldn't hurt
> to make it more bullet proof already.

Is that something anyone intends to support?  While I suppose the
subpage sector patch /could/ be used to allow file systems with a node
size under 4k, the intention is the other way around -- systems that
have higher order page sizes currently don't work with btrfs file
system created on systems with smaller order page sizes like x86.
Btrfs already has high enough metadata overhead.  Pretty much all new
hardware has, at least, a native 4k sector size even if it's
abstracted behind a RMW layer.  The sectors are only going to get
larger.  With the metadata overhead that btrfs already incurs, I can't
imagine any production use case with smaller sector sizes.

Are we looking to support <4k nodes to test the subpage sector code on
x86?  If so, then I'll change this to handle the possibility of
superblocks crossing sector boundaries.  Otherwise, it's protecting
against a use case that just shouldn't happen.

> Otherwise it looks good to me. I'll give a test on this patchset
> soon.

Thanks,

- -Jeff


- -- 
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.19 (Darwin)

iQIcBAEBAgAGBQJVedCiAAoJEB57S2MheeWymA4P/2Y+YGwAkcbYxrlMVH/wIGpN
j+qO/y1YHNJQNiRHt/1ahM8wy2DEEbqrD36xUuX5lDYRREo9jeqIGGajOOHg/KFw
7q6zIWVEEwom/RKd9CX48TC2pHly5Fw8ESyi+A857KJ1ZHcpKdyNcIwle/Jsoe0q
a+SX6hJPlHFVai/QZhBRO00ZgXlTwjXAGyfgmfuHERY6lS5PBmoA8tYxnigpnBOa
PUrgw+Cdn4glrZUTpt3WN4H5oE+pD6cGMQ+GnFXQYaytssyQNuPpCWdQ1Aferg7u
Af3E6iBj776bQIRTWZSwjXTMLWHVjnBmdU8D+wXE7Ar3oU1POL7NLvnGm4Yr9TWZ
n1NXcBhJ4QQQXBprK3bI+WNSzMzMLdvJHIb5t2Z9BO8wd5Ws0QlmT8Gl+u/ZofZU
8eouhLgu1hZzPeJgXPuDu0S8QaFtpI0zlupOwJByHp9QSzpUw98xqlFXIRtnLc48
n/ZMFi98EMroaQx0hzFLGMwp/57tUFWUUroDkfP1NngoE482ohPHAdREtr7+RZe6
h+pfF+//5CycYxk8BciBmCyLWWTW1WdDL/MzQsXdKE+797cNk79+W5EKYLmQiAbW
IGyRXMj+XPpWNC1VM12JJXdoOujSGocmJa28jKanZRzqw0HKJOlTUBqNoBV83Bph
ChcTZyhAi3PCsib+mNnW
=wb8l
-----END PGP SIGNATURE-----
