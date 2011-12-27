From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: FS won't mount, open_ctree failed, Assertion !(path->slots[0] == 0) failed
Date: Tue, 27 Dec 2011 12:18:43 +0100
Message-ID: <201112271218.43396.Martin@lichtvoll.de>
References: <CB041FF1.1FD66%dsmith@tgen.org> <20111223181542.GU19266@shiny> <4EF8C5C4.7090301@gmail.com> (sfid-20111227_102533_234959_359C4D67)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Cc: Evan LeCompte <evanlec@gmail.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4EF8C5C4.7090301@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Am Montag, 26. Dezember 2011 schrieb Evan LeCompte:
> On 12/23/2011 06:15 PM, Chris Mason wrote:
> > On Fri, Dec 23, 2011 at 09:37:28AM +0000, Evan LeCompte wrote:
> >> I'm having the very same issue as you. I've tried all the latest
> >> btrfs tools, btrfsck, btrfs-zero-log, restore, find-root etc etc.
> >>=20
> >> All to no avail. only err output is always
[=E2=80=A6]
> >> Is there ANY way to even recover ANY files at all from these btrfs
> >> filesystems that lose transid sync? mine occurred simply from a
> >> loose sata cable falling out of one of my drives while the system
> >> was running.
[=E2=80=A6]
> >> Please help us, anyone!
> >=20
> > Which kernel are you running?  If you're on a 3.2 kernel or you hav=
e
> > a recent pull of my git tree, you can try mount -o recovery.
[=E2=80=A6]
> Chris,
> Can you help me work through the copy out recovery tools that you
> mentioned?

If all else fails depending of the file formats of the files you want t=
o=20
recover you can also try some of the forensic tools like photorec from=20
testdisk or foremost. I believe there is a third one. This should get y=
ou=20
the files, although the filenames and directory structure will likely b=
e=20
lost. And it takes quite long on higher capacity or slow drives.

With photorec I managed to recover 100 images from a smartmedia card th=
at=20
appeared empty on Linux - while the digital camera still saw the images=
=2E

--=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
