From: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Subject: Re: Question of stability
Date: Sun, 19 Sep 2010 04:00:37 +0200 (CEST)
Message-ID: <19323412.131.1284861637528.JavaMail.root@zimbra>
References: <-2391411343414296963@unknownmsgid>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: Hendrik Fabelje <hendrik@fabelje.de>, linux-btrfs@vger.kernel.org
To: C Anthony Risinger <anthony@extof.me>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <-2391411343414296963@unknownmsgid>
List-ID: <linux-btrfs.vger.kernel.org>

> Stable is a pretty subjective term; many don't even think ext4 is
> stable. I've used it on my personal machine since .30-31-ish without
> problems, and on a server w/raid 1 for about a year (btrfs + lxc is
> niiice, for VMs) also free of problems.
>=20
> However, if you've been on the list you know that some do encounter
> seemingly catastrophic problems, though the list is helpful in
> recovering data. So, it's really going to depends on your workload
> and integrity needs. I remeber someone recently using it for
> continuous build servers successfully

The term stable may be subjective at times, but for btrfs to be stable,=
 it needs a working filesystem, with offline or online fsck abilities, =
and allowing for what's in the idea of btrfs, that is, checksumming eve=
rything, allowing snapshots and rollbacks et cetera. If btrfs is only s=
table as in ext4, well, why not just use ext4? The whole reason for btr=
fs to exist is to bring something new into the Linux world, and if thos=
e features aren't stable, then btrfs isn't. It's as simple as that. Wou=
ld you buy a Subaru (or something) 4wd with a 2wd working?

Vennlige hilsener / Best regards

roy
--
Roy Sigurd Karlsbakk
(+47) 97542685
roy@karlsbakk.net
http://blogg.karlsbakk.net/
--
I all pedagogikk er det essensielt at pensum presenteres intelligibelt.=
 Det er et element=C3=A6rt imperativ for alle pedagoger =C3=A5 unng=C3=A5=
 eksessiv anvendelse av idiomer med fremmed opprinnelse. I de fleste ti=
lfeller eksisterer adekvate og relevante synonymer p=C3=A5 norsk.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
