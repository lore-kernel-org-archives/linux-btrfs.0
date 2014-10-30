Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:52990 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752271AbaJ3OX2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 30 Oct 2014 10:23:28 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
	by mailout.nyi.internal (Postfix) with ESMTP id 2EE0820783
	for <linux-btrfs@vger.kernel.org>; Thu, 30 Oct 2014 10:23:27 -0400 (EDT)
Received: from [192.168.0.10] (unknown [87.115.91.188])
	by mail.messagingengine.com (Postfix) with ESMTPA id A8D82C00016
	for <linux-btrfs@vger.kernel.org>; Thu, 30 Oct 2014 10:23:26 -0400 (EDT)
Message-ID: <1414679004.7867.39.camel@zarniwoop.blob>
Subject: Re: Performance Issues
From: Rob Spanton <rob@robspanton.com>
Reply-To: rob@robspanton.com
To: linux-btrfs@vger.kernel.org
Date: Thu, 30 Oct 2014 14:23:24 +0000
In-Reply-To: <541C6BD1.7080604@fb.com>
References: <1411129114.1811.7.camel@zarniwoop.blob>
		 <541C464F.3030600@fb.com> <1411145469.1601.2.camel@zarniwoop.blob>
	 <541C6BD1.7080604@fb.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-EbWJIPZOb8701gLnRsT7"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--=-EbWJIPZOb8701gLnRsT7
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Everyone,

I wrote:
> I have a particularly uncomplicated setup (a desktop PC with a hard
> disk) and I'm seeing particularly slow performance from btrfs.  A `git
> status` in the linux source tree takes about 46 seconds after dropping
> caches, whereas on other machines using ext4 this takes about 13s.  My
> mail client (evolution) also seems to perform particularly poorly on
> this setup, and my hunch is that it's spending a lot of time waiting on
> the filesystem.

So I recently upgraded my desktop (now an i7-5820K on a Gigabyte
GA-X99-UD4 motherboard with 32GB of RAM), and moved the disk with this
problematic filesystem across to it.  With this new setup, I still get
reasonably poor performance: the git status now takes ~26 seconds after
dropping caches.  (Although note that this git repo has had been
repacked since I did the above benchmarks.)

I have also had the disk out on a USB-to-SATA adapter plugged into my
laptop, and seen similarly poor results.

So I've put the output of this command:

        trace-cmd record -T -e sched:sched_switch -o /tmp/trace.dat git sta=
tus

Here: http://robspanton.com/2014/10/trace.dat.xz

If anyone has any further ideas about how to remedy this situation,
please do let me know!

Cheers,

Rob

(Not subscribed to this list, so please CC me.)


--=-EbWJIPZOb8701gLnRsT7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABAgAGBQJUUkndAAoJELnJXuxeMxduW4MP/0/iJBGbNqCaiQ01byNcGwtY
nTd3pFaL442lG/cX6iplxmr7HXJA1zbc+bJM7XBpqXW7FpMn1dFjszD1KXA6tF2T
FHYQLhHQeRi7GdVBTOry0eVdaascUaK2kmRX3U4qwvMJWVJ1bZAcuMgW0PSMecK9
jVNTui2N5ezxt70nTPfycPYJsjpbXWwz+CBhtxpZZa4XcEgApPpyIyEUYppT0oaO
ZZuR7dVugBuiQyLhGQDCOJ30X2PHJNZk+Uir37/rBEQkifCTUF+7FukIMekbYdp2
h7ytDYi/MUTsGLebt1LCVAxI0pz80rSZRvSOViSJ2WubO5qGvGjbCwS4YzIFh7b5
zdqijdMdCa7gawP4xX1b8LzmdhAn3Parc/h2004R1QbXFga/Dh8PuT0a3aEjghuY
8bL/E8LXWRr5e4ZW2ZOFsDMJowOS0D1LGlohb1F17biDzD9FdKGB249RN4guV1oj
uaSxB26t5QN4K7WfffsvppQwKcBgtLkg7YqzlMzZvUVJ6adsF/lSg37CQ2Bd1miA
cqTVzJBx4Q3b4dTj0uMU5aaQU3JIFX4M0gMdneZgMylppCp7Axrs2m0hp9y1dFPq
YWFEpHUchVYAMD+20HTACVLVsFu1LV7jlemZDS3SnJF95NkSozFAhjl4gZezFLBt
vFU/QkEU6IQDiIeTdn6O
=73qM
-----END PGP SIGNATURE-----

--=-EbWJIPZOb8701gLnRsT7--

