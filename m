From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: sign a bug in =?UTF-8?B?4oCcc2V0X2V4dGVudF9iaXTigJ0=?=
Date: Wed, 13 Jul 2011 09:30:57 +0800
Message-ID: <4E1CF551.3060405@cn.fujitsu.com>
References: <1310485239.13883.YahooMailNeo@web92401.mail.cnh.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Qiang Zhu <qiang.zhu@yahoo.cn>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1310485239.13883.YahooMailNeo@web92401.mail.cnh.yahoo.com>
List-ID: <linux-btrfs.vger.kernel.org>

Qiang Zhu wrote:
> hi=20
>=20
> In the end part of =E2=80=9Cset_extent_bit=E2=80=9D=EF=BC=8CI found w=
hen err occurs =EF=BC=8Cthere is no operate to free "prealloc" which ha=
ve been allocated in "alloc_extent_state_atomic"
> this may lead a menory leak when "set_state_bits" failed.

No, it won't. 'prealloc' has been inserted into rbtree before set_state=
_bits()
is called().

> err =3D set_state_bits(tree, prealloc, &bits);
>=20
> if (err) {
> prealloc =3D NULL;
> goto out; // this direct will do nothing because prealloc=3DNULL.
> }
> wish your reply.

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
