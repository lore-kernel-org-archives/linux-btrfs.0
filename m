From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH] Btrfs: setup blank root and fs_info for mount time
Date: Mon, 22 Nov 2010 10:01:09 +0800
Message-ID: <4CE9CEE5.5030606@cn.fujitsu.com>
References: <1290196755-19607-1-git-send-email-josef@redhat.com>	 <4CE9C677.9050007@cn.fujitsu.com> <1290390573.2602.5.camel@perseus.themaw.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org
To: Ian Kent <raven@themaw.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1290390573.2602.5.camel@perseus.themaw.net>
List-ID: <linux-btrfs.vger.kernel.org>

=E4=BA=8E 2010=E5=B9=B411=E6=9C=8822=E6=97=A5 09:49, Ian Kent =E5=86=99=
=E9=81=93:
> On Mon, 2010-11-22 at 09:25 +0800, Li Zefan wrote:
>>> +	/*
>>> +	 * Setup a dummy root and fs_info for test/set super.  This is be=
cause
>>> +	 * we don't actually fill this stuff out until open_ctree, but we=
 need
>>> +	 * it for searching for existing supers, so this lets us do that =
and
>>> +	 * then open_ctree will properly initialize everything later.
>>> +	 */
>>> +	fs_info =3D kzalloc(sizeof(struct btrfs_fs_info), GFP_NOFS);
>>> +	tree_root =3D kzalloc(sizeof(struct btrfs_root), GFP_NOFS);
>>> +	if (!fs_info || !tree_root) {
>>> +		kfree(fs_info);
>>> +		kfree(tree_root);
>> The above 2 kfree() calls are redundant.
>=20
> That's what I thought when I first looked at it but what happens when
> fs_info !=3D NULL and tree_root =3D=3D NULL.
>=20

Nothing bad happens in that case. ;)

We'll do the cleanup after "goto error_close_devices", and kfree(NULL)
is Ok. Did I miss something?

> Although I do wonder if doing two successive allocation requests and
> then checking both is a good idea. If memory is low there may be a bu=
nch
> of page scanning to try and free memory and if it eventually fails th=
at
> same process probably would happen all over again on the second call.
> I'm not sure though.
>=20
>> And error should be set to -ENOMEM.
>=20
> Ah, yes .. I missed that.
>=20
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
