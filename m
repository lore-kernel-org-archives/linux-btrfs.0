Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f172.google.com ([209.85.216.172]:47574 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752895AbaEZWQN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 26 May 2014 18:16:13 -0400
Received: by mail-qc0-f172.google.com with SMTP id l6so13048651qcy.31
        for <linux-btrfs@vger.kernel.org>; Mon, 26 May 2014 15:16:12 -0700 (PDT)
Message-ID: <5383BD29.5010309@gmail.com>
Date: Mon, 26 May 2014 18:16:09 -0400
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org, Michael Welsh Duggan <mwd@md5i.com>
Subject: Re: btrfs send ioctl failed with -5: Input/output error
References: <8761l2he31.fsf@maru2.md5i.com> <87k398z1xk.fsf@maru2.md5i.com>
In-Reply-To: <87k398z1xk.fsf@maru2.md5i.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms030408060204050307060007"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms030408060204050307060007
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 05/26/2014 05:04 PM, Michael Welsh Duggan wrote:
> Michael Welsh Duggan <mwd@md5i.com> writes:
>=20
>> I am now getting the following error when trying to do a btrfs send:
>>
>> root@maru2:/usr/local/src/btrfs-progs# ./btrfs send
>> /usr/local/snapshots/2014-05-15 > /backup/intermediate
>> At subvol /usr/local/snapshots/2014-05-15
>> ERROR: send ioctl failed with -5: Input/output error
>>
>> I'm running a 3.14.4 kernel, and Btrfs progs v3.14.1.
>>
>> root@maru2:/usr/local/src/btrfs-progs# uname -a
>> Linux maru2 3.14-1-amd64 #1 SMP Debian 3.14.4-1 (2014-05-13) x86_64 GN=
U/Linux
>>
>> root@maru2:/usr/local/src/btrfs-progs# ./btrfs --version
>> Btrfs v3.14.1
>>
>> Is there anything I can do to help debug this issue?
>=20
> I'd like to find out what is happening here.  I am an experienced C
> programmer, but have not dealt with kernel hacking before.  I _do_ know=

> how to build and install a kernel.  I'd like some hints on what logging=
,
> etc., I could add in order to determine where in the send ioctl
> processing the IO error is coming from.  From there, I hope to move to
> "why."  Ideally I'd be able to run gdb on this, but nothing I have read=

> online about kernel debugging with gdb sounds promising.
>=20
> I'd make an image, but the amount of data is enough to make this
> prohibitive.
>=20
I would look into ftrace (the Tracing submenu of the Kernel Hacking menu
in menuconfig and nconfig).  The other thing to look at at least
initially is KDB, but using that requires either a serial console or an
AT or PS/2 keyboard.  Using UML and GDB for debugging is possible, but
it can take a long time to set-up and is often slow (admitedly, KDB
isn't much faster).  If you do go the UML+GDB route, make sure to build
in fault-injection (the flaky DM module is particularly nice for this
type of thing), and I would suggest using something like Buildroot
(http://www.buildroot.net) to generate the root filesystem for it.


--------------ms030408060204050307060007
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
BgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTE0MDUyNjIyMTYwOVowIwYJKoZIhvcNAQkE
MRYEFGkSNn8ydfxGmqoO/7TojvqQwrwcMGwGCSqGSIb3DQEJDzFfMF0wCwYJYIZIAWUDBAEq
MAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcNAwIC
AUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwgZEGCSsGAQQBgjcQBDGBgzCBgDB5MRAwDgYD
VQQKEwdSb290IENBMR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMT
GUNBIENlcnQgU2lnbmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2Fj
ZXJ0Lm9yZwIDDwFEMIGTBgsqhkiG9w0BCRACCzGBg6CBgDB5MRAwDgYDVQQKEwdSb290IENB
MR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMTGUNBIENlcnQgU2ln
bmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2FjZXJ0Lm9yZwIDDwFE
MA0GCSqGSIb3DQEBAQUABIICAGsla0LEDURnWMjSZO/cLNHmNNmK8IiwBYusoT+cEGTB5Xo+
a0EKYtarhul3gkeHOQfhvDxtDkRaG8v7JijTkvpzWlrOk+3HMKBjb268A9B81k8389N1uP8H
0CPKFXSxjVPm3yVqm4tLSM59zgb58Z6ToU92RvGkh/OW7+GvGX/NH8kKDNYRKmY9SjdJMt8A
kpWjhQ2kKPTjDAJl9m/u1B8+5dhWFp0MbyARDqWDopljoH9r0pS+M5j6tY6wmASmnczBAHuU
tEthhY03GPetOgUIeku39aP6ouXP0OX2ubEosAU6gmQ2QPtEt06aOelXRoxhz9TfTetOOjcN
5JcFlZwL0QVIRtbE+OKimWfX1eP5Wi6ajye6z5az6feN7nWefZ/a8xLJjiXDEtjZlRTq3rSh
Av1YMhVR9Py009zazNyr6q0ZvSMwtRm7AyKCxrFzHm8YZT085dDrhEPT9FT/+EFhRTt7RX7a
8OVi1/+2sFhpGrz2g8uoc8XcNGcpSFgXwaapfp3OEEg/WQvdWjV5XAhF44dC0Xkqr9dhr5em
tNKa8voZhbrtF95BN+Y+a6K1YLkXXPzOWgPxigvzoGz5I05aGEz2Oz22zAz5N/WqCsJzCO9C
luU6fe2r5X+Nvt9U1oJ82VyOTqS3YRQZ913lNNJdUwiUYLo6Shr3fyVPjXXZAAAAAAAA
--------------ms030408060204050307060007--
