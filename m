Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f180.google.com ([209.85.220.180]:34595 "EHLO
	mail-qk0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029AbbJBMHw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 2 Oct 2015 08:07:52 -0400
Received: by qkbi190 with SMTP id i190so21255220qkb.1
        for <linux-btrfs@vger.kernel.org>; Fri, 02 Oct 2015 05:07:51 -0700 (PDT)
Subject: Re: BTRFS as image store for KVM?
To: Russell Coker <russell@coker.com.au>
References: <55F88ECC.1040604@menke.ac>
 <CAGqmi75-Wc-YOwCJhRD1ahgKhEM5tPPBVjCYmvgjMZNhEnk77w@mail.gmail.com>
 <56055839.9000904@gmail.com> <201510021421.09558.russell@coker.com.au>
Cc: Timofey Titovets <nefelim4ag@gmail.com>, Jim Salter <jim@jrs-s.net>,
        Rich Freeman <r-btrfs@thefreemanclan.net>, Gert Menke <gert@menke.ac>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <560E737C.7050206@gmail.com>
Date: Fri, 2 Oct 2015 08:07:24 -0400
MIME-Version: 1.0
In-Reply-To: <201510021421.09558.russell@coker.com.au>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms090307050403070307040305"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms090307050403070307040305
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-10-02 00:21, Russell Coker wrote:
> On Sat, 26 Sep 2015 12:20:41 AM Austin S Hemmelgarn wrote:
>>> FYI:
>>> Linux pagecache use LRU cache algo, and in general case it's working =
good
>>> enough
>>
>> I'd argue that 'general usage' should be better defined in this
>> statement.  Obviously, ZFS's ARC implementation provides better
>> performance in a significant number of common use cases for Linux,
>> otherwise people wouldn't be using it to the degree they are.
>
> No-one gets a free choice about this.  I have a number of servers runni=
ng ZFS
> because I needed the data consistency features and BTRFS wasn't ready. =
 There
> is no choice of LRU vs ARC once you've made the BTRFS vs ZFS decision.
I'm not saying there is a free choice in this, although that is largely=20
because the page-cache wasn't written in a way on Linux that allows for=20
easy development of alternative caching algorithms for it. When I said=20
'using it', I meant using ZFS, not just ARC. I would love to be able=20
some day to be able to use ARC or even just SLRU (ARC with out the=20
adaptive internal sizing bits) on Linux, as both provide better=20
performance for COW workloads than plain LRU (although, somewhat=20
paradoxically, for some COW workloads, an MRU algorithm is even better).
>
> ARC presumably worked better than the other Solaris caching options.  I=
t was
> ported to Linux with zfsonlinux because that was the easy way of doing =
it.
Actually, I think part of that was also the fact that ZFS is a COW=20
filesystem, and classical LRU caching (like the regular Linux pagecache) =

often does horribly with COW workloads (and I'm relatively convinced=20
that this is a significant part of why BTRFS has such horrible=20
performance compared to ZFS).
>
> Some people here have reported that ARC worked well for them on Linux. =
 My
> experience was that the zfsonlinux kernel modules wouldn't respect the =
module
> load options to reduce the size of the ARC and the default size would c=
ause
> smaller servers to have kernel panics due to lack of RAM.  My solution =
to that
> problem was to get more RAM for all ZFS servers as buying RAM is cheape=
r for
> my clients than paying me to diagnose the problems with ZFS.
The whole ARC sizing issue with zfsonlinux is largely orthogonal to=20
whether or not ARC is better for a given workload, and I think that=20
there is actually some lower limit they force based on the amount of RAM =

at boot.


--------------ms090307050403070307040305
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUxMDAyMTIwNzI0WjBPBgkq
hkiG9w0BCQQxQgRA0vzPjeDO4MRB6+3Lh89jhC4Lg20tMCGgkPLjkupo52yk40aA/5Nlcr4o
KCNbkxMnVKtjPgAnv9xdl2wpkOmlszBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxEt+DCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DAN
BgkqhkiG9w0BAQEFAASCAgCUzwoQx5R46wGHudSkChSNRVjA7sFe28qJhwrbujA5Mj0B9HeW
xrDsBRL+RaiXjRkoV71CqCS0GHEF2Uzg2nfx68c8Z6um38wtO345Sjddj04ZkcRJRVNuG5a2
noW7+xJClGHFgGYxx3M6JUyxVZC0XhWTmQ1CWlzTrWMd8tRLPX+C3Ib0ME5eDY9JLgq8XjfD
JSB1NYhji1Ub7v3CJuPeRgG26E3RducsEkmq6zV4/zRrwfMJx7OonIy+cpenTPEVvddcdeY9
gYSAkjr5Cf46I9JYuJcq8T9YBvlUiAkoNT8+D4slLlApYM6yat9XZ37G0kij55R7SRecL4hu
2bnz3F8JbEqyt/xsjd8D8j0pWXl8+DJs37wslJYYw5pzAMoM8EYPW/ULTE0rfO9FUPvrGMTL
c7RGe6l6wtL0W1fF4ERXh9nLz+T4FiXy38I5s3SrO4VqWepccoky4GOEjWtKQs0TInjFWuVf
j+22vyt+vAIt3+2KYi+Z+VJIzihCElfgDXQFxerNJV6UPVaLtTMqey3onoRrRAIvMTR51YCp
acqxrDOGUYjfdb7cxRGc4qzaS117LYEbjsMpRSNX0t6BRyBCrbRFwePySbqOjueMz/zxm/MW
94WydZND6/DunVbfZW+x/jF21QHqvyBqQPXBmLYlx/W1ovJRDKBhrydMmgAAAAAAAA==
--------------ms090307050403070307040305--
