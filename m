Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f50.google.com ([209.85.192.50]:62007 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752658AbaEPVhH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 16 May 2014 17:37:07 -0400
Received: by mail-qg0-f50.google.com with SMTP id z60so5091840qgd.23
        for <linux-btrfs@vger.kernel.org>; Fri, 16 May 2014 14:37:06 -0700 (PDT)
Message-ID: <537684F9.6060909@gmail.com>
Date: Fri, 16 May 2014 17:36:57 -0400
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: Tomasz Chmielewski <tch@virtall.com>,
        Calvin Walton <calvin.walton@kepstin.ca>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: RAID-1 - suboptimal write performance?
References: <20140516164815.1c33149b@s9>	<1400263584.979.17.camel@sasami.ottawa.blindsidenetworks.com> <20140516214135.23fefc39@s9>
In-Reply-To: <20140516214135.23fefc39@s9>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms010607030604040002060102"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms010607030604040002060102
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 05/16/2014 04:41 PM, Tomasz Chmielewski wrote:
> On Fri, 16 May 2014 14:06:24 -0400
> Calvin Walton <calvin.walton@kepstin.ca> wrote:
>=20
>> No comment on the performance issue, other than to say that I've seen
>> similar on RAID-10 before, I think.
>>
>>> Also, what happens when the system crashes, and one drive has
>>> several hundred megabytes data more than the other one?
>>
>> This shouldn't be an issue as long as you occasionally run a scrub or
>> balance. The scrub should find it and fix the missing data, and a
>> balance would just rewrite it as proper RAID-1 as a matter of course.
>=20
> It's similar (writes to just one drive, while the other is idle) when
> removing (many) snapshots.=20
>=20
> Not sure if that's optimal behaviour.
>=20
I think, after having looked at some of the code, that I know what is
causing this (although my interpretation of the code may be completely
off target).  As far as I can make out, BTRFS only dispatches writes to
one device at a time, and the write() system call only returns when the
data is on both devices.  While dispatching to one device at a time is
optimal when both 'devices' are partitions on the same underlying disk
(and also if your optimization metric is the simplicity of the
underlying code), it degrades very fast to the worst case when using
multiple devices.  The underlying cause however, which the one device at
a time logic in BTRFS just makes much worse, is that the buffer for the
write() call is kept in memory until the write completes, and counts
against the per-process write-caching limit, and when the process fills
up it's write-cache, the next call it makes that would write to the disk
hangs until the write cache is less full.

The two options that I've found that work around this are:
1. Run 'sync' whenever the program stalls, or
2. Disable write-caching by adding the following to /etc/sysctl.conf
vm.dirty_bytes =3D 0
vm.dirty_background_bytes =3D 0

Option 1 is kind of tedious, but doesn't hurt performance all that much,
Option 2 will lower throughput, but will cause most of the stalls to
disappear.

Ideally, BTRFS should dispatch the first write for a block in a
round-robin fashion among available devices.  This won't fix the
underlying issue, but it will make it less of an issue for BTRFS.


--------------ms010607030604040002060102
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
BgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTE0MDUxNjIxMzY1N1owIwYJKoZIhvcNAQkE
MRYEFPtmrob8sjHbF9/nieSn2JXL7anFMGwGCSqGSIb3DQEJDzFfMF0wCwYJYIZIAWUDBAEq
MAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcNAwIC
AUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwgZEGCSsGAQQBgjcQBDGBgzCBgDB5MRAwDgYD
VQQKEwdSb290IENBMR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMT
GUNBIENlcnQgU2lnbmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2Fj
ZXJ0Lm9yZwIDDwFEMIGTBgsqhkiG9w0BCRACCzGBg6CBgDB5MRAwDgYDVQQKEwdSb290IENB
MR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMTGUNBIENlcnQgU2ln
bmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2FjZXJ0Lm9yZwIDDwFE
MA0GCSqGSIb3DQEBAQUABIICAMn14XDaLML3dSfQ8WaRWgIBpzTxpAZ3XurtzTspPhdXbKis
Lxb96joD5yA1mE2PH2R00/c/yyYgWXTYqPzlf/pYDpNbsbTMV1r0DdvZDdiO1A7i5efFlkoL
+2oLopNpdsmFL2PJuNrdvCJ8sVUAl9vZNTz69VwX2g80cUY8RSik+6CfL9uvEjEpVnuSkNzo
MEIUNz3BbZ+O1IyyGwc7EDM9xnx9zvySz4V+q2aUOhH6RRPO2ApHkoYU/YZ3/N0cdtTT0qeh
yYo3VoQfrk6Ef8j6CiWg2DCNAaetQPFlYvNsLPs41MbTx8v+thYUeKZiBsDt+ki8YFqM381D
zHkrmCH7JtO7hxTADD9VdC5LnJVRjtl3KDxIb/NVYf+784Mpu1pojkWClNRJIUFAG4yCax5P
FblGgTrHZbYeoM52WtyGpOqrnlLs4ZsK+ioxgDYyj33EBTeCGW+w7WfITuol66QtgQmh23jS
fiQQdjDzrWXfpQEo8mJy5PjePbj15YPgyYqnraree7+Z3gOYqkZWPKypuf1jN8dhMqpQ2yyx
4wJFis635llWCo4zPmvwWkQ0PKaY8iZM7PJWeuSiaiGWfGve8rNpUtPYPGfOenDBzp3A865d
Hv4BXq1RZn8yriNe9Y+ZxGAuezcu2gqBpABM1UnFrZL7gjlHakfdrM3Q7kEYAAAAAAAA
--------------ms010607030604040002060102--
