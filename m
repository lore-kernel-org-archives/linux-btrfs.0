From: =?ISO-8859-1?Q?Sw=E2mi?= Petaramesh <swami@petaramesh.org>
Subject: BTRFS, encrypted LVM and disk write cache ?
Date: Thu, 12 May 2011 07:45:25 +0200
Message-ID: <1305179125.3106.3.camel@tethys>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Linux BTRFS <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi list,

I'm a new BTRFS user and will try not to ask FAQs ;-)

I'm currently using Btrfs v0.19 on stock Ubuntu Natty (kernel 2.6.38)
and use a BTRFS inside an encrypted LVM.

The wiki "gotchas" page https://btrfs.wiki.kernel.org/index.php/Gotchas
states :
=C2=AB btrfs volumes on top of dm-crypt block devices (and possibly LVM=
)
require write-caching to be turned off on the underlying HDD. Failing t=
o
do so, in the event of a power failure, may result in corruption not ye=
t
handled by btrfs code. (2.6.33) =C2=BB

=2E..So I've turned my write cache off, but I notice this is stated for
kernel 2.6.33, so wonder if this still is an issue with 2.6.38, or has
it been addressed since ?

Thanks in advance for your help.

Kind regards.

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
