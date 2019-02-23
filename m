Return-Path: <SRS0=jbNX=Q6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD42DC43381
	for <linux-btrfs@archiver.kernel.org>; Sat, 23 Feb 2019 18:14:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6B184206A3
	for <linux-btrfs@archiver.kernel.org>; Sat, 23 Feb 2019 18:14:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=seblu.net header.i=@seblu.net header.b="E3MkbAwU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726440AbfBWSOo (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 23 Feb 2019 13:14:44 -0500
Received: from mail.seblu.net ([212.129.28.29]:50578 "EHLO mail.seblu.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725886AbfBWSOo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 23 Feb 2019 13:14:44 -0500
Received: from localhost (localhost [IPv6:::1])
        by mail.seblu.net (Postfix) with ESMTP id 5B3BE52FBE13;
        Sat, 23 Feb 2019 19:14:41 +0100 (CET)
Received: from mail.seblu.net ([IPv6:::1])
        by localhost (mail.seblu.net [IPv6:::1]) (amavisd-new, port 10032)
        with ESMTP id 5R2nLIHPMEXp; Sat, 23 Feb 2019 19:14:40 +0100 (CET)
Received: from localhost (localhost [IPv6:::1])
        by mail.seblu.net (Postfix) with ESMTP id D72A952FBE2A;
        Sat, 23 Feb 2019 19:14:40 +0100 (CET)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.seblu.net D72A952FBE2A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seblu.net; s=pipa;
        t=1550945680; bh=TkXb9tvwLqSgvqFcbMDwCvfIQZlG0EHUswxzb5L5KAA=;
        h=Message-ID:From:To:Date:Mime-Version;
        b=E3MkbAwUZIBySHk+19wV9potTYxSyIydstgdiVJiL+OpCozwzYTUK6rC7byJfY1IX
         6wHgRowMp+WuWXeLvRO0im245Opk3FJaCH9VuHpK5JTRq4Kdyq3Ygy3anAluP5wGVc
         DhhrGgu3p/hA6EbztEWCBtq5EM6nVho8RgQIu3czGjB3uWNEg4+8CG2Ueomiy91uN/
         DQudGOyh/fJVFVGl42OG+VF7FmwpWpWtuhA/Hnt4AAq+uKP2EdXIA215IT7X/gG4S1
         jwhZVhcP0oKlu76LUGmONYaZqeOKLJ5yrrM7BcYMzwKMMov3btJNWMO6PVjiZ3G4Km
         7CaD5LdZLmh2A==
X-Virus-Scanned: amavisd-new at seblu.net
Received: from mail.seblu.net ([IPv6:::1])
        by localhost (mail.seblu.net [IPv6:::1]) (amavisd-new, port 10026)
        with ESMTP id 8sio-Ay0wT9j; Sat, 23 Feb 2019 19:14:40 +0100 (CET)
Received: from dolores (amontsouris-684-1-65-188.w90-87.abo.wanadoo.fr [90.87.48.188])
        by mail.seblu.net (Postfix) with ESMTPSA id A719552FBE13;
        Sat, 23 Feb 2019 19:14:40 +0100 (CET)
Message-ID: <4fd5e655c49278cf5967b2774ab34e4a0571f722.camel@seblu.net>
Subject: Re: Corrupted filesystem, looking for guidance
From:   =?ISO-8859-1?Q?S=E9bastien?= Luttringer <seblu@seblu.net>
To:     Chris Murphy <lists@colorremedies.com>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>
Date:   Sat, 23 Feb 2019 19:14:39 +0100
In-Reply-To: <CAJCQCtTq8YLmti_tf0oNaSGn94qvGxs-mQeDdvxddE61L0Rjdg@mail.gmail.com>
References: <7ef0e91501a04cd4c5e0d942db638a0b50ef3ec3.camel@seblu.net>
         <CAJCQCtQ+b9y7fBXPPhB-gQrHAH-pCzau6nP1OabsC1GNqNnE1w@mail.gmail.com>
         <91e2c9ef095eae21f9e88f7b5cf49102571dcba8.camel@seblu.net>
         <CAJCQCtTq8YLmti_tf0oNaSGn94qvGxs-mQeDdvxddE61L0Rjdg@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha384";
        protocol="application/pgp-signature"; boundary="=-7CZrHVBA6YEhrASSgTlP"
X-Mailer: Evolution 3.28.5 
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


--=-7CZrHVBA6YEhrASSgTlP
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2019-02-18 at 14:06 -0700, Chris Murphy wrote:
> No at worst what happens if SCSI command timer is reached before the
> drive's SCT ERC timeout, is the kernel assumes the device is not
> responding and does a link reset. That link reset obiterates the
> entire command queue on SATA drives. And that means it's no longer
> possible to determine what sector is having a problem; and therefore
> not possible to fix it by overwriting that sector with good data. This
> is a problem for Btrfs raid, as well as md and LVM.

According to the Timeout Mismatch[1] kernel raid wiki:

  Unfortunately, with desktop drives, they can take over two minutes to=20
  give up, while the linux kernel will give up after 30 seconds. At which=
=20
  point, the RAID code recomputes the block and tries to write it back to=
=20
  the disk. The disk is still trying to read the data and fails to=20
  respond, so the raid code assumes the drive is dead and kicks it from=20
  the array. This is how a single error with these drives can easily kill=
=20
  an array.

I get your point that at worst more than one drive can be kicked out, break=
ing
the whole raid.

What I don't get is how this could end up to silent sector corruption or le=
t
accumulate bad sectors. A read timeout, a link reset will end up with an er=
ror
kick at minimum one drive from the array, forcing a full rebuild. No?

I discovered that my SAS drives have no such timeout and they don't need an=
 ERC
value to be defined. So, I updated my timeout to 180 when my drives are SAT=
A
and doesn't support ERC. Thanks a lot for making me discovering this.

> *shrug* I'm not super familiar with all the mdadm features. It's
> vaguely possible your md array is using the bad block mapping feature,
> and perhaps that's related to this behavior. Something in my memory is
> telling me that this isn't really the best feature to have enabled in
> every use case; it's really strictly for continuing to use drives that
> have all reserve sectors used up, which means bad sectors result in
> write failures. The bad block mapping allows md to do its own
> remapping so there won't be write failures in such a case.
I didn't check if this log was empty. As this option is enabled by default,
there is one per disk in my array.

> You might check the archives about various memory testing strategies.
> A simple hour long test often won't find the most pernicious memory
> errors. At least do it over a weekend.
>=20
> Quick search austin hemmelgarn memory test compile and I found this threa=
d:
>=20
I found it. I ran for 72 hours a variant with an Arch live system running a
loop compiling a 4.20.10 kernel, and 4 memtest86+ running inside a qemu.
No error so looks memory is ok.

> If you do want to move to strictly Btrfs, I suggest raid5 for data but
> use raid1 for metadata instead of raid5. Metadata raid 5 writes can't
> really be assured to be atomic. Using raid1 metadata is less fragile.
Make sense. Is raid10 suitable (atomic) option for metadata? Looks like
performance are better than raid1?

> No matter what, keep backups up to date, always be prepared to have to
> use them. The main idea of any raid is to just give you some extra
> uptime in the face of a failure. And the uptime is for your
> applications.
This server is my backup server. I don't plan to backup the backup dataset =
on
it, so if I loose it, I loose my backup history.

> --repair should be safe but even in 4.20.1 tools you'll see the man
> page says it's dangerous and you should ask on list before using it.
Few month ago I was strongly advised to ask here before calling repair.
Are you saying that it's no more useful?

> Well at this point if you ran a those commands the file system is
> different so you should refresh the thread by posting current normal
> mount (no options) kernel messages; and also 'btrfs check' output
> without repair; and also output from btrfs-debug-tree. If the problem
> is simple enough and a dev has time it might be they get you a file
> system specific patch to apply and it can be fixed. But it's really
> important that you stop making changes to the file system in the
> meantime. Just gather information. Be deliberate.
It's a pity that there is yet no solution without involving a human. I'll n=
ot
request developer time which could be used to improve the filesystem. :)

