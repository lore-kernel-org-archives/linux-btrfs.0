From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: 3.2-rc4: scrubbing locks up the kernel, then hung tasks on boot
Date: Sat, 17 Dec 2011 19:11:50 +0100
Message-ID: <201112171911.50826.Martin@lichtvoll.de>
References: <201112171833.34720.Martin@lichtvoll.de> (sfid-20111217_183419_764882_9192E97F)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201112171833.34720.Martin@lichtvoll.de>
List-ID: <linux-btrfs.vger.kernel.org>

Am Samstag, 17. Dezember 2011 schrieb Martin Steigerwald:
> Hi!
>=20
> Finally I tried scrubbing the / BTRFS filesystem mentioned in the
> thread "speeding up slow btrfs filesystem". However the machine looks
> up hard then. It repeats the last few seconds of audio all over again=
,
> no mouse and no ssh connection anymore:
>=20
> deepdance:~> btrfs scrub start /
> scrub started on /, fsid [=E2=80=A6] (pid=3D5737)
> deepdance:~> Write failed: Broken pipe

=46WIW the T520 can scrub its / BTRFS successfully.

merkaba:~> btrfs scrub status /
scrub status for [=E2=80=A6]
        scrub started at Sat Dec 17 18:34:49 2011 and finished after 82=
=20
seconds
        total bytes scrubbed: 13.62GB with 0 errors

--=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
