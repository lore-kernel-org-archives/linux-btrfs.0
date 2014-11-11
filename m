Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.automatix.de ([213.131.255.221]:43343 "EHLO
	mail.automatix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753334AbaKKLUd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Nov 2014 06:20:33 -0500
Received: from [192.168.11.17] (vpn1 [213.131.255.219])
	(using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	(Authenticated sender: jojo@automatix.de)
	by mail.automatix.de (Postfix) with ESMTPSA id E49B5600A6
	for <linux-btrfs@vger.kernel.org>; Tue, 11 Nov 2014 12:13:45 +0100 (CET)
Message-ID: <5461EF65.4040206@automatix.de>
Date: Tue, 11 Nov 2014 12:13:41 +0100
From: Juergen Sauer <juergen.sauer@automatix.de>
Reply-To: service@automatix.de
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: transid failed / mount Problem on Linux pc6 3.17.2-1-ARCH #1 SMP
 PREEMPT Thu Oct 30 20:49:39 CET 2014 x86_64 GNU/Linux
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi!
this event occoured today in the morning.
Accidentially the Archive Machine was kickt  into hibernation.

After reactivating the archive Btrfs filesystem was "readonly", after
rebooting the system the "archive" btrfs filesystem was not mountable
anymore.

I tried every thing of recovery possibilities I know. Nothing worked.

Here I liste the Problem of the Machine, it would be very ugly to loose
thoes data.

Do you have any further ideas, what I may try to recover my archive
filesystem?

The archive Filesystem is an raid5-multi device btrfs.

System:
root@pc6:/usr/src/build/btrfs-progs# uname -a
Linux pc6 3.17.2-1-ARCH #1 SMP PREEMPT Thu Oct 30 20:49:39 CET 2014
x86_64 GNU/Linux

This BTRFS Tools were in use:
git clone
git://git.kernel.org/pub/scm/linux/kernel/git/kdave/btrfs-progs.git

root@pc6:/usr/src/build/btrfs-progs# ./btrfs fi show
parent transid verify failed on 209362944 wanted 293924 found 293922
parent transid verify failed on 209362944 wanted 293924 found 293922
Check tree block failed, want=209362944, have=209559552
parent transid verify failed on 209362944 wanted 293924 found 293922
Ignoring transid failure
Label: 'archiv'  uuid: 48f71e09-6898-4665-bc61-bd7ca4ba4a24
        Total devices 4 FS bytes used 3.35TiB
        devid    1 size 1.70TiB used 726.69GiB path /dev/sdh3
        devid    2 size 1.82TiB used 1.35TiB path /dev/sda1
        devid    3 size 1.82TiB used 1.35TiB path /dev/sdj1
        devid    4 size 1.82TiB used 1.35TiB path /dev/sdi1

Btrfs v3.17.1

mount -o ro,recovery -t btrfs /dev/sdh3 /mnt
mount: Falscher Dateisystemtyp, ungültige Optionen, der
Superblock von /dev/sdh3 ist beschädigt, fehlende
Kodierungsseite oder ein anderer Fehler

       Manchmal liefert das Systemprotokoll wertvolle Informationen –
       versuchen Sie  dmesg | tail  oder ähnlich
root@pc6:/usr/src/build/btrfs-progs# dmesg ...

[ 7116.746815] BTRFS info (device sdi1): enabling auto recovery
[ 7116.746820] BTRFS info (device sdi1): disk space caching is enabled
[ 7117.028008] verify_parent_transid: 6 callbacks suppressed
[ 7117.028013] parent transid verify failed on 209362944 wanted 293924
found 293922
[ 7117.028324] parent transid verify failed on 209362944 wanted 293924
found 293922
[ 7117.033188] parent transid verify failed on 244719616 wanted 293924
found 293922
[ 7117.033516] parent transid verify failed on 244719616 wanted 293924
found 293922
[ 7117.034114] BTRFS: bdev /dev/sda1 errs: wr 3, rd 0, flush 1, corrupt
0, gen 0
[ 7117.034557] parent transid verify failed on 209375232 wanted 293924
found 293914
[ 7117.034873] parent transid verify failed on 209375232 wanted 293924
found 293914
[ 7117.037358] parent transid verify failed on 245538816 wanted 293924
found 293922
[ 7117.037702] parent transid verify failed on 245538816 wanted 293924
found 293922
[ 7117.108132] parent transid verify failed on 253378560 wanted 293924
found 293914
[ 7117.108509] parent transid verify failed on 253378560 wanted 293924
found 293914
[ 7117.231038] BTRFS: bad tree block start 0 253911040
[ 7117.231052] BTRFS: Failed to read block groups: -5
[ 7117.290534] BTRFS: open_ctree failed


root@pc6:/usr/src/build/btrfs-progs# btrfs check  --repair /dev/sdh3
enabling repair mode
parent transid verify failed on 209362944 wanted 293924 found 293922
parent transid verify failed on 209362944 wanted 293924 found 293922
Check tree block failed, want=209362944, have=209559552
parent transid verify failed on 209362944 wanted 293924 found 293922
Ignoring transid failure
parent transid verify failed on 247873536 wanted 293924 found 293922
parent transid verify failed on 247873536 wanted 293924 found 293922
Check tree block failed, want=247873536, have=248070144
parent transid verify failed on 247873536 wanted 293924 found 293922
Ignoring transid failure
leaf parent key incorrect 247873536


root@pc6:/usr/src/build/btrfs-progs# btrfs-zero-log  /dev/sdh3
parent transid verify failed on 209362944 wanted 293924 found 293922
parent transid verify failed on 209362944 wanted 293924 found 293922
Check tree block failed, want=209362944, have=209559552
parent transid verify failed on 209362944 wanted 293924 found 293922
Ignoring transid failure
Unable to find block group for 0
extent-tree.c:289: find_search_start: Assertion `1` failed.
btrfs-zero-log[0x40c0ca]
btrfs-zero-log[0x410eb3]
btrfs-zero-log[0x410f6f]
btrfs-zero-log[0x403361]
btrfs-zero-log[0x403975]
btrfs-zero-log[0x408606]
btrfs-zero-log[0x409d8e]
btrfs-zero-log[0x402542]
/usr/lib/libc.so.6(__libc_start_main+0xf0)[0x7f810af82040]
btrfs-zero-log[0x402653]

root@pc6:/usr/src/build/btrfs-progs# btrfs rescue  chunk-recover /dev/sdi1
Speicherzugriffsfehler (Speicherabzug geschrieben)


Any Ideas, I may check for ?

TIA ...

mit freundlichen Grüßen
Jürgen Sauer
- -- 
Jürgen Sauer - automatiX GmbH,
http://www.automatix.de/juergen_sauer_publickey.gpg
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlRh72UACgkQW7UKI9EqarHXMQCfdN8SgA5NZFw6TJpF/fSXUspn
FjsAoMDU/kRd2PSj4EvXF0moxC7c+26Z
=WpUq
-----END PGP SIGNATURE-----
