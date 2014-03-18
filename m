Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:64588 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754064AbaCRNr1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Mar 2014 09:47:27 -0400
Received: by mail-qc0-f174.google.com with SMTP id c9so1800455qcz.5
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Mar 2014 06:47:27 -0700 (PDT)
From: Ben Gamari <bgamari.foss@gmail.com>
To: Ajesh js <coolajeshjs@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: Please help me to contribute to btrfs project
In-Reply-To: <CA+nQTon3WcD_gdcFyhDwXt=Y7kBu4DZ78YD2=-G+1z8yA2fCQg@mail.gmail.com>
References: <CA+nQTon3WcD_gdcFyhDwXt=Y7kBu4DZ78YD2=-G+1z8yA2fCQg@mail.gmail.com>
Date: Tue, 18 Mar 2014 09:47:23 -0400
Message-ID: <87wqfrr53o.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--=-=-=
Content-Type: text/plain

Ajesh js <coolajeshjs@gmail.com> writes:

> Hi,
>
> I have used the btrfs filesystem in one of my projects and I have
> added a small feature to it. I feel that the same feature will be
> useful for others too. Hence I would like to contribute the same to
> open source.
>
Excellent!

> If everything works fine and this feature is not already added by
> somebody else, this will be my first contribution to the opensource &
> I am excited to join the huge family of opensource :)
>
> Please help me with a precise steps to do the same.
>
In general the way to contribute is to send a patch for review. You
should have a look at the code style guidelines[1] and patch submission
guidelines[2] in the kernel tree. For nontrivial changes the patch
should be accompanied by a cover letter describing the change and the
motivations for any non-obvious design decisions.

It is possible that your change is acceptable as-is. More likely,
however, is that there will be some discussion and requests for
changes. Eventually the review process will produce a merge-worthy
patch. The first step, however, is sending something concrete for
community review.

Cheers,

- Ben


[1] https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/Documentation/CodingStyle
[2] https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/Documentation/SubmittingPatches


--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQEcBAEBAgAGBQJTKE5rAAoJEErkyLZmeNiD7MIH/RE/B9YOzAdnipbxlVONMWMk
r1sUBjFFUuAUgqiGYVZZsre/x1mfpax8ttV2trfAwFPXjd/xxF5nYO4ZC7iUyNhw
IaLrW9gR7JvuR4uf7ZXrat0uybCCkeObFDPuO9AzsrPGLj4Jg7zmb49u4MOthtHD
BaWI/wK5ECiM8ploj/awfp0/a31YDk6278sMnNCREapZbbUTCkJXaGjkB/abeNAW
rqHP7EWAJOlJUVo6riU3ymSs7s5F+U2x4/9m/hxsxTp8yoLn+pTlEIk3dBS2O4qe
+dhSuxhWLTR0v5KN/Dx0khiM+9L0OY0sgvNqrTTZIJRXEmlKogdnxQW8wIpXSCQ=
=kO1M
-----END PGP SIGNATURE-----
--=-=-=--
