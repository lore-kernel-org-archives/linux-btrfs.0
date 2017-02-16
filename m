Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56352 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932694AbdBPTHQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 16 Feb 2017 14:07:16 -0500
Subject: Re: Device ID issue on btrfs
To: kreijack@inwind.it, Ilan Schwarts <ilan84@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <CAJUuSvG-7jY7vW6KFx5s10vRH2WvB_uDhOhTrP15T4UJFkiPDA@mail.gmail.com>
 <CAJUuSvFkLEsSONM9EwCMS0qJ9eGvtFYXUayFjRcKPE7qRLrVPg@mail.gmail.com>
 <CAJUuSvE=iHHYqjo+QbR3eP92mYdT6NQ8T7Kf--jgC3xniPYj5A@mail.gmail.com>
 <103e47d2-97fc-009a-8e94-a047f2d8b9bd@libero.it>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <08fa1099-5762-dcae-ae9f-6bf2a31293e6@suse.com>
Date: Thu, 16 Feb 2017 14:07:11 -0500
MIME-Version: 1.0
In-Reply-To: <103e47d2-97fc-009a-8e94-a047f2d8b9bd@libero.it>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="lI0nqQUiUp5lAcfXP3N8dMOgTHKCtixOS"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--lI0nqQUiUp5lAcfXP3N8dMOgTHKCtixOS
Content-Type: multipart/mixed; boundary="WfootlQSRfuXO5LD3TTnlLG2CV999CM60";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: kreijack@inwind.it, Ilan Schwarts <ilan84@gmail.com>,
 linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <08fa1099-5762-dcae-ae9f-6bf2a31293e6@suse.com>
Subject: Re: Device ID issue on btrfs
References: <CAJUuSvG-7jY7vW6KFx5s10vRH2WvB_uDhOhTrP15T4UJFkiPDA@mail.gmail.com>
 <CAJUuSvFkLEsSONM9EwCMS0qJ9eGvtFYXUayFjRcKPE7qRLrVPg@mail.gmail.com>
 <CAJUuSvE=iHHYqjo+QbR3eP92mYdT6NQ8T7Kf--jgC3xniPYj5A@mail.gmail.com>
 <103e47d2-97fc-009a-8e94-a047f2d8b9bd@libero.it>
In-Reply-To: <103e47d2-97fc-009a-8e94-a047f2d8b9bd@libero.it>

--WfootlQSRfuXO5LD3TTnlLG2CV999CM60
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 2/16/17 1:23 PM, Goffredo Baroncelli wrote:
> On 2017-02-16 14:00, Ilan Schwarts wrote:
>> Hi,
>> Found the solution at: https://patchwork.kernel.org/patch/2825842/
>=20
> The patches below provided by suse seem more general
>=20
> 	http://kernel.opensuse.org/cgit/kernel-source/tree/patches.suse/vfs-ad=
d-super_operations-get_inode_dev
> 	http://kernel.opensuse.org/cgit/kernel-source/tree/patches.suse/btrfs-=
provide-super_operations-get_inode_dev
>=20
> Unfortunately is quite invasive

They're also incomplete.  The openSUSE kernel also needs:
http://kernel.suse.com/cgit/kernel-source/tree/patches.suse/btrfs-fs-supe=
r.c-add-new-super-block-devices-super_block_d.patch?h=3DSLE12-SP2
http://kernel.suse.com/cgit/kernel-source/tree/patches.suse/btrfs-btrfs-u=
se-the-new-VFS-super_block_dev.patch?h=3DSLE12-SP2

=2E.. for ustat() to work properly.  I've just forward ported those to th=
e
master kernel and am testing now.

The /proc/mountinfo thing isn't fixed with these patches either since
subvolumes report different device numbers and we don't represent
subvolumes as mounts.  That's what the patches that I had started
writing up a while ago do, but it's still very early for those.

-Jeff

>>
>> On Thu, Feb 16, 2017 at 12:05 PM, Ilan Schwarts <ilan84@gmail.com <mai=
lto:ilan84@gmail.com>> wrote:
>>
>>     Hi,
>>
>>     I hope its ok im reaching to you via mail..
>>     I read your message at: _https://marc.info/?l=3Dlinux-btrfs&m=3D14=
8701370108477&w=3D2 <https://marc.info/?l=3Dlinux-btrfs&m=3D1487013701084=
77&w=3D2>_
>>
>>     I have the same issue in my kernel driver, Did you find an answer =
?
>>
>>     Thanks
>>     -
>>     Ilan Schwarts
>>
>>
>>
>>
>> --=20
>>
>>
>> -
>> Ilan Schwarts
>=20
>=20


--=20
Jeff Mahoney
SUSE Labs


--WfootlQSRfuXO5LD3TTnlLG2CV999CM60--

--lI0nqQUiUp5lAcfXP3N8dMOgTHKCtixOS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2

iQIVAwUBWKX4Xx57S2MheeWyAQjsxg//c+S5b7vQbm9awq+IOFjrFE9ek9syhHVq
rd8mygvRY5Q/zEIiBUbJSQVSZs67Yui8Rv+z15SQs09L4BDs+fN0P9VeRr8B1jHx
QVKEWu1QAhWkaVrY9OkdyO8Mr8p0nRlNzAsIlUvIv9xhC6yBorV6226e6/cxIbb5
oHofBZGTICCQk0Nu0/IiqmFiC5m3aWVCvqbd2HCM7QkKbntf/X8FdggYZIeyYHzo
ok6GKy4FjMsz4b8kuFruGPR5QKT5ELZIy8bFJ1DL4QXGg81MgaGho4deoIQ3HJy1
A/SL9d9wMUrYK2GfNDdhRt8l7gC04OUvSxn+FPl4Kch2Su81eLoSj26EiuXng/Sz
dqOklFDQ4BJHmpvnGNbnLMmolSFzkiURkeWuzbMAjSlCyrC/lqQ4CeFWFvEhI50t
eSbUziKWrDK2nSKMFWPaDJs6pDmN/tYZ6atPcLJCvfgulrnUUpvMiETv2RZ1kPny
TZ/qR/8qOPaGwXGXnbQA2l5vvTHClUklhkz5wH4NFgAbVHhf2FV6cgVXo7zBbSwr
iMCHGVChSBvFm5I/7VeYJtWKeJDiWPnk3tVD1XCwBdULxhEXxay8HtaPTXQX5YW4
zeMFYOXZdJc5c03ZS6jlPe7Z8qCyQiq1g7nIgAtQ+mRuRvRWzbRz14874oc3BVlQ
p8NlCoomFno=
=n7pp
-----END PGP SIGNATURE-----

--lI0nqQUiUp5lAcfXP3N8dMOgTHKCtixOS--
