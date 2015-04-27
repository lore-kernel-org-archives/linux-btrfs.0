Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.automatix.de ([213.131.255.221]:58832 "EHLO
	mail.automatix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932396AbbD0Kpy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Apr 2015 06:45:54 -0400
Message-ID: <553E1198.9000705@automatix.de>
Date: Mon, 27 Apr 2015 12:38:16 +0200
From: Juergen Sauer <juergen.sauer@automatix.de>
Reply-To: service@automatix.de
MIME-Version: 1.0
To: "Lentes, Bernd" <bernd.lentes@helmholtz-muenchen.de>,
        "'linux-btrfs@vger.kernel.org'" <linux-btrfs@vger.kernel.org>
Subject: Re: rollback of a snapshot is just read-only
References: <15785B7E063D464C86DD482FCAE4EBA501CAC3EF69DA@XCH11.scidom.de>
In-Reply-To: <15785B7E063D464C86DD482FCAE4EBA501CAC3EF69DA@XCH11.scidom.de>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Am 24.04.2015 um 16:08 schrieb Lentes, Bernd:
> Hi,
> 
> it should be just a small problem, but it is one. How can I rollback t
o a snapshot of my root filesystem ?
> Googeling, I found a lot of solutions, each different.
> I finally choosed this one: https://btrfs.wiki.kernel.org/index.php/Us
eCases#I_want_to_be_able_to_do_rollbacks_with_Btrfs
> 
> I made the snapshot, changed some configuration, and afterwards I'd li
ke to rollback to the snapshot:
> 
> - btrfs subvolume snapshot -r  /  /.snapshots/vor_nvidia
> 
> - change some configuration
> 
> - btrfs subvolume set-default 625 (id of the snapshot)
> 
> - reboot
...

It seems, that you has set the RO "readonly" flag on the subvolume.
The btrfs tool may se/unset the flag like

# mount /dev/sdXY /mnt -o subvol=/
# btrfs su list .
ID 258 gen 13711 top level 5 path backup
[ ... ]
# btrfs prop list backup
ro                  Set/get read-only flag of subvolume.
compression         Set/get compression for a file or directory

root@pc6:/mnt# btrfs prop get backup
ro=true
root@pc6:/mnt# btrfs prop set backup ro false
root@pc6:/mnt# btrfs prop get backup
ro=false

This worked on:
root@pc6:/mnt# uname -a ; btrfs --version
Linux pc6 3.19.3-3-ARCH #1 SMP PREEMPT Wed Apr 8 14:10:00 CEST 2015
x86_64 GNU/Linux
btrfs-progs v3.19

mit freundlichen Grüßen
Jürgen Sauer
- -- 
Jürgen Sauer - automatiX GmbH,
+49-4209-4699, juergen.sauer@automatix.de
Geschäftsführer: Jürgen Sauer,
Gerichtstand: Amtsgericht Walsrode • HRB 120986
Ust-Id: DE191468481 • St.Nr.: 36/211/08000
GPG Public Key zur Signaturprüfung:
http://www.automatix.de/juergen_sauer_publickey.gpg
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlU+EZgACgkQW7UKI9EqarFm9ACgzHjBGXV8Jlscn2ADV1fmdSo6
qgcAn0wWESh7XADCX2Lp8DWrz3FPSnMS
=5tHu
-----END PGP SIGNATURE-----
