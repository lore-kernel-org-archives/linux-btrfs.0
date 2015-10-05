Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f180.google.com ([209.85.213.180]:36106 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752534AbbJEQAI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 Oct 2015 12:00:08 -0400
Received: by igcrk20 with SMTP id rk20so64222545igc.1
        for <linux-btrfs@vger.kernel.org>; Mon, 05 Oct 2015 09:00:08 -0700 (PDT)
Subject: Re: BTRFS as image store for KVM?
To: Duncan <1i5t5.duncan@cox.net>,
        Lionel Bouton <lionel-subscription@bouton.name>,
        linux-btrfs@vger.kernel.org
References: <55F88ECC.1040604@menke.ac>
 <201510021421.09558.russell@coker.com.au> <560E737C.7050206@gmail.com>
 <201510031832.17802.russell@coker.com.au>
 <pan$e9b6$f764fa8a$deeffa51$be52ef68@cox.net> <56111598.2080403@bouton.name>
 <RPG31r00t34oj7R01PG5Us> <20151005070455.104464fe@ws>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <56129E77.7020806@gmail.com>
Date: Mon, 5 Oct 2015 11:59:51 -0400
MIME-Version: 1.0
In-Reply-To: <20151005070455.104464fe@ws>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms010807070906010304070802"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms010807070906010304070802
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-10-05 10:04, Duncan wrote:
> On Mon, 5 Oct 2015 13:16:03 +0200
> Lionel Bouton <lionel-subscription@bouton.name> wrote:
>
>> To better illustrate my point.
>>
>> According to Phoronix tests, BTRFS RAID-1 is even faster than md RAID1=

>> most of the time.
>>
>> http://www.phoronix.com/scan.php?page=3Darticle&item=3Dbtrfs_raid_mdad=
m&num=3D1
>>
>> The only case where md RAID1 was noticeably faster is sequential reads=

>> with FIO libaio.
>>
>> So if you base your analysis on Phoronix tests
>
[...snip...]
>
> Hmm... I think I've begun to see the kernel folks point about people
> quoting Phoronix in support of their points, when it's really not
> apropos at all.  Yes, I do still consider Phoronix reports in context
> to contain useful information, at some level.  However, one really must=

> be aware of what was actually tested in ordered to understand what the
> results actually mean, and unfortunately, it seems most people quoting
> it, including here, really can't properly do so in context, and thus
> end up using it in support of points that simply are not supported by
> the given evidence in the Phoronix articles people are attempting to
> use.
>
Even aside from the obvious past issues with Phoronix reports, people=20
forget that they are news organization (regardless of what they claim,=20
they _are_ a news organization), and as such their employees are not=20
paid to verify existing results, they're paid to make impactful articles =

that grab people's attention (I'd be willing to bet that this story=20
started in response to the people who pointed out correctly that XFS or=20
ext4 on top of mdraid beats the pants off of BTRFS performance wise, and =

(incorrectly) assumed that this meant that mdraid was better than BTRFS=20
raid).  This when combined with almost no evidence in many cases of=20
actual statistical analysis, really hurts their credibility (at least,=20
for me it does).

The other issue is that so many people tout benchmarks as the pinnacle=20
of testing, when they really aren't.  Benchmarks are by definition=20
synthetic workloads, and as such only the _really_ good ones (which=20
there aren't many of) give you more than a very basic idea what=20
performance differences you can expect with a given workload.  On top of =

that, people just accept results without trying to reproduce them=20
themselves (Kernel folks tend to be much better about this than many=20
other people though).

A truly sane person, looking to determine the best configuration for a=20
given workload, will:
1. Look at a wide variety of sources to determine what configurations he =

should even be testing.  (The author of the linked article obviously=20
didn't do this, or just didn't care, the defaults on btrfs are=20
unsuitable for a significant number of cases, including usage on top of=20
mdraid).
2. Using this information, run established benchmarks similar to his=20
use-case to further narrow down the test candidates.
3. Write his own benchmark to simulate to the greatest degree possible=20
the actual workload he expects to run, and then use that for testing the =

final candidates.
4. Gather some reasonable number of samples with the above mentioned=20
benchmark, and use _real_ statistical analysis to determine what he=20
should be using.

To put this in further perspective, most people just do step one, assume =

that other people know what they're talking about, and don't do any=20
further testing, and there are other people who just do step two, and=20
then claim their results are infallible.


--------------ms010807070906010304070802
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUxMDA1MTU1OTUxWjBPBgkq
hkiG9w0BCQQxQgRAtNMQIDsEcoWMGbbw/UPN0YqRNKDR6n6dvpt6eMLebruzmfte78pOWGlh
AXu9FMjGNJ1XVUX3DviWUp0bpXGSfjBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxEt+DCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DAN
BgkqhkiG9w0BAQEFAASCAgCAJ8MSF/JAQ2lfRV/b9vzckkuzgX6XDJUWxVqDv8U9O2b5O6Kl
ReYLNl9U3Oqb4k7Td+qG5UpHgytaT39x8TKK0TGlBb6xU6ouL116N/A++VKDABDRT0FH952y
k6IB8Dr83M4W3b9kiFYhLCNnV3O+ERfvBmKmLgrg3jyV14BE9ie0GK+7JLZt+d9NdZ+Qc4ko
UlBrzRSeBD5CdYpa1FSt2p5wQqSXF/hpb6AiNKmsQN9W2UZma1OstiyetWbetyFfjlpLNm56
e+85zrSK6Vu5mUqNpCZZ81iwH75aXPJ/XzHsRifjw+Kzyanw9/PMORCMeTeVtIkPV6Lv3W60
0tfdYStjHrkSxP9wIBV2AOU9rBEYxsKS+eUJ2J5BDIFl0lcnXQtVf582dJXiGdjMjCLoFQOM
UIgeD7ipp8LHM+yK+mtsiz4gT1v4IBb+4gFR7SnWdRLpVLWGSWCeVWPptZbm6CQq/G5TPfoA
LQ/iEsb5IKfsvjbbTXu84A7J4sr1xArGkzrLnIxpfnJQZ6DNP4MUUv1+xRiM+BM8Jw79Dw89
f9UPYhNJ4+jOlNXgvGaok4jO92aF+Umb3tdlI6BF5C47P/E9aaRUYz3lZq/2+QWS+8exESYH
egXZrb92eYjOL8MIQWmHTb9PLlm69rpzfudUhhm4pXLbGdH2N5xwfCbGlAAAAAAAAA==
--------------ms010807070906010304070802--
