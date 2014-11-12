Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.automatix.de ([213.131.255.221]:44394 "EHLO
	mail.automatix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753045AbaKLR1D (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Nov 2014 12:27:03 -0500
Received: from [192.168.11.17] (vpn1 [213.131.255.219])
	(using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	(Authenticated sender: jojo@automatix.de)
	by mail.automatix.de (Postfix) with ESMTPSA id EBC87600A5
	for <linux-btrfs@vger.kernel.org>; Wed, 12 Nov 2014 18:27:00 +0100 (CET)
Message-ID: <54639860.7030206@automatix.de>
Date: Wed, 12 Nov 2014 18:26:56 +0100
From: Juergen Sauer <juergen.sauer@automatix.de>
MIME-Version: 1.0
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: BTRFS Raid5/6 Recovery Problem after accidentially hibernation
References: <5461EF65.4040206@automatix.de> <pan$9e48b$dee08040$a812fe40$6995150@cox.net>
In-Reply-To: <pan$9e48b$dee08040$a812fe40$6995150@cox.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Was: Re: transid failed / mount Problem on Linux pc6 3.17.2-1-ARCH #1
SMP PREEMPT Thu Oct 30 20:49:39 CET 2014 x86_64 GNU/Linux

Am 11.11.2014 um 23:39 schrieb Duncan:

> Tho after early experiences I switched to mdraid-1 some time in the past,
[..]

> So if it's really critical, as it arguably might be on an archive
> machine, I'd consider pointing whatever suspend/hibernate triggers at
> shutdown or reboot, instead.  If it's not possible to accidentally
> hibernate the thing, it triggers shutdown/reboot instead, it won't/can't
> be accidentally hibernated. =:^)
:)
I didn't recongnize bevore that the hibernation is so what faulty.
It does not care for me anymore, disabled it.

It's like the old story. A test machine was just used for production,
after it worked very fantastic. BTRFS on the raid5/6 seznario has really
great potential.

> Btrfs raid5, or mdraid-5 with btrfs on top?
It's not mdraid. It's really Rais56 of BTRFS.

> Because it's common
> knowledge that btrfs raid56 modes aren't yet fully implemented, and while
> they work in normal operation, recovery from a lost device is iffy at
> best because the code simply isn't complete for that yet.
Ok, seems to be nessesary to open my "emacs". :)
The recovery code for raid5/6 has to be grow to mature. I'll look, what
I can do. But my skills in kernel hacking are somewhat very old. I did
not worked on kernel since 17 year or so, I just code on industrial
automation - crane robotics for cement plants. (heavy metal coding, with
cranes > 50 tons and >10 tons of material in the grip, all is in linux
:))) ).

> As such a
> raid5/6 mode btrfs is best effectively considered a raid0 in terms of
[...]

> If you /did/ mean btrfs raid56 mode, then take a look at the raid56
> information on the wiki and the links from there to additional
> information on Marc MERLIN's site,
[,,,]

> https://btrfs.wiki.kernel.org/index.php/RAID56

I'll follow that hint.
(and I change Topic)

Thank you Duncan, I see, this gets really into the deep. But I hope
fixing this, it may improve BTRFS in general. I hope I get the right
contact.


Current Status:
# root@pc6:~# btrfs fi show /dev/sda1
# parent transid verify failed on 209362944 wanted 293924 found 293922
# parent transid verify failed on 209362944 wanted 293924 found 293922
# Check tree block failed, want=209362944, have=209559552
# parent transid verify failed on 209362944 wanted 293924 found 293922
# Ignoring transid failure
# Label: 'archiv'  uuid: 48f71e09-6898-4665-bc61-bd7ca4ba4a24
#        Total devices 4 FS bytes used 3.35TiB
#        devid    1 size 1.70TiB used 726.69GiB path /dev/sdh3
#        devid    2 size 1.82TiB used 1.35TiB path /dev/sda1
#        devid    3 size 1.82TiB used 1.35TiB path /dev/sdj1
#        devid    4 size 1.82TiB used 1.35TiB path /dev/sdi1
# Btrfs v3.17.1

What does "parent transid verify failed on 209362944 wanted 293924 found
293922" really mean?

Trying to mount ends up with:
root@pc6:~# mount -v -t btrfs -o ro,degraded LABEL=archiv /mnt

dmesg Log exerpt:
[Nov12 09:44] BTRFS info (device sdi1): allowing degraded mounts
[  +0,000005] BTRFS info (device sdi1): disk space caching is enabled
[  +0,026335] verify_parent_transid: 6 callbacks suppressed
[  +0,000005] parent transid verify failed on 209362944 wanted 293924
found 293922
[  +0,000302] parent transid verify failed on 209362944 wanted 293924
found 293922
[  +0,003393] parent transid verify failed on 244719616 wanted 293924
found 293922
[  +0,000303] parent transid verify failed on 244719616 wanted 293924
found 293922
[  +0,000558] BTRFS: bdev /dev/sda1 errs: wr 3, rd 0, flush 1, corrupt
0, gen 0
[  +0,000402] parent transid verify failed on 209375232 wanted 293924
found 293914
[  +0,000275] parent transid verify failed on 209375232 wanted 293924
found 293914
[  +0,001366] parent transid verify failed on 245538816 wanted 293924
found 293922
[  +0,000269] parent transid verify failed on 245538816 wanted 293924
found 293922
[  +0,033266] parent transid verify failed on 253378560 wanted 293924
found 293914
[  +0,001869] parent transid verify failed on 253378560 wanted 293924
found 293914
[  +0,028920] BTRFS: bad tree block start 0 253911040
[  +0,000013] BTRFS: Failed to read block groups: -5
[  +0,047223] BTRFS: open_ctree failed

It would be great, to recover.

I anybody from the raid5/6 developer team reading here?

TIA

mit freundlichen Grüßen
Jürgen Sauer
- -- 
Jürgen Sauer - automatiX GmbH,
GPG Public Key zur
Signaturprüfung:http://www.automatix.de/juergen_sauer_publickey.gpg
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlRjmGAACgkQW7UKI9EqarG5nQCgnRxghqq62EJWQsoe9MyZzYp6
56UAn2CLA86NKpdzu8Bc49j7RRes4eGd
=ClEg
-----END PGP SIGNATURE-----
