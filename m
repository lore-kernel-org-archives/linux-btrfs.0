Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:9382 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753019AbbIWCPC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Sep 2015 22:15:02 -0400
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: "'Jeff Mahoney'" <jeffm@suse.com>, <linux-btrfs@vger.kernel.org>
References: <15fc8f8d002e4ffcdb46e769736f240ae7ace20b.1442839332.git.zhaolei@cn.fujitsu.com> <560150CD.6070301@suse.com>
In-Reply-To: <560150CD.6070301@suse.com>
Subject: RE: [PATCH] btrfs: Fix no space bug caused by removing bg
Date: Wed, 23 Sep 2015 10:14:58 +0800
Message-ID: <022d01d0f5a5$a5444c70$efcce550$@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, Jeff Mahoney

> -----Original Message-----
> From: Jeff Mahoney [mailto:jeffm@suse.com]
> Sent: Tuesday, September 22, 2015 9:00 PM
> To: Zhao Lei <zhaolei@cn.fujitsu.com>; linux-btrfs@vger.kernel.org
> Subject: Re: [PATCH] btrfs: Fix no space bug caused by removing bg
> 
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> On 9/21/15 8:59 AM, Zhao Lei wrote:
> > btrfs in v4.3-rc1 failed many xfstests items with '-o nospace_cache'
> > mount option.
> >
> > Failed cases are:
> > btrfs/008,016,019,020,026,027,028,029,031,041,046,048,050,051,053,054,
> >
> >
> 077,083,084,087,092,094
> > generic/004,010,014,023,024,074,075,080,086,087,089,091,092,100,112,12
> 3,
> >
> >
> 124,125,126,127,131,133,192,193,198,207,208,209,213,214,215,228,239,240
> ,
> > 246,247,248,255,263,285,306,313,316,323
> >
> > We can reproduce this bug with following simple command:
> > TEST_DEV=/dev/vdh TEST_DIR=/mnt/tmp
> >
> > umount "$TEST_DEV" >/dev/null mkfs.btrfs -f "$TEST_DEV" mount
> > "$TEST_DEV" "$TEST_DIR"
> >
> > umount "$TEST_DEV" mount "$TEST_DEV" "$TEST_DIR"
> >
> > cp /bin/bash $TEST_DIR
> >
> > Result is: (omit previous commands) # cp /bin/bash $TEST_DIR cp:
> > writing `/mnt/tmp/bash': No space left on device
> >
> > By bisect, we can see it is triggered by patch titled: commit
> > e44163e17796 ("btrfs: explictly delete unused block groups in
> > close_ctree and ro-remount")
> >
> > But the wrong code is not in above patch, btrfs delete all chunks if
> > no data in filesystem, and above patch just make it obviously.
> >
> > Detail reason: 1: mkfs a blank filesystem, or delete everything in
> > filesystem 2: umount fs (current code will delete all data chunks)
> > 3: mount fs Because no any data chunks, data's space_cache have no
> > chance to init, it means: space_info->total_bytes == 0, and
> > space_info->full == 1. 4: do some write Current code will ignore chunk
> > allocate because space_info->full, and return -ENOSPC.
> >
> > Fix: Don't auto-delete last blockgroup for a raid type.
> 
> The only reason not to do this is the loss off the raid type, which is an issue that
> needs to be addressed separately.  As Filipe said in his responses, this isn't
> the source of the problem - it just makes it obvious.  We've seen in actual bug
> reports that it's possible to create exactly the same scenario by balancing an
> empty file system.
> 
I replied it in filipe's mail, in short, I'll change the patch title and description.

> So if they way we want to prevent the loss of raid type info is by maintaining the
> last block group allocated with that raid type, fine, but that's a separate
> discussion.  Personally, I think keeping 1GB allocated as a placeholder is a bit
> much.  Beyond that, I've been thinking casually about ways to direct the
> allocator to use certain devices for certain things (e.g. in a hybrid system with
> SSDs and HDDs, always allocate metadata on the SSD) and there's some
> overlap there.
Good idea!
It will increase performance.

Thanks
Zhaolei

> As it stands, we can fake that in mkfs but it'll get stomped by
> balance nearly immediately.
> 
> - -Jeff
> 
> > If we delete all blockgroup for a raidtype, it not only cause above
> > bug, but also may change filesystem to all-single in some case.
> >
> > Test: Test by above script, and confirmed the logic by debug output.
> >
> > Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com> ---
> > fs/btrfs/extent-tree.c | 3 ++- 1 file changed, 2 insertions(+), 1
> > deletion(-)
> >
> > diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c index
> > 5411f0a..35cf7eb 100644 --- a/fs/btrfs/extent-tree.c +++
> > b/fs/btrfs/extent-tree.c @@ -10012,7 +10012,8 @@ void
> > btrfs_delete_unused_bgs(struct btrfs_fs_info *fs_info) bg_list);
> > space_info = block_group->space_info;
> > list_del_init(&block_group->bg_list); -		if (ret ||
> > btrfs_mixed_space_info(space_info)) { +		if (ret ||
> > btrfs_mixed_space_info(space_info) || +		    block_group->list.next
> > == block_group->list.prev) { btrfs_put_block_group(block_group);
> > continue; }
> >
> 
> 
> - --
> Jeff Mahoney
> SUSE Labs
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG/MacGPG2 v2.0.19 (Darwin)
> 
> iQIcBAEBAgAGBQJWAVDNAAoJEB57S2MheeWyCwoQAId9IK0vYX01W20SeLt5E
> 5ql
> cabIeN3JCLcmtEbJzhNxQtcjvB7Rgq/r3BRDV0n0Z71dyv8WV8vau4Qka8xUVtLL
> l+sbuRIEBUR3UHOvqjV7MxSZeZrQZLWeGuCRH9El059hDn/JFsF9n3wJx8YsgXKe
> dma2RG6MHFVXY08jYkLc6nexBbYlc3Dj2jbd2Jr7gHy4YwFTCM9YncR+STV2K47
> Q
> N/pfRwiVHFHHVTju5lg3wzp+xvFPeU52cfWHL05axe8l75pU6Ywwrk406QxyrTvx
> 2Rh8tXBJItUeMA/D8mRnwWVZBWFUndl6JlBNSyf51fSP+4lPkChbM5UnSOjDOw
> vE
> E7XpGy31TQI0bqpy8qoIkI9wkek6iOlMCppZ9U2vICbeP+65WtNZKfQcCO0t6Z1H
> 6IqfHsaDvvaiorxEWWIarsIfHZWnWJeav545t6pd4VU3v52YQN2YIOLY8EhWv4W
> t
> 90Xc1izPvPvnyQa3eQPg1ISdqNfJRFlYjSJ75zGvSPurIy77oOyvPa1EfEO7IMys
> zXyjgKzU6Yox1iXxeJsDxuAa+FX9P2rXqd8WYP2mBRqH2BE6D+R8V/NitGmXSkYA
> bBXN1H/m+gP5qhHLnBQZU+ABH1dDp6RJ1BCsg7iDJBmfE+hJI8YIwowwH/C0R
> BST
> 1HgsAUWHmDsjHcYr3/ZB
> =Li+/
> -----END PGP SIGNATURE-----