I'm going to start over. Thanks!

Regards,

[1]https://raid.wiki.kernel.org/index.php/Timeout_Mismatch

--=20
S=C3=A9bastien "Seblu" Luttringer

--=-7CZrHVBA6YEhrASSgTlP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIrBAABCQAdFiEEVyJOyaX8pvvJK7iqShr8NF6+GPgFAlxxjZAACgkQShr8NF6+
GPhWvQ+8CdwbBC4H8bBhyX9ZreCHaWMuOEqJ46jNg7FLNYVaN5T89wmOS3qHtLR4
q0MhLLf1Q87IMZO0hujSUrckKXfrH34NcFHcV+cgUpkpz4oUfoybNGbNAH1DrP7G
Kbl3s72kcuBawJapOj3oVT2qSgp+SbqDNVPjK2XXA0CHqgXJxPmD2BaxFAQbUSo2
EWiJ01dYLTUHeH5y8rleMLCwL8KpD/2dSm5D/fuCQq0qmx1QvksFD+E7AneMa4T7
LSbZp2MqVZMyrbQ7/pTFS2MuEvEP9yoXqvqAtCRd1TsaUM3ZxxdgwSTj2HFgX9Cc
BFfB4ssYNxPgeDWSYfMJ77AVVwCkM7zDIG9uHDbVGW9gr3005NRaimReoiywRS4Y
ZARiQnuuOF549zo1xHwdSxh+2NDcms8eMuckCbHZFe2ArZ5Iou2Toaoo/CMBR0rp
xe/TVDZYORqHWHyXn0m0VaOkviW4PxTqjYYFGVBs27n8DMDRZw1/UCS5vIg+XDaX
v27tvCoIzXuJjomuTLAjYdzRsUuzrHQ4dMdpboPHzUjqk8JkoHNwy0DoMrwBDWVy
mGqxeewvEl6MNhPJyghe0VoniAguHc9GRzexX2kT2lKj3J1p+8eilzMRAOEEfsji
1Px8NXZB3YAJOmi0Dtrambp/ijPjX/WDVf2ocO+4
=NV18
-----END PGP SIGNATURE-----

--=-7CZrHVBA6YEhrASSgTlP--

