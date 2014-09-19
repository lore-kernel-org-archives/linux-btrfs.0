Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:57556 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756002AbaISQvQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Sep 2014 12:51:16 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
	by gateway2.nyi.internal (Postfix) with ESMTP id 9E94320132
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Sep 2014 12:51:15 -0400 (EDT)
Received: from [192.168.0.10] (unknown [87.115.91.188])
	by mail.messagingengine.com (Postfix) with ESMTPA id 3998DC00919
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Sep 2014 12:51:15 -0400 (EDT)
Message-ID: <1411145469.1601.2.camel@zarniwoop.blob>
Subject: Re: Performance Issues
From: Rob Spanton <rob@robspanton.com>
Reply-To: rob@robspanton.com
To: linux-btrfs@vger.kernel.org
Date: Fri, 19 Sep 2014 17:51:09 +0100
In-Reply-To: <541C464F.3030600@fb.com>
References: <1411129114.1811.7.camel@zarniwoop.blob>
	 <541C464F.3030600@fb.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-XVWPZCpJlg5zwxbNSWPW"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--=-XVWPZCpJlg5zwxbNSWPW
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

Thanks for the response everyone.

I wrote:
> I have a particularly uncomplicated setup (a desktop PC with a hard
> disk) and I'm seeing particularly slow performance from btrfs.  A `git
> status` in the linux source tree takes about 46 seconds after dropping
> caches, whereas on other machines using ext4 this takes about 13s.  My
> mail client (evolution) also seems to perform particularly poorly on
> this setup, and my hunch is that it's spending a lot of time waiting on
> the filesystem.

The evolution problem has been improved: the sqlite db that it was using
had over 18000 fragments, so I got evolution to recreate that file with
nocow set.  It now takes "only" 30s to load my mail rather than 80s,
which is better...

On Fri, 2014-09-19 at 11:05 -0400, Josef Bacik wrote:
> Weird, I get the exact opposite performance.  Anyway it's probably=20
> because of your file layouts, try defragging your git dir and see if=20
> that helps.  Thanks,

Defragging has improved matters a bit: it now takes 26s (was 46s) to run
git status.  Still not amazing, but at the moment I have no evidence to
suggest that it's not something to do with the machine's hardware.  If I
get time over the weekend I'll dig out an external hard disk and try a
couple of benchmarks with that.

For reference, these are the mount flags:
        /dev/sda4 on / type btrfs (rw,noatime,space_cache)
        /dev/sda4 on /home type btrfs (rw,noatime,space_cache)

Cheers,

Rob


--=-XVWPZCpJlg5zwxbNSWPW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABAgAGBQJUHF8CAAoJELnJXuxeMxduav8P/1qSndNoBiMegfoQjvj4it1r
RVvk8hXQdJnBrIankA8L8cTFV5uof8JVpcewwrI0bwZeVfcSN+vx1PTMF7aH2An5
YaYofOHGf5lPVA5SDb8mBaRwyV5krmXNNsJnT0g1jRrVRjuxN/gGGCt0yqzs4cdF
k0kX9APhjpiVZZpNhF1FU58JtAO+lxbBBR2AA6YjLjLH5jw1nF7A87O+3GlMKTnR
ZIUypL8vQFaxAtaTDnwi0lBQeDkr4oIUjdggEum/R/9dZtmDzOoqnL7EDP68Jon6
qWBQszxaAAsvbhgViv8p6WC7Qs6Sfd7E5u6F1o85CjxZnGVsR2zLcqQdfeitnfkT
yjOILjefHgMtUoAdWmhmKt2gSypilD27VwLe8+wzVy0aYeHbWE7swnkwUmuJC3O7
I41AP2ty37V8zv4MC39cJvNBmNk74HLtZX6wSd9cPPKrUbf/2SOc08vJRHMIX/Ka
Hcv/mmlOPPi9OdZ6Z4wRFnW8grgMF24tqBJkeWwIytpP6dsTJ+F35eSIfBEmLfv+
JTZPBqfkajX5XxiuAHZcMMHVNNKCJsBug4MqBiE98zqXcE5CR3RKEDODgaaCgRrv
c/xhKDy+NO5Ng2rW6LFNDE3db/SyVXHu8PlCyfd/GU4hQAJ6PCdb36hWMDpveQ9C
2WferktJc6Vx1vQWYxbN
=3TWx
-----END PGP SIGNATURE-----

--=-XVWPZCpJlg5zwxbNSWPW--

