Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f181.google.com ([209.85.213.181]:33078 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751664AbbKLN16 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Nov 2015 08:27:58 -0500
Received: by igvi2 with SMTP id i2so14305616igv.0
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Nov 2015 05:27:57 -0800 (PST)
Subject: Re: Ideas for btrfs-convert fix(or rework)
To: Vytautas D <vytdau@gmail.com>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <56418E5D.9020604@gmx.com> <20151110125501.1aa6f155@natsu>
 <5641A7DA.6010102@gmx.com> <20151110140855.3ae7297c@natsu>
 <5641B64A.9020606@gmx.com> <pan$edd20$481e3529$4248bf13$5caaf119@cox.net>
 <CAO5K3OfBy72Yn1s4Ow2h_2KkE7U4wQA66oxjQLva82-D2LqScA@mail.gmail.com>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <564493D5.2070609@gmail.com>
Date: Thu, 12 Nov 2015 08:27:49 -0500
MIME-Version: 1.0
In-Reply-To: <CAO5K3OfBy72Yn1s4Ow2h_2KkE7U4wQA66oxjQLva82-D2LqScA@mail.gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms040300010804060909070209"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms040300010804060909070209
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-11-12 05:23, Vytautas D wrote:
> [ resending as it didnt get through. ]
>
> I got different opinion. btrfs-convert is something that
> brought me to btrfs. While there are other bugs to fix, someone
> dedicating time to fix btrfs-convert is of high interest to me.
> Sending right message to community, might make some rolling distros to
> trust it and experiment with it.
While I can kind of understand this, what has been said about it being=20
something you run exactly once per-system per-filesystem is not untrue=20
for almost all users.  It has almost no value for people setting up new=20
systems (because they can just use BTRFS directly), and I personally see =

very limited value for the two biggest rolling-release distros that I=20
know of (Arch and Gentoo), because the very fact that you installed a=20
system with either one means that you are fully capable of backing up=20
your data, and reprovisioning the system using BTRFS instead of whatever =

filesystem you are already using (and that will _always_ be safer than=20
in-place conversion).  I also see little value for non rolling-release=20
systems other than Ubuntu (and possibly Mint, I don't know if they have=20
reliably working in-place release upgrades or not) because system=20
upgrades with those are usually full re-installs (and by the time that=20
btrfs-convert has been around long enough that they consider it safe to=20
package, BTRFS will be a lot more prevalent and will likely have been=20
the default FS for them for a long time).


--------------ms040300010804060909070209
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUxMTEyMTMyNzQ5WjBPBgkq
hkiG9w0BCQQxQgRAPBuv3DmKz+Mq1lUprEiw+c11BZ3q/o2RiI4bY14kbVgCc/h9muj8HCXD
/kcNgKA3gDrub/KS2ulbqTzWxHZf/jBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxEt+DCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DAN
BgkqhkiG9w0BAQEFAASCAgBPJJodGGg/5XJseF72KvuK42M2NqNaoyI1xK65gXeJDRpIHIrZ
bLnAA8KKnB3oPVi3MrInH8y0jkwfDupjmyv7N0yBPPKy5ywSNwextnW54pHMS3EQTG/uEUjF
zCZC61KK9bDS6RLrR4z/DHYhUC3FiwJbaC2bPcQ67mma0drGBSCTwiYlzLBaIRa6ik89hzOU
V8sUdjl/GyHcvENOoDbQ25wVM6IxNbOpc5znf6BCgKKh571ZmHEr8oZIbFxk8J7cqxCTcfnz
trYYZzrvG8J/Tn4WQ97xrCDChh0BcCmFOsaMllJM5UDCStYsFrZn9vU4v6B9GQbxMtACINX5
w+xMvPOHcCEnzAWQ97Fw5bBznxQNVuruhrdNwH8fKR09aEmNdRYJ4jXgb8kVnzFpkWrsNCiO
FjzDTX7JtfHVciGcGCeSBsTrtKwaK+6ySyP82eeZ1BlEDc2lQZwuV/6ieEqw1z2/W+J76zs0
z+T/4UfwU6gB7CYfqe3XNW87DJIdCGADoVGJGFnLVdxCmt4zs0ORt0oa43j0aCgefLTdu5MH
IgMQC8Wi8tp2FeHD3JKSYCnH1wg2uyCMgIfyJuPp8JGK/M2HAVaIgULVLehh7DLLRNJ1GOjJ
9qM/hXz/Y/IcTxgkm0lazmcauKND+tekAnCXMEWE6jb/pG/b5e9jDNRbCAAAAAAAAA==
--------------ms040300010804060909070209--
