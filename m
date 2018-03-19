Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:37316 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755187AbeCSIUM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Mar 2018 04:20:12 -0400
Date: Mon, 19 Mar 2018 08:20:10 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs-progs: mkfs: add uuid and otime to ROOT_ITEM of
 FS_TREE
Message-ID: <20180319082010.GC17966@carfax.org.uk>
References: <7ca269db-a724-5938-f4d8-b85e893fd558@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="kfjH4zxOES6UT95V"
In-Reply-To: <7ca269db-a724-5938-f4d8-b85e893fd558@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--kfjH4zxOES6UT95V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 19, 2018 at 05:16:42PM +0900, Misono, Tomohiro wrote:
> Currently, the top-level subvolume lacks the UUID. As a result, both
> non-snapshot subvolume and snapshot of top-level subvolume do not have
> Parent UUID and cannot be distinguisued. Therefore "fi show" of
> top-level lists all the subvolumes which lacks the UUID in
> "Snapshot(s)" filed.  Also, it lacks the otime information.
> 
> Fix this by adding the UUID and otime at the mkfs time.  As a
> consequence, snapshots of top-level subvolume now have a Parent UUID and
> UUID tree will create an entry for top-level subvolume at mount time.
> This should not cause the problem for current kernel, but user program
> which relies on the empty Parent UUID may be affected by this change.

   Is there any way of adding a UUID to the top level subvol on an
existing filesystem? It would be helpful not to have to rebuild every
filesystem in the world to fix this.

   Hugo.

> Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
> ---
> This is also needed in order that "sub list -s" works properly for
> non-privileged user[1] even if there are snapshots of toplevel subvolume.
> 
> Currently the check if a subvolume is a snapshot is done by looking at the key
> offset of ROOT_ITEM of subvolume (non-zero for snapshot) used by tree search ioctl.
> However, non-privileged version of "sub list" won't use tree search ioctl and just
> looking if parent uuid is null or not. Therefore there is no way to recognize
> snapshots of toplevel subvolume.
> 
> [1] https://marc.info/?l=linux-btrfs&m=152144463907830&w=2
> 
>  mkfs/common.c | 14 ++++++++++++++
>  mkfs/main.c   |  3 +++
>  2 files changed, 17 insertions(+)
> 
> diff --git a/mkfs/common.c b/mkfs/common.c
> index 16916ca2..6924d9b7 100644
> --- a/mkfs/common.c
> +++ b/mkfs/common.c
> @@ -44,6 +44,7 @@ static int btrfs_create_tree_root(int fd, struct btrfs_mkfs_config *cfg,
>  	u32 itemoff;
>  	int ret = 0;
>  	int blk;
> +	u8 uuid[BTRFS_UUID_SIZE];
>  
>  	memset(buf->data + sizeof(struct btrfs_header), 0,
>  		cfg->nodesize - sizeof(struct btrfs_header));
> @@ -77,6 +78,19 @@ static int btrfs_create_tree_root(int fd, struct btrfs_mkfs_config *cfg,
>  		btrfs_set_item_offset(buf, btrfs_item_nr(nritems), itemoff);
>  		btrfs_set_item_size(buf, btrfs_item_nr(nritems),
>  				sizeof(root_item));
> +		if (blk == MKFS_FS_TREE) {
> +			time_t now = time(NULL);
> +
> +			uuid_generate(uuid);
> +			memcpy(root_item.uuid, uuid, BTRFS_UUID_SIZE);
> +			btrfs_set_stack_timespec_sec(&root_item.otime, now);
> +			btrfs_set_stack_timespec_sec(&root_item.ctime, now);
> +		} else {
> +			memset(uuid, 0, BTRFS_UUID_SIZE);
> +			memcpy(root_item.uuid, uuid, BTRFS_UUID_SIZE);
> +			btrfs_set_stack_timespec_sec(&root_item.otime, 0);
> +			btrfs_set_stack_timespec_sec(&root_item.ctime, 0);
> +		}
>  		write_extent_buffer(buf, &root_item,
>  			btrfs_item_ptr_offset(buf, nritems),
>  			sizeof(root_item));
> diff --git a/mkfs/main.c b/mkfs/main.c
> index 5a717f70..52d92581 100644
> --- a/mkfs/main.c
> +++ b/mkfs/main.c
> @@ -315,6 +315,7 @@ static int create_tree(struct btrfs_trans_handle *trans,
>  	struct btrfs_key location;
>  	struct btrfs_root_item root_item;
>  	struct extent_buffer *tmp;
> +	u8 uuid[BTRFS_UUID_SIZE] = {0};
>  	int ret;
>  
>  	ret = btrfs_copy_root(trans, root, root->node, &tmp, objectid);
> @@ -325,6 +326,8 @@ static int create_tree(struct btrfs_trans_handle *trans,
>  	btrfs_set_root_bytenr(&root_item, tmp->start);
>  	btrfs_set_root_level(&root_item, btrfs_header_level(tmp));
>  	btrfs_set_root_generation(&root_item, trans->transid);
> +	/* clear uuid of source tree */
> +	memcpy(root_item.uuid, uuid, BTRFS_UUID_SIZE);
>  	free_extent_buffer(tmp);
>  
>  	location.objectid = objectid;

-- 
Hugo Mills             | This chap Anon is writing some perfectly lovely
hugo@... carfax.org.uk | stuff at the moment.
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--kfjH4zxOES6UT95V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJar3K6AAoJEFheFHXiqx3khOUP/2K25tM4S4PPBjCag7KPTYUQ
LpcuEYJHOrA7Po3b/PC20OArr9xMWX3aZHgJ8aMZDYGCko5ZjWfCIcRmDp5kqn7i
Xfzyfp+TXVMUA2oKWGZUcO8Xopq3B4f9qa1ES8QWR8iJxRODieVHMwBEEfAtizYU
ke4i/MHF0wSXwQQcYiylgYeG52dbrgveMVsqc2XBpuVvXa3D3S6ZsWYaKg78qloV
BZrwGo03mTHq4w0o2llTwEnJvXeeqAbTIAZMml5VIOnN5ufz8N0ANrCRsJBOm5UC
vWrm0GsRcyBtnS2vFfu1A+6r7WBwa6aXI88K87kYvkYB4gJtz/xn7FAKKNb/jyVB
LpCUpNhckc9HQB5w6aMsplZ/486OmqLFIyI7du8byJEA3OyXezY8zxk8+GffDLS7
qYK//CMOoF6niul04Y6rAE3Qso/LF4IAG40G6myqTVcsipyMVH7Z2kEdEPBdULm2
AItHjsLDouhEX0QFvarvXPRPt3G4jBJFfPIM3iSz4M8OXkfXEEMRz7eMYi2yBIwg
oqSio0OJNvWDYDExKBBCC9cyqn0huR02XlAIq8b/dPB1rr9U70vGZKJWDpZDzfs+
S0QV7DsLh6dmBBRXLKN80kFZ+UHJRrP8Z7jFOGF17tQuWsyCZO9VmHahU30PRUu9
9gD0RcjssoDWn0Bbg25B
=HTId
-----END PGP SIGNATURE-----

--kfjH4zxOES6UT95V--
