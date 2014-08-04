Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f182.google.com ([209.85.213.182]:44449 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753459AbaHDRJb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Aug 2014 13:09:31 -0400
Received: by mail-ig0-f182.google.com with SMTP id c1so5730604igq.3
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Aug 2014 10:09:30 -0700 (PDT)
Message-ID: <53DFBE43.2050901@gmail.com>
Date: Mon, 04 Aug 2014 13:09:23 -0400
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: Peter Waller <peter@scraperwiki.com>
CC: Hugo Mills <hugo@carfax.org.uk>, Chris Samuel <chris@csamuel.org>,
        linux-btrfs@vger.kernel.org
Subject: Re: ENOSPC with mkdir and rename
References: <CAFChkqtpb+xMhFk+7RBux-o-FOO0oaxx28Wz-LZZZVpvq2nRFQ@mail.gmail.com> <53DEE40C.6020403@cn.fujitsu.com> <CAFChkqttiPWQ+FquT2FfKE54US7vkeEyQsUT8fuD1BWNhS3k=w@mail.gmail.com> <17833067.mzxAL4oqZq@quad> <CAFChkqs3LOM4HmDzpXgs6YTeoXvyNPbsNWCPf74=_MnPneJ+HQ@mail.gmail.com> <20140804102206.GA31950@carfax.org.uk> <CAFChkquonAbMbPynpxvayb3qpLAEcMSfC2TvGKCG+kFo-Qy7eA@mail.gmail.com>
In-Reply-To: <CAFChkquonAbMbPynpxvayb3qpLAEcMSfC2TvGKCG+kFo-Qy7eA@mail.gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms050904080203080106060506"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms050904080203080106060506
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 2014-08-04 06:31, Peter Waller wrote:
> Thanks Hugo, this is the most informative e-mail yet! (more inline)
>=20
> On 4 August 2014 11:22, Hugo Mills <hugo@carfax.org.uk> wrote:
>>
>>  * btrfs fi show
>>     - look at the total and used values. If used < total, you're OK.
>>       If used =3D=3D total, then you could potentially hit ENOSPC.
>=20
> Another thing which is unclear and undocumented anywhere I can find is
> what the meaning of `btrfs fi show` is.
>=20
> I'm sure it is totally obvious if you are a developer or if you have
> used it for long enough. But it isn't covered in the manpage, nor in
> the oracle documentation, nor anywhere on the wiki that I could find.
>=20
You didn't look very hard then, because there is information in the
manpage (oh wait, you mentioned Oracle, your probably using RHEL or
CentOS, which are the last thing you should be using if you want to use
stuff like BTRFS that is under heavy development), and it is documented
on the wiki.
> When I looked at it in my problematic situation, it said "500 GiB /
> 500 GiB". That sounded fine to me because I interpreted the output as
> what fraction of which RAID devices BTRFS was using. In other words, I
> thought "Oh, BTRFS will just make use of the whole device that's
> available to it.". I thought that `btrfs fi df` was the source of
> information for how much space was free inside of that.
>=20
>>  * btrfs fi df
>>     - look at metadata used vs total. If these are close to zero (on
>>       3.15+) or close to 512 MiB (on <3.15), then you are in danger of=

>>       ENOSPC.
>=20
> Hmm. It's unfortunate that this could indicate an amount of space
> which is free when it actually isn't.
That depends on what you mean by 'free'.
>=20
>>     - look at data used vs total. If the used is much smaller than
>>       total, you can reclaim some of the allocation with a filtered
>>       balance (btrfs balance start -dusage=3D5), which will then give
>>       you unallocated space again (see the btrfs fi show test).
>=20
> So the filtered balance didn't help in my situation. I understand it's
> something to do with the "5" parameter. But I do not understand what
> the impact of changing this parameter is. It is something to do with a
> fraction of something, but those things are still not present in my
> mental model despite a large amount of reading. Is there an
> illustration which could clear this up?
>=20
Think of each chunk like a box, and each block as a block, and that you
have two different types of block (data and metadata) and two different
types of box (also data and metadata). The data boxes are four times the
size of the metadata boxes, and they all have to fit in one really big
container (the device itself).  You can only put data blocks in the data
boxs, and you can only put metadata blocks in metadata boxes.  Say that
in total, you can fit 128 data boxes in the large container, or you can
replace one data box with up to four metadata boxes.  Even though you
may only have a few blocks in a given box, the box still takes up the
same amount of space in the larger container.  Thus, it's possible to
have only a few blocks stored, but not be able to add any more boxes to
the larger container.  A balance operation is essentially the equivalent
of taking all of the blocks of a given type, and fitting them into the
smallest number of boxes possible.
> Among other things I also got the kernel stack trace I pasted at the
> bottom of the first e-mail to this thread when I did the rebalance.
>=20
>>    This FAQ entry is pretty horrible, I'm afraid. I actually started
>> rewriting it here to try to make it clearer what's going on. I'll try
>> to work on it a bit more this week and put out a better version for
>> the wiki.
>=20
> This is great to hear! :)
>=20
> Thanks for your response Hugo, that really cleared up a lot of mental
> model problems. I hope the documentation can be improved so that
> others can learn from my mistakes.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20



