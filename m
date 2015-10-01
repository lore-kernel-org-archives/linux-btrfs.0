Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57949 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750915AbbJAOoh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 1 Oct 2015 10:44:37 -0400
Subject: Re: [PATCH v2 1/2] btrfs: Fix lost-data-profile caused by auto
 removing bg
To: Zhao Lei <zhaolei@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <aaa2dcf7018bd29459e20f0571ff490fe1abee51.1443611403.git.zhaolei@cn.fujitsu.com>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <560D46CF.3020405@suse.com>
Date: Thu, 1 Oct 2015 10:44:31 -0400
MIME-Version: 1.0
In-Reply-To: <aaa2dcf7018bd29459e20f0571ff490fe1abee51.1443611403.git.zhaolei@cn.fujitsu.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 9/30/15 7:11 AM, Zhao Lei wrote:
> Reproduce: (In integration-4.3 branch)
> 
> TEST_DEV=(/dev/vdg /dev/vdh) TEST_DIR=/mnt/tmp
> 
> umount "$TEST_DEV" >/dev/null mkfs.btrfs -f -d raid1
> "${TEST_DEV[@]}"
> 
> mount -o nospace_cache "$TEST_DEV" "$TEST_DIR" umount "$TEST_DEV"
> 
> mount -o nospace_cache "$TEST_DEV" "$TEST_DIR" btrfs filesystem
> usage $TEST_DIR
> 
> We can see the data chunk changed from raid1 to single: # btrfs
> filesystem usage $TEST_DIR Data,single: Size:8.00MiB, Used:0.00B 
> /dev/vdg        8.00MiB #
> 
> Reason: When a empty filesystem mount with -o nospace_cache, the
> last data blockgroup will be auto-removed in umount.
> 
> Then if we mount it again, there is no data chunk in the 
> filesystem, so the only available data profile is 0x0, result is
> all new chunks are created as single type.
> 
> Fix: Don't auto-delete last blockgroup for a raid type.

I still think this is kind of a hacky solution, but it's the best one
that doesn't involve a disk format change.

> Test: Test by above script, and confirmed the logic by debug
> output.
> 
> Changelog v1->v2: 1: Put code of checking block_group->list into 
> semaphore of space_info->groups_sem. Noticed-by: Filipe Manana
> <fdmanana@gmail.com>
> 
> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com> --- 
> fs/btrfs/extent-tree.c | 12 +++++++++++- 1 file changed, 11
> insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c index
> 79a5bd9..ed9426c 100644 --- a/fs/btrfs/extent-tree.c +++
> b/fs/btrfs/extent-tree.c @@ -10010,8 +10010,18 @@ void
> btrfs_delete_unused_bgs(struct btrfs_fs_info *fs_info) block_group
> = list_first_entry(&fs_info->unused_bgs, struct
> btrfs_block_group_cache, bg_list); -		space_info =
> block_group->space_info; list_del_init(&block_group->bg_list); + +
> space_info = block_group->space_info; + +
> down_read(&space_info->groups_sem); +		if (block_group->list.next
> == block_group->list.prev) {

		if (list_is_singular(&block_group->list)) {

> +			up_read(&space_info->groups_sem); +
> btrfs_put_block_group(block_group); +			continue; +		} +
> up_read(&space_info->groups_sem); + if (ret ||
> btrfs_mixed_space_info(space_info)) { 
> btrfs_put_block_group(block_group); continue;
> 

- -Jeff

- -- 
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.19 (Darwin)

iQIcBAEBAgAGBQJWDUbPAAoJEB57S2MheeWypfIP/2Xkl+QH4bTu1Nkad+52+BQW
CaPnc8x6JkM6VoUKLVF2mN5yimW4CUxo2u4Bui34VtUEXb5LJ3YBq8RR6JXcO5Ip
MtZPjTatgq3K8loHRSRmZP9FRdyGOL3yvTtJ+inGV1SFFjd7XW7buKdhJnjgObwC
IK/OpPGLTAFOjf/hB2ge8A4LbfExkcWLk6dC5QJhjpnAhDajwZ6+McnEWKWYjE9T
J+U6B+sp2IgU2lWCLBH5OpOBHMA8HdSjDTWW6AcHIVOQ4ame7YrlZi7lZ2mVKfHo
7/e0Pxr4C7y/otxZWl9a5T4VYZljAUiqor4bR8chaHSLz42FaJOXcw62w3ScqCxA
e7hUf2Kq0QLPcXf5m1BWiwKdzjmqO0sY6iYGMIfkdD8IPaYIaAIdaCUk2KZUKYk6
+Lw1H5PoVh1SQ37q40CPelZOD1aPvpvo2+bmJEV1ENx9L4ZLITVll+dMN+h8rCbN
EqhbL0kyAtx7JpI0OiUhGFllBDHKdF+t9RlCacu5YJNxGyV28p1nC/d3DvTSOTQ8
5a7vFThLjoGnL+pLdZf28ZJ+fUEbupRqSfRdIR0OZ5NOTwFNGed3L8w+ZLhzQY4o
SP1J0RSuW5FJG1wT7qaUlfMfrqpBlUvanf3wkk58u8F9Moxrkn52/hG/w1SKvWP9
a0s4mZnD250jv+uwtcG7
=ua/t
-----END PGP SIGNATURE-----
