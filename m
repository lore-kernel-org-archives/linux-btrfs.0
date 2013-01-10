Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:36025 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932176Ab3AJDne (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Jan 2013 22:43:34 -0500
Received: from [IPv6:2001:470:8:97a::1] (scurvy.electronsweatshop.com [IPv6:2001:470:8:97a::1])
	by skull.electronsweatshop.com (Postfix) with ESMTP id A067E489A4
	for <linux-btrfs@vger.kernel.org>; Wed,  9 Jan 2013 22:43:23 -0500 (EST)
Message-ID: <50EE38DC.6000802@electronsweatshop.com>
Date: Wed, 09 Jan 2013 22:43:24 -0500
From: Randy Barlow <randy@electronsweatshop.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: Btrfs fs not mounting or being identified after power loss.
References: <CACCfv7ouftvEwAg0HWxCVSaOh+Q=K0+T65n0L4KJRqVa-e2_NA@mail.gmail.com> <50ECAC5C.9080902@electronsweatshop.com> <CACCfv7roxHpeBd5PCUEwn9ACFpq4396wHSMg2itEsf6k3CDkrA@mail.gmail.com>
In-Reply-To: <CACCfv7roxHpeBd5PCUEwn9ACFpq4396wHSMg2itEsf6k3CDkrA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 01/08/2013 10:46 PM, Jordan Windsor wrote:
> kernel is at 3.6.11-1-ARCH

Sorry I don't know much to help you, but I would suggest perhaps using
a newer kernel in the future. It sounds like your FS might be in
trouble as is, but I would recommend using the most recent RC kernel
(3.8-rc3) and restoring your data to a new btrfs from backups. In
general, it's a good idea to stick to pretty recent kernels with btrfs.
Hope this helps!

- -- 
R
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAlDuONwACgkQw3vjPfF7QfW5iQCbBYvZym0krlweyntdyqJ8XobG
p+oAniAyDdt20c57WXw5Ewvf1rhDQQ1o
=2rpQ
-----END PGP SIGNATURE-----