--------------ms050904080203080106060506
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIGuDCC
BrQwggScoAMCAQICAw8BRDANBgkqhkiG9w0BAQ0FADB5MRAwDgYDVQQKEwdSb290IENBMR4w
HAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMTGUNBIENlcnQgU2lnbmlu
ZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2FjZXJ0Lm9yZzAeFw0xNDA1
MTIxNDEwMzJaFw0xNDExMDgxNDEwMzJaMGMxGDAWBgNVBAMTD0NBY2VydCBXb1QgVXNlcjEj
MCEGCSqGSIb3DQEJARYUYWhmZXJyb2luN0BnbWFpbC5jb20xIjAgBgkqhkiG9w0BCQEWE2Fo
ZW1tZWxnQG9oaW9ndC5jb20wggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAwggIKAoICAQDbLUaL
Gs4JTdU7sgr0MzD57CMUAv307ddC9pxooDMN3PiUvzEd5kLtBCh8KDB1wbMdfm4hte2rDd+j
hM1tIq67BvNbdDPztOcBZwT2/3OVyyG4B1ddCqUyt03zGKw6Y34eHNfapsZiiItX0GBNfjHU
Wv+WDo+XNha/WmGSSMv21HkftF9XA1KC9Bpr9JJI23MKK7T2g/7b3KoGZlx3ekLIJsF5B7+B
DMPPDqOHQbRnccyOHEMyhM13g6WoAbU+3aKYc+C/9UsYtDV+xlvBLWagky1acstD5wOA35V6
uDRbUhD+vOjuMRMCj9jJOIYqa6AeSagBjxRnisJr0RFzQ4f+NjGCHPaFTvRvbkiXh4q22doT
0SxbNBUm7B9ANugIOtS9/VQhTWKDi//WTqZQ7Ecl4yVJbMCUg/iaRHMCGS41vqMICPszRidW
rL04NwS9D2cREEY1y/xrNo0ZvKPZu6tLhxhPf7w+5rsN3+wWxGaR1hNpnVUT9AeacLKZO6W9
FsRT3Unkr91IhQATHTKYr4EAkjN/5lgvA+sxp5TxxsUnoJYrD8IHf8aYfJsAHMleBwx4xSeZ
tw/n5iIjJjFZq9IRZ1zQhK62p+a5vJ2vlJHjTgavhQrfb1pUOjbqsnI4ndQ5hNosL9el4Kxq
Yko+HsxVEmSwSsjq6cV2L3oz0z8NUwIDAQABo4IBWTCCAVUwDAYDVR0TAQH/BAIwADBWBglg
hkgBhvhCAQ0ESRZHVG8gZ2V0IHlvdXIgb3duIGNlcnRpZmljYXRlIGZvciBGUkVFIGhlYWQg
b3ZlciB0byBodHRwOi8vd3d3LkNBY2VydC5vcmcwDgYDVR0PAQH/BAQDAgOoMEAGA1UdJQQ5
MDcGCCsGAQUFBwMEBggrBgEFBQcDAgYKKwYBBAGCNwoDBAYKKwYBBAGCNwoDAwYJYIZIAYb4
QgQBMDIGCCsGAQUFBwEBBCYwJDAiBggrBgEFBQcwAYYWaHR0cDovL29jc3AuY2FjZXJ0Lm9y
ZzAxBgNVHR8EKjAoMCagJKAihiBodHRwOi8vY3JsLmNhY2VydC5vcmcvcmV2b2tlLmNybDA0
BgNVHREELTArgRRhaGZlcnJvaW43QGdtYWlsLmNvbYETYWhlbW1lbGdAb2hpb2d0LmNvbTAN
BgkqhkiG9w0BAQ0FAAOCAgEAIokFPcW8+cO2Clu0Ei+ehAmQRBHfV5RWJ8aMVLXOCfiJX0ch
IjVSIt6I3uQaR4J1ZIAjCSPkbpfZQDaLoGFI5j8aYEQhOeKxrvOMzY9/aSUYabCJIhE/sX64
klFV0bzm+PR9cDMWeQ9BoZf0m8UROPSfDnrjEk+p04hGg3pAZMcSwCzxdb604NHjgHJmf2xG
UQVzQgC6Ek/BKat0xuPTuPmtPv9OicK75CPmLZKYW3rFpCD6bhb1mm+ROcCNhniRY2LYm9YN
QdlHQUzTFqj0tvuYrzNI3LNV4PjEfN8z6omPCT2Rq8/uKLseN+m8F0ioqm+cphqpmzKoDUpN
nePLkqDFUFWCeWRxSjBTy4IMVUfdNXriVGihH8hyIICQiOfmmBOzhzUifdomJuTGtoXRuHVT
R2f/YdrJrLnKI4f+Othdp7F3KhB4c6JiOnTEH5J8n9q3rFjt4MPRwcjIHMhmF5nZVQlgxEMo
1cPCmvG1D9tcgXbH79jjqydo9SDXhzLQob7axkzGRY96IstNcvoQ/UNsdPPfFMYlHtGz4TxT
DhBjv4ERskGmKBZrfmxkXkcuTV/gcykct6Xvw9YXb8WTL4qSYHSYk9fReVLgE/L4RBUpX2JJ
QvIR0AJLER165/aZlQXZtuJjnfxJtJTJZZ+Gor9h0G2kuR5Dy0JuYdBO4t4xggShMIIEnQIB
ATCBgDB5MRAwDgYDVQQKEwdSb290IENBMR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5v
cmcxIjAgBgNVBAMTGUNBIENlcnQgU2lnbmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEW
EnN1cHBvcnRAY2FjZXJ0Lm9yZwIDDwFEMAkGBSsOAwIaBQCgggH1MBgGCSqGSIb3DQEJAzEL
BgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTE0MDgwNDE3MDkyM1owIwYJKoZIhvcNAQkE
MRYEFJsX5DU9dTrSDwN4j5L1NkRmz7PlMGwGCSqGSIb3DQEJDzFfMF0wCwYJYIZIAWUDBAEq
MAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcNAwIC
AUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwgZEGCSsGAQQBgjcQBDGBgzCBgDB5MRAwDgYD
VQQKEwdSb290IENBMR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMT
GUNBIENlcnQgU2lnbmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2Fj
ZXJ0Lm9yZwIDDwFEMIGTBgsqhkiG9w0BCRACCzGBg6CBgDB5MRAwDgYDVQQKEwdSb290IENB
MR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMTGUNBIENlcnQgU2ln
bmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2FjZXJ0Lm9yZwIDDwFE
MA0GCSqGSIb3DQEBAQUABIICAILY1vxwofZopV2e+dTtAAhoZGKiODsmZ6/H2bRPULnajYcn
kvFWXkFClvht0jEkWYEx4weNMEQUG5Ga2VQOtJpxpF6OBArfJHVVvY4KyzUQHDeO8awBDqrC
Q8M4IKIFVwvzp181cGbGH7Ol0M/FY5+f0UDr+sd1rTpS01zCMZ/a9e/K6jKbyotSdfGv0tqn
5n78Zt1SpN7M56JZUPXzsTlIVKCXRCGylDkp0SwJxJR3qVrYYDT6SBvW3LrOhQc2p4TGfws0
G/lPxiUH1xqxllCo2TyA/PWiXyGNHhniJOK8LdfBm8gOAycMbmWtys42CecLfhmp9X3Z8luE
KYW+0DLZDweOa8OwFDL0R72HcqWNS/2tSbwDOyLk57zRiIp90Wq1CrwbAVz1DE7eEpu53BU7
aghH8mfni6M8yQ5YR2ZnItkp1he+z/h96h4kaQ+Zg6LjPCkwauStRhvJmYIPSWJb9Avjc898
nCr2yfWArVB2b9FMpim/aLEbrjfU7EwG+pKbLlPHMjZGbfHT0iIT5e1Uoa2J7Ra5Ziw1OT3Q
HTVi8+K/XaZmAU8FP99/QTkauG/fL/LXWM2rwRgVV7EPYwmq5ockVWGWvumgzW4A9XTucf2i
zm3Xdo+ZsJ+4iVwb3LrkQPipC2e3J4gU5AJ6BqNOl+mIeJHpdeFj98msWj7UAAAAAAAA
--------------ms050904080203080106060506--
