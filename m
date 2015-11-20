Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f182.google.com ([209.85.213.182]:38163 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542AbbKTNVq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Nov 2015 08:21:46 -0500
Received: by igbxm8 with SMTP id xm8so11577381igb.1
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Nov 2015 05:21:45 -0800 (PST)
Subject: Re: Kernel 3.19 and still "disk full" even though 'btrfs fi df"
 reports enough room left?
To: Dmitry Katsubo <dma_k@mail.ru>, linux-btrfs@vger.kernel.org
References: <564CC90F.3060703@gmail.com>
 <20151118190857.GY24333@carfax.org.uk> <564D1AE5.3000700@cn.fujitsu.com>
 <pan$61583$65d817c9$bfda2de6$465dca20@cox.net> <564F0671.8060402@mail.ru>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <564F1E5B.6040004@gmail.com>
Date: Fri, 20 Nov 2015 08:21:31 -0500
MIME-Version: 1.0
In-Reply-To: <564F0671.8060402@mail.ru>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms040307000807030709060904"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms040307000807030709060904
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-11-20 06:39, Dmitry Katsubo wrote:
> If I may add:
>
> Information for "System"
>
>    System, DUP: total=3D32.00MiB, used=3D16.00KiB
>
> is also quite technical, as for end user system =3D metadata (one can c=
all
> it "filesystem metadata" perhaps). For simplicity the numbers can be
> added to "Metadata" thus eliminating that line as well.
>
> For those power users who really want to see the tiny details like
> "System" and "GlobalReserve" I suggest to implement "-v" flag:
>
> # btrfs fi usage -v
Actually, I really like this idea, one of the questions I get asked when =

I show people BTRFS is the difference between System and Metadata, and=20
it's not always easy to explain to somebody who doesn't have a=20
background in filesystem development.  For some reason, people seem to=20
have trouble with the concept that the system tree is an index of the=20
other trees.  In general, it doesn't make sense for most non-debugging=20
cases to have it listed separate from the Metadata (they always have the =

same profile unless you're part way through a conversion, and it really=20
is metadata, just slightly higher level than the usual metadata chunks).
>
> On 2015-11-19 03:16, Duncan wrote:
>> Qu Wenruo posted on Thu, 19 Nov 2015 08:42:13 +0800 as excerpted:
>>
>>> Although the metadata output is showing that you still have about 512=
M
>>> available, but the 512M is Global Reserved space, or the unknown one.=

>>
>> Unknown here, as the userspace (btrfs-progs) is evidently too old to s=
how
>> it as global reserve, as it does in newer versions...
>>
>>> The output is really a little confusing. I'd like the change the outp=
ut
>>> by adding global reserved into metadata used space and make it a sub
>>> item for metadata.
>>
>> Thanks for the clarification.  It's most helpful, here. =3D:^)
>>
>> I've at times wondered if global reserve folded into one of the other
>> settings.  Apparently it comes from the metadata allocation, but while=

>> metadata is normally dup (single-device btrfs) or raid1 (multi-device)=
,
>> global reserve is single.
>>
>> It would have been nice if that sort of substructure was described a b=
it
>> better when global reserve first made its appearance, at least in the
>> patch descriptions and release announcement, if not then yet in btrfs =
fi
>> df output, first implementations being what they are.  But regardless,=

>> now at least it should be clear for list regulars who read this thread=

>> anyway, since the above reasonably clarifies things.
>>
>> As for btrfs fi df, making global reserve a metadata subentry there wo=
uld
>> be one way to deal with it, preserving the exposure of the additional
>> data provided by that line (here, the fact that global reserve is
>> actually being used, underlining the fact that the filesystem is sever=
ely
>> short on space).
>>
>> Another way of handling it would be to simply add the global reserve i=
nto
>> the metadata used figure before printing it, eliminating the separate
>> global reserve line, and changing the upthread posted metadata line fr=
om
>> 8.48 GiB of 9 GiB used, to 8.98 of 9 GiB used, which is effectively th=
e
>> case if the 512 MiB of global reserve indeed comes from the metadata
>> allocation.  This would more clearly show how full metadata actually i=
s
>> without the added complexity of an additional global reserve line, but=

>> would lose the fact that global reserve is actually in use, that the
>> broken out global reserve line exposes.
>>
>> I'd actually argue in favor of the latter, directly folding global
>> reserve allocation into metadata used, since it'd both be simpler, and=

>> more consistent if for instance btrfs fi usage didn't report separate
>> global reserve in the overall stats, but fail to report it in the per-=

>> device stats and in btrfs dev usage.
>>
>> Either way would make much clearer that metadata is actually running o=
ut
>> than the current report layout does, since "metadata used" would then
>> either explicitly or implicitly include the global reserve.
>>
>
>



--------------ms040307000807030709060904
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUxMTIwMTMyMTMxWjBPBgkq
hkiG9w0BCQQxQgRAgLa6aoWSMB9JV5T9LaDmIZO5inkOcSUWmHJzHH989eqElQsoS1rX4uhS
kujFURfmCLD8D57zSGH4jPPYoawk+TBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxEt+DCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DAN
BgkqhkiG9w0BAQEFAASCAgAVDdjpCaDW+I1jLLf8i8NlQXAxP5F1Bc72uUMPXNThGvPalO2q
8qyyNvJ+taVD5qmYfr+u216HRm0w7PcGwmK8IdJ1WaqGek0G8tPKihOmCyo/xtfrcjTHONFH
0ll+hdZD5XrYkSxgwcjCKw4hltJoFTWIWZoJsCQL7aJ+HQOqDH+19mbNGMkEjwIW2Pq6Oka5
6VCSm2fFXDXMMu8xu5qA7QhsVr5BjOW8K9emKeEOLHt3Yr+0fMeHumYHGY05heDmjSPIQdJ3
XQeo2nNd0LviDwIHzZjawrVItPyFKOBO3b3pRJ9p7Zwt1EedTYp1imEXHqG968eQjKsQV00q
rC3SD/VIWlzZPvgvKMZApdV+MHHlQCGi2TPG0SpmNUHF/K3E0H2OIYoKJoVzvA0FisZ7JqWu
jcGNfWXCxSXH8iH+ZfC5HRwKdS9Q+7yl9+KfIZlL0+eAOdiz1I2Cp0oxqFwVG/vGD3BSvZ4z
kfpgFHoCs80qTCNWFuAEO5r5FIX7IKQKINKrNV4Jc5mNcy5CQq7zMutxlsMLOPEoexIqwiZb
+k07ebAZToVIhpYemfaLAfkDeZm2dZ9qHa506QfE0XxbLKGoZVNgIQwr3ugo8NN/2R8Sinxz
J/CpMnTy+YcuiRoASYqQT3/IPbpjuhjvLsXrlnNu+lR+5MeyYk9++7oNkAAAAAAAAA==
--------------ms040307000807030709060904--
