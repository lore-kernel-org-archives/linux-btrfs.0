Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f50.google.com ([209.85.192.50]:32829 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751286AbbHYPRz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Aug 2015 11:17:55 -0400
Received: by qgeh99 with SMTP id h99so48814602qge.0
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Aug 2015 08:17:54 -0700 (PDT)
Subject: Re: Btrfs tragedy: lack of space for metadata leads to loss of fs.
To: =?UTF-8?Q?Miguel_Negr=c3=a3o?=
	<miguel.negrao-lists@friendlyvirus.org>,
        linux-btrfs@vger.kernel.org
References: <loom.20150825T151154-787@post.gmane.org>
From: Matt Ruffalo <matt.ruffalo@gmail.com>
Message-ID: <55DC8718.8060209@gmail.com>
Date: Tue, 25 Aug 2015 11:17:44 -0400
MIME-Version: 1.0
In-Reply-To: <loom.20150825T151154-787@post.gmane.org>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="uGC0sAUJ70JESvre3QE6eNbH99v15aWrM"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--uGC0sAUJ70JESvre3QE6eNbH99v15aWrM
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 2015-08-25 09:44, Miguel Negr=C3=A3o wrote:
> Hi list,
>
> This weekend had my first btrfs horror story.=20
>
> system: 3.13.0-49-lowlatency, btrfs-progs v4.1.2
>
> A disclaimer: I know 3.13 is very out of date, but I the requirement of=

> keeping kernel up to date clashes with my requirement of keeping a stab=
le
> system. At the moment I can't disturb my system as I'm doing important =
work,
> upgrading kernel requires upgrading ubuntu, which will upgrade a lot of=

> packages and might lead to problems which I don't have time to fix. One=

> might argue that in the end I lost time anyway dealing with these btrfs=

> issues. When I'm done with this current work I will update the whole sy=
stem
> which will update the kernel in the process.

Hi-

I have no useful advice about filesystem recovery, but would like to
point out that newer kernels are backported to Ubuntu LTS versions and
can be installed without any significant disruption of the system.

The normal kernel backports are named 'linux-generic-lts-<version
codename>', and the low latency versions are
'linux-lowlatency-lts-<version codename>', so you could install kernel
3.16 (from 14.10 "utopic") by installing linux-lowlatency-lts-utopic,
and kernel 3.19 (from 15.04 "vivid") by installing
linux-lowlatency-lts-vivid. Kernel 4.1 will be available as
linux-{generic,lowlatency}-lts-wily a bit after 15.10 is released.

MMR...


--uGC0sAUJ70JESvre3QE6eNbH99v15aWrM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCgAGBQJV3IchAAoJECIsbUsR6qsOItkP/jBTj7GCBgDXtKzlpwOpKIep
A+CZp9xhGD60VtQ/WX6uAnsUDwERQEEb+N3RRLyzgbKC+dz489f+7Oa3K8KCZD19
kYB8atKpf9tvqA+0fgXQd53uIyTiqFySaPY2r4kVHKVSwWUPe9/nwM35M9dRl0cI
ZJ3YSy0/qL3K+JPoRvnsRkfh37zEGs4W76wlaDsANFEPE6AkCrQOJpqANzWB8cUF
MMUtkkNcFM2kABXAoDMLHpVQbXWYTrFlC7GlqTa1zFcwOkAAFMRRgaqny2JfKN/u
yxSpO7VCRNN4tykCBh8yhhXb6MwNB3ElFHXQFp6zTPx+Kj/bPln96bKVuTS3/CD2
1qONLu/32+8hfvei+Ht/Ybkp7xwo6uGx6WjnUVeeTDfjsyxjdsNE3aeRzUHpnEMz
KyXkLMVXx4xwqrdpJC3I9S16Ujjhq7x++76M8s1K6OWJ6NJ6g+g+PvuFnNjFa2nS
fPSI14RnyEOkvCg/vg/NWcCeRXXVRKxQl2060+suyAQZa2BK1wJ8FQqsXxvAr2xy
Z0RkaSWNJcl7s1fKlyV3qDPj+fW23RTtxciWx4z4gBQfFNyQN/ttTFj0XdGIjhOI
DLxow5u7OimHCPHYqPK3oqsVd3ScU9Rk4pWJag1rd5/z0b2F58J+kqJbfG3jzyee
CqFld9bkEJX6LYFQY7jW
=iCG2
-----END PGP SIGNATURE-----

--uGC0sAUJ70JESvre3QE6eNbH99v15aWrM--
