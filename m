Return-Path: <SRS0=+tZ8=RW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19109C43381
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Mar 2019 12:08:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C9ABC2173C
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Mar 2019 12:08:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="HQiV7Nc1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727691AbfCSMIA (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 19 Mar 2019 08:08:00 -0400
Received: from mout.gmx.net ([212.227.15.15]:55143 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727371AbfCSMH7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Mar 2019 08:07:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1552997272;
        bh=HLM/Tk8vJOGytjMiaUw86yutuybX0dr5TFhmsQTTeFc=;
        h=X-UI-Sender-Class:Subject:To:References:From:Date:In-Reply-To;
        b=HQiV7Nc1imeZnRfKsAx+1ZwOjDYuGYetIcodyjvV/TumCk872FhKQD+e1qpEvVmHI
         MDYFSOlomo8O5J4cCWI0BD14kFiXX7A6Pvxu3xV8mHUlPE4ZbA+NlWL2xRgI34eZIK
         YagpF0grrOroWfkg7pSW3oWGfKZOc3j3s6NmbsmM=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([54.250.245.166]) by mail.gmx.com (mrgmx001
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0MPlY2-1h2Le11SRW-004xOc; Tue, 19
 Mar 2019 13:07:52 +0100
Subject: Re: [PATCH RFC] btrfs: fix read corrpution from disks of different
 generation
To:     Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
References: <1552995330-28927-1-git-send-email-anand.jain@oracle.com>
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
Openpgp: preference=signencrypt
Autocrypt: addr=quwenruo.btrfs@gmx.com; prefer-encrypt=mutual; keydata=
 mQENBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAG0IlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT6JAVQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWCnQUJCWYC
 bgAKCRDCPZHzoSX+qAR8B/94VAsSNygx1C6dhb1u1Wp1Jr/lfO7QIOK/nf1PF0VpYjTQ2au8
 ihf/RApTna31sVjBx3jzlmpy+lDoPdXwbI3Czx1PwDbdhAAjdRbvBmwM6cUWyqD+zjVm4RTG
 rFTPi3E7828YJ71Vpda2qghOYdnC45xCcjmHh8FwReLzsV2A6FtXsvd87bq6Iw2axOHVUax2
 FGSbardMsHrya1dC2jF2R6n0uxaIc1bWGweYsq0LXvLcvjWH+zDgzYCUB0cfb+6Ib/ipSCYp
 3i8BevMsTs62MOBmKz7til6Zdz0kkqDdSNOq8LgWGLOwUTqBh71+lqN2XBpTDu1eLZaNbxSI
 ilaVuQENBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
 CbPEwhLj1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj
 /IrRUUka68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fN
 GSsRb+pKEKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0
 q1eW4Jrv0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEv
 ABEBAAGJATwEGAEIACYWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWBrwIbDAUJA8JnAAAK
 CRDCPZHzoSX+qA3xB/4zS8zYh3Cbm3FllKz7+RKBw/ETBibFSKedQkbJzRlZhBc+XRwF61mi
 f0SXSdqKMbM1a98fEg8H5kV6GTo62BzvynVrf/FyT+zWbIVEuuZttMk2gWLIvbmWNyrQnzPl
 mnjK4AEvZGIt1pk+3+N/CMEfAZH5Aqnp0PaoytRZ/1vtMXNgMxlfNnb96giC3KMR6U0E+siA
 4V7biIoyNoaN33t8m5FwEwd2FQDG9dAXWhG13zcm9gnk63BN3wyCQR+X5+jsfBaS4dvNzvQv
 h8Uq/YGjCoV1ofKYh3WKMY8avjq25nlrhzD/Nto9jHp8niwr21K//pXVA81R2qaXqGbql+zo
Message-ID: <b458f22f-9833-27bd-dd06-ba2862aa59c4@gmx.com>
Date:   Tue, 19 Mar 2019 20:07:47 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <1552995330-28927-1-git-send-email-anand.jain@oracle.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="rww2106L56GarJJ8QvqHwzVJSJ8WOI0V9"
X-Provags-ID: V03:K1:vlDxtlpHlrLvx9EHhRcogg8en3bz4AmJCt9NKg5JF2enRURsqGN
 ad2X4BCA5WJSqihdyjh3H5l0Uu6R58l8++RlQp4wmqCq1PVfIG8SUxTBh0heES19B5iKHDq
 GO1EYz2fxFxigLADnbnSQNdaqGqCnP5n0kfvCYrJQqeSD2/qGbcEjFFO6orNBCaDer8uNTp
 AF5HkEmQV+eBx+9BDoOtQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:wVpYBh6Qzi4=:Y6AJGvGe2w/d9qwQC+oCKX
 w21EG0IedZBJ91qaaTM0POcOwqT5HzW9y1cQECE3QTenYV9T8ffU30zDOB9ZRaHLVLRBo1DO6
 0An1ifF7qy0HFUvAiIjqePqsr0oJbp4V8E9CevfnyYSnh1M+kB9VWwLuXSRNPrtdx2Ta+sZVd
 7/rTQuORIs4FAE9NTey+JNCweaCqfuuwXF1oBCuJtTF7QrZtocuc2BBOz0JkgHNof45V1REjl
 9nFiVbN5yMTF0OA1YF+6qOg/xT1Plsx3SkrhmvLi6zmfHXJ15O6WSJA5wMUhSFhs6Cf0S1Tgq
 Q/jMf/GAXOq1jnqm/eOK4yvB1fU/QnBo3tr00Zqyd6aFmlD6+xHh/Z4LoW30uj9GqYfy9ggvj
 er7o4Nzfy0MlFosZuPPk+cwgWEsURG6jLgUvCAFyvLjo+JQBQwuvVWedemJDJvLq1iwWZGJkJ
 Y2wzSvmrJcNUnoCnvtuCDSXlLHwGB7R83QODn4yB7LkOOYRoABeqT0btPuebll+ckVBeKHTab
 tjkd96Ga3l+d81FyC0JSAL/eQNuw350TyieCVnN0dxeftJjukDcb+BxIOlcp09UPcQ2gal7xK
 zSEFPxPAAGVQJjG+hJuHGyU2PuEa6GQzul+5+3WVZRBzo2UCQouIy43fIbvxnSCEGgIbhMlIc
 V+WkCgMOoVOvpCzp5IDPul8/0CHNX9Pi7aKQprMLn9/ubqqM/eM9Nk3Yp3EOJCqBJfk8aHs6P
 M2h+eJNwAVD4RZqzXsWYcKVWJ+1PLpuLxBH8hEJ43GuHxywLKApIpI3v8lHLQTDH/6wOxD+A5
 ftANu8ml9j8lue84XTT+qJyBf+/g81zmDoCfBKiQ2ihh1xaU3IYNoIjFvHxPKeWpw3tbvgag4
 oTdt++0oVcOAOQ7kETujlYAPWFgplY16YeAgu9lPBksIbcyVH6oUyeDYQvDF5T
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--rww2106L56GarJJ8QvqHwzVJSJ8WOI0V9
Content-Type: multipart/mixed; boundary="6TebV0czssEVFnvk2WZCkrMPhyV5p1w5c";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
Message-ID: <b458f22f-9833-27bd-dd06-ba2862aa59c4@gmx.com>
Subject: Re: [PATCH RFC] btrfs: fix read corrpution from disks of different
 generation
References: <1552995330-28927-1-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1552995330-28927-1-git-send-email-anand.jain@oracle.com>

--6TebV0czssEVFnvk2WZCkrMPhyV5p1w5c
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/3/19 =E4=B8=8B=E5=8D=887:35, Anand Jain wrote:
>    In case of file regular extent (non inline), the metadata and data a=
re=20
>  read from two different IO operations. When we read the metadata using=
=20
>  the btree each extent block gets verified with the expected  transid a=
s=20
>  per its parent. So suppose if any of the block is stale it gets report=
ed=20
>  and corrected by reading from the mirror (consider raid1).
> =20
>    This also means the data extent is not yet read or verified and this=
=20
>  happens when application tries to read the file.
>  When application tries to read the file btrfs_readpage(), it shall fir=
st=20
>  read file extent map as provided by the metadata in the above operatio=
n=20
>  (which is assured to be consistent).
>  And when file data has to be read using the above filemap as it again =

>  has the choice of using either of the mirrors, suppose if the IO is=20
>  routed to the disk on which we haven't verified the metadata on it and=
=20
>  if there is write hole on that disk, then we shall be reading the junk=
=20
>  data without being reported anywhere.
>=20
>    This is reproducible with the test case [1] in this email thread.
>      [1]
>      fstests: btrfs test read from disks of different generation
>=20
>    As we have data csum most of these get caught and reported as csum=20
>  error.

So far so good.

>  But csum verification is a point in verification and its not a=20
>  tree based transid verification. Which means if there is a stale data =

>  with matching csum we may return a junk data silently.

Then the normal idea is to use stronger but slower csum in the first
place, to avoid the csum match case.

>  This problem is=20
>  easily reproducible when csum is disabled but not impossible to achiev=
e=20
>  when csum is not disabled as well.

Under this case, it's the user to be blamed for the decision to disable
the csum in the first place.

> A tree based integrity verification=20
>  is important for all data, which is missing.
> =20
>  Fix:
>    In this RFC patch it proposes to use same disk from with the metadat=
a=20
>  is read to read the data.

The obvious problem I found is, the idea only works for RAID1/10.

For striped profile it makes no sense, or even have a worse chance to
get stale data.


To me, the idea of using possible better mirror makes some sense, but
very profile limited.


Another idea I get inspired from the idea is, make it more generic so
that bad/stale device get a lower priority.
Although it suffers the same problem as I described.

To make the point short, the use case looks very limited.

Thanks,
Qu

> Which means the feature such as readmirror is=20
>  less effective (which is fine). But if the good data fails (media erro=
r)=20
>  as usual we shall read the mirrored data without being aware that this=
=20
>  data may be stale. To fix that, we have to invalidate the correspondin=
g=20
>  metadata and re-read the metadata from other disk (this part is not=20
>  implemented in this patch).
> =20
>     The other better solution is - a tree based verification, which mea=
ns=20
>  we have to verify the data-extent's metadata in the extent tree when i=
ts=20
>  read - but there is a problem we don't update the generation number in=
=20
>  the extent tree for all types of write, for example consider overwrite=
=20
>  with notrunc option on a filesystem mounted with nodatacow option [1],=
=20
>  which I wonder if its a bug or if its like that for a reason? as becau=
se=20
>  there is no cow?
> =20
>  [1] The EXTENT_DATA generation is same before and after dd with notrun=
c
> =20
>    mkfs.btrfs -fq /dev/sdb && mount -o notreelog,nodatacow /dev/sdb /bt=
rfs
>    dd if=3D/dev/urandom of=3D/btrfs/tf1 bs=3D4096 count=3D1 conv=3Dfsyn=
c,notrunc &&=20
>  sync
>    btrfs in dump-tree /dev/sdb | grep -A4 "257 EXTENT_DATA 0"
>    btrfs in dump-tree /dev/sdb | egrep -A7 "257 INODE_ITEM 0\) itemoff"=

>    dd if=3D/dev/urandom of=3D/btrfs/tf1 bs=3D4096 count=3D1 conv=3Dfsyn=
c,notrunc &&=20
>  sync
>    btrfs in dump-tree /dev/sdb | grep -A4 "257 EXTENT_DATA 0"
>    btrfs in dump-tree /dev/sdb | egrep -A7 "257 INODE_ITEM 0\) itemoff"=

> =20
>  ---------
>       item 6 key (257 EXTENT_DATA 0) itemoff 15819 itemsize 53
>           generation 6 type 1 (regular)
>           extent data disk byte 13631488 nr 4096
>           extent data offset 0 nr 4096 ram 4096
>           extent compression 0 (none)
>       item 4 key (257 INODE_ITEM 0) itemoff 15885 itemsize 160
>           generation 6 transid 6 size 4096 nbytes 4096
>           block group 0 mode 100644 links 1 uid 0 gid 0 rdev 0
>           sequence 66785 flags 0x3(NODATASUM|NODATACOW)
>           atime 1552993569.276079763 (2019-03-19 19:06:09)
>           ctime 1552993569.276079763 (2019-03-19 19:06:09)
>           mtime 1552993569.276079763 (2019-03-19 19:06:09)
>           otime 1552993569.276079763 (2019-03-19 19:06:09)
>  1+0 records in
>  1+0 records out
>  4096 bytes (4.1 kB) copied, 0.00302717 s, 1.4 MB/s
>       item 6 key (257 EXTENT_DATA 0) itemoff 15819 itemsize 53
>           generation 6 type 1 (regular)
>           extent data disk byte 13631488 nr 4096
>           extent data offset 0 nr 4096 ram 4096
>           extent compression 0 (none)
>       item 4 key (257 INODE_ITEM 0) itemoff 15885 itemsize 160
>           generation 6 transid 7 size 4096 nbytes 4096
>           block group 0 mode 100644 links 1 uid 0 gid 0 rdev 0
>           sequence 66786 flags 0x3(NODATASUM|NODATACOW)
>           atime 1552993569.276079763 (2019-03-19 19:06:09)
>           ctime 1552993569.302079763 (2019-03-19 19:06:09)
>           mtime 1552993569.302079763 (2019-03-19 19:06:09)
>           otime 1552993569.276079763 (2019-03-19 19:06:09)
>  -------
> =20
>    Comments appreciated.
>=20
>=20
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>  fs/btrfs/extent_io.c | 41 ++++++++++++++++++++++++++++++++++-------
>  1 file changed, 34 insertions(+), 7 deletions(-)
>=20
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index 31892052a24f..f1cc21e8dff7 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -3079,7 +3079,7 @@ static inline void __do_contiguous_readpages(stru=
ct extent_io_tree *tree,
>  					     struct extent_map **em_cached,
>  					     struct bio **bio,
>  					     unsigned long *bio_flags,
> -					     u64 *prev_em_start)
> +					     u64 *prev_em_start, int mirror)
>  {
>  	struct inode *inode;
>  	struct btrfs_ordered_extent *ordered;
> @@ -3099,7 +3099,7 @@ static inline void __do_contiguous_readpages(stru=
ct extent_io_tree *tree,
> =20
>  	for (index =3D 0; index < nr_pages; index++) {
>  		__do_readpage(tree, pages[index], btrfs_get_extent, em_cached,
> -				bio, 0, bio_flags, REQ_RAHEAD, prev_em_start);
> +				bio, mirror, bio_flags, REQ_RAHEAD, prev_em_start);
>  		put_page(pages[index]);
>  	}
>  }
> @@ -3109,7 +3109,7 @@ static void __extent_readpages(struct extent_io_t=
ree *tree,
>  			       int nr_pages,
>  			       struct extent_map **em_cached,
>  			       struct bio **bio, unsigned long *bio_flags,
> -			       u64 *prev_em_start)
> +			       u64 *prev_em_start, int mirror)
>  {
>  	u64 start =3D 0;
>  	u64 end =3D 0;
> @@ -3130,7 +3130,7 @@ static void __extent_readpages(struct extent_io_t=
ree *tree,
>  						  index - first_index, start,
>  						  end, em_cached,
>  						  bio, bio_flags,
> -						  prev_em_start);
> +						  prev_em_start, mirror);
>  			start =3D page_start;
>  			end =3D start + PAGE_SIZE - 1;
>  			first_index =3D index;
> @@ -3141,7 +3141,7 @@ static void __extent_readpages(struct extent_io_t=
ree *tree,
>  		__do_contiguous_readpages(tree, &pages[first_index],
>  					  index - first_index, start,
>  					  end, em_cached, bio,
> -					  bio_flags, prev_em_start);
> +					  bio_flags, prev_em_start, mirror);
>  }
> =20
>  static int __extent_read_full_page(struct extent_io_tree *tree,
> @@ -4093,6 +4093,27 @@ int extent_writepages(struct address_space *mapp=
ing,
>  	return ret;
>  }
> =20
> +static int btrfs_get_read_mirror(struct inode *inode)
> +{
> +	int ret;
> +	struct btrfs_path *path;
> +
> +	path =3D btrfs_alloc_path();
> +	if (!path)
> +		return -ENOMEM;
> +
> +	ret =3D btrfs_lookup_file_extent(NULL, BTRFS_I(inode)->root, path,
> +				       btrfs_ino(BTRFS_I(inode)), 0, 0);
> +	if (!ret) {
> +		struct extent_buffer *eb =3D path->nodes[0];
> +
> +		ret =3D eb->read_mirror;
> +	}
> +
> +	btrfs_free_path(path);
> +	return ret;
> +}
> +
>  int extent_readpages(struct address_space *mapping, struct list_head *=
pages,
>  		     unsigned nr_pages)
>  {
> @@ -4103,6 +4124,11 @@ int extent_readpages(struct address_space *mappi=
ng, struct list_head *pages,
>  	struct extent_io_tree *tree =3D &BTRFS_I(mapping->host)->io_tree;
>  	int nr =3D 0;
>  	u64 prev_em_start =3D (u64)-1;
> +	int mirror;
> +
> +	mirror =3D btrfs_get_read_mirror(mapping->host);
> +	if (mirror < 0)
> +		return mirror;
> =20
>  	while (!list_empty(pages)) {
>  		for (nr =3D 0; nr < ARRAY_SIZE(pagepool) && !list_empty(pages);) {
> @@ -4120,14 +4146,15 @@ int extent_readpages(struct address_space *mapp=
ing, struct list_head *pages,
>  		}
> =20
>  		__extent_readpages(tree, pagepool, nr, &em_cached, &bio,
> -				   &bio_flags, &prev_em_start);
> +				   &bio_flags, &prev_em_start, mirror);
> +
>  	}
> =20
>  	if (em_cached)
>  		free_extent_map(em_cached);
> =20
>  	if (bio)
> -		return submit_one_bio(bio, 0, bio_flags);
> +		return submit_one_bio(bio, mirror, bio_flags);
>  	return 0;
>  }
> =20
>=20


--6TebV0czssEVFnvk2WZCkrMPhyV5p1w5c--

--rww2106L56GarJJ8QvqHwzVJSJ8WOI0V9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlyQ25MACgkQwj2R86El
/qjv0gf8DGd2iC9BIZkmr9MlZXHM6X1TEfKkCS9E+Zp86U0ZeQRPdJB9K8DE9n//
OvMCplvDbI5wlq9lG06Cc1eU3wkTrrtkHiBfql7Iv6CsdaZXJRu2KQcEMmoj3L1j
I7sb9/W1Y6KDI3kt1twP1kCNouWtib52/nUShkrSGRBnTktw5Hv+S7BVkvwq40Z1
4O9IEmsDqnkGm6gIiTGBwMiQt+qCPuJZyXhf2nULKhqwPuoJQ1lAVIHnez43hX3w
PoepFOqo7wrHEPNj02c50FfKOYjlCSetQH0Fq2jaTXer6u39ihvodAo6Ib7QwHNA
IxJSKnt0vK0ecOmxeNfNjHkhAyxHrA==
=MrBj
-----END PGP SIGNATURE-----

--rww2106L56GarJJ8QvqHwzVJSJ8WOI0V9--
