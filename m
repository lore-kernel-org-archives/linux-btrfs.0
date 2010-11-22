From: Ian Kent <raven@themaw.net>
Subject: Re: [PATCH] Btrfs: setup blank root and fs_info for mount time
Date: Mon, 22 Nov 2010 10:22:53 +0800
Message-ID: <1290392573.2602.22.camel@perseus.themaw.net>
References: <1290196755-19607-1-git-send-email-josef@redhat.com>
	 <4CE9C677.9050007@cn.fujitsu.com>
	 <1290390573.2602.5.camel@perseus.themaw.net>
	 <4CE9CEE5.5030606@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org
To: Li Zefan <lizf@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4CE9CEE5.5030606@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 2010-11-22 at 10:01 +0800, Li Zefan wrote:
> =E4=BA=8E 2010=E5=B9=B411=E6=9C=8822=E6=97=A5 09:49, Ian Kent =E5=86=99=
=E9=81=93:
> > On Mon, 2010-11-22 at 09:25 +0800, Li Zefan wrote:
> >>> +	/*
> >>> +	 * Setup a dummy root and fs_info for test/set super.  This is =
because
> >>> +	 * we don't actually fill this stuff out until open_ctree, but =
we need
> >>> +	 * it for searching for existing supers, so this lets us do tha=
t and
> >>> +	 * then open_ctree will properly initialize everything later.
> >>> +	 */
> >>> +	fs_info =3D kzalloc(sizeof(struct btrfs_fs_info), GFP_NOFS);
> >>> +	tree_root =3D kzalloc(sizeof(struct btrfs_root), GFP_NOFS);
> >>> +	if (!fs_info || !tree_root) {
> >>> +		kfree(fs_info);
> >>> +		kfree(tree_root);
> >> The above 2 kfree() calls are redundant.
> >=20
> > That's what I thought when I first looked at it but what happens wh=
en
> > fs_info !=3D NULL and tree_root =3D=3D NULL.
> >=20
>=20
> Nothing bad happens in that case. ;)
>=20
> We'll do the cleanup after "goto error_close_devices", and kfree(NULL=
)
> is Ok. Did I miss something?

No, you were correct, Josef also pointed that out, oops!

>=20
> > Although I do wonder if doing two successive allocation requests an=
d
> > then checking both is a good idea. If memory is low there may be a =
bunch
> > of page scanning to try and free memory and if it eventually fails =
that
> > same process probably would happen all over again on the second cal=
l.
> > I'm not sure though.
> >=20
> >> And error should be set to -ENOMEM.
> >=20
> > Ah, yes .. I missed that.
> >=20


--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
