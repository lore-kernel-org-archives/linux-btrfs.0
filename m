From: =?ISO-8859-1?Q?Sw=E2mi?= Petaramesh <swami@petaramesh.org>
Subject: Re: BTRFS, encrypted LVM and disk write cache ?
Date: Thu, 12 May 2011 23:36:44 +0200
Message-ID: <1305236204.3277.1.camel@tethys>
References: <1305179125.3106.3.camel@tethys>
	 <20110512154224.GD19041@dhcp231-156.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Linux BTRFS <linux-btrfs@vger.kernel.org>
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110512154224.GD19041@dhcp231-156.rdu.redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Le jeudi 12 mai 2011 =C3=A0 11:42 -0400, Josef Bacik a =C3=A9crit :
> >=20
> > ...So I've turned my write cache off, but I notice this is stated f=
or
> > kernel 2.6.33, so wonder if this still is an issue with 2.6.38, or =
has
> > it been addressed since ?

> If you mount and start writing and don't see a message in dmesg about=
 disabling
> barriers then you should be good to go.  Thanks,

I've turned disk cache back on and don't see no such messages in my
logs... So I assume I should be safe ?

However shifting from ext3 to BTRFS has been enough to turn my perfectl=
y
stable system into a perfectly unstable and crash-prone system :-/

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
