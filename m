From: Qiang Zhu <qiang.zhu@yahoo.cn>
Subject: =?utf-8?B?c2lnbiBhIGJ1ZyBpbiDigJxzZXRfZXh0ZW50X2JpdOKAnQ==?=
Date: Tue, 12 Jul 2011 23:40:39 +0800 (CST)
Message-ID: <1310485239.13883.YahooMailNeo@web92401.mail.cnh.yahoo.com>
Reply-To: Qiang Zhu <qiang.zhu@yahoo.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

hi=C2=A0

In the end part of =E2=80=9Cset_extent_bit=E2=80=9D=EF=BC=8CI found whe=
n err occurs =EF=BC=8Cthere is no operate to free "prealloc" which have=
 been allocated in "alloc_extent_state_atomic"
this may lead a menory leak when "set_state_bits" failed.
err =3D set_state_bits(tree, prealloc, &bits);

if (err) {
prealloc =3D NULL;
goto out; // this direct will do nothing because prealloc=3DNULL.
}
wish your reply.
thanks
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
