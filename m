Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from csamuel.org ([74.50.50.137]:56074 "EHLO csamuel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751897AbaCIE0K (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 8 Mar 2014 23:26:10 -0500
Received: from localhost (localhost [127.0.0.1])
	by csamuel.org (Postfix) with ESMTP id 33E3E417CF
	for <linux-btrfs@vger.kernel.org>; Sun,  9 Mar 2014 15:26:10 +1100 (EST)
Received: from csamuel.org ([127.0.0.1])
 by localhost (csamuel.org [127.0.0.1]) (amavisd-maia, port 10024) with LMTP
 id 27696-05 for <linux-btrfs@vger.kernel.org>;
 Sun,  9 Mar 2014 15:26:10 +1100 (EST)
Received: from quad.localnet (ppp59-167-127-196.static.internode.on.net [59.167.127.196])
	by csamuel.org (Postfix) with ESMTPSA id CA1A6417CD
	for <linux-btrfs@vger.kernel.org>; Sun,  9 Mar 2014 15:26:09 +1100 (EST)
From: Chris Samuel <chris@csamuel.org>
To: linux-btrfs@vger.kernel.org
Subject: Re: btrfs send kernel error btrfs_compare_tree
Date: Sun, 09 Mar 2014 15:26:03 +1100
Message-ID: <1470971.lGYHE1ADYY@quad>
In-Reply-To: <531B6434.1080409@travislists.com>
References: <531B6434.1080409@travislists.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart4506465.HN0JdxYAlD"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--nextPart4506465.HN0JdxYAlD
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="us-ascii"

On Sat, 8 Mar 2014 06:40:52 PM Travis Cross wrote:

> $ uname -a
> Linux 3.13-1-amd64 #1 SMP Debian 3.13.5-1 (2014-03-04) x86_64 GNU/Lin=
ux

Not sure if it will help, but Chris Mason has a git tree with currently=
 4 fixes
against 3.13.5:

https://git.kernel.org/cgit/linux/kernel/git/mason/linux-btrfs.git/log/=
?h=3Dfor-stable-3.13

Best of luck!
Chris
=2D-=20
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC


--nextPart4506465.HN0JdxYAlD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQEVAwUAUxvtW41yjaOTJg85AQKP3Af8DoJNuzS6NmEsfjmhXInklUneTUgKEYa0
lLaMIjwSgwD+iCet2oXAWmDYGjn7EB7HV+jj6jfO6lMZLMgF2d7JqSIfFHc4jtcQ
MblbMrHPldkYN4yfePljqOhHkfVfuYniQmuTuoqlwnQh8z65dxvF5UH0RhiYL1ZV
h8E44VHBXBSBULnUxKo5p9BoWo3a3zzTPGRn0kEak5+oRMWhBnGAWHDwM/B1f5En
fxfQkohN5kEswUF1ZElXBNVCMRDOgIsc9PcDDtlue/LURqY43bpQ/sRsMRuiihEY
G4hqf8awp5ZzvVdfgT45rkJ7e9yoifYaWm72AjrHaHTrJsmoGaHEEQ==
=Amk0
-----END PGP SIGNATURE-----

--nextPart4506465.HN0JdxYAlD--

