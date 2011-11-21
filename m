From: Arne Jansen <sensille@gmx.net>
Subject: Re: BTRFS subvolume quota limits
Date: Mon, 21 Nov 2011 06:18:53 +0100
Message-ID: <4EC9DF3D.1070603@gmx.net>
References: <CA+pWcCZ9qtMNDpzEhmTjvJFJ9WnjbxZcvYxnJUJjdratQYNCow@mail.gmail.com> <CA+pWcCZoHcq4Ansh1MRQuuUfun_85vGj04G_KWLm61kk_hmtGQ@mail.gmail.com> <4EC9D061.5050903@parallels.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: dima <dolenin@parallels.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4EC9D061.5050903@parallels.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 11/21/2011 05:15 AM, dima wrote:
> On 11/21/2011 06:50 AM, Karol =C5=A0ebesta wrote:
>> Hello,
>>
>> Is there any possibility to set quota limit for subvolume created in
>> BTRFS pool as in Solaris ZFS?
>=20
> Hi
> Quotas are not implemented yet in btrfs as far as I know.

This type of quota is implemented, but not merged yet. Please see
my qgroup patchset "Subvolume Quota Groups". Testers welcome :)

-Arne

> ~dima
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
