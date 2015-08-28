Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f176.google.com ([209.85.223.176]:35021 "EHLO
	mail-io0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752594AbbH1RL4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 28 Aug 2015 13:11:56 -0400
Received: by ioed140 with SMTP id d140so12602183ioe.2
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Aug 2015 10:11:56 -0700 (PDT)
Subject: Re: Understanding BTRFS storage
To: Chris Murphy <lists@colorremedies.com>, Hugo Mills <hugo@carfax.org.uk>,
        George Duffield <forumscollective@gmail.com>,
        Roman Mamedov <rm@romanrm.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CAG__1a4T=d_O49CnOw+0gtKr56xtrmcjRcmujtUff_s_-oL0Jw@mail.gmail.com>
 <20150826165024.05af044f@natsu> <55DDAB1C.90406@gmail.com>
 <CAG__1a4x_bv2DURyT0ZW0p+udh43ifcn=bHjUKM4NF1Tk=cYDw@mail.gmail.com>
 <20150828093502.GO23769@carfax.org.uk>
 <CAJCQCtSx8nOtLL=_AeNRH0Vn2Fw0PQYTyfbOp-ehkEUCrr+3vg@mail.gmail.com>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <55E09640.7030103@gmail.com>
Date: Fri, 28 Aug 2015 13:11:28 -0400
MIME-Version: 1.0
In-Reply-To: <CAJCQCtSx8nOtLL=_AeNRH0Vn2Fw0PQYTyfbOp-ehkEUCrr+3vg@mail.gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms060509060804060301090307"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms060509060804060301090307
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-08-28 11:42, Chris Murphy wrote:
> On Fri, Aug 28, 2015 at 3:35 AM, Hugo Mills <hugo@carfax.org.uk> wrote:=

>> On Fri, Aug 28, 2015 at 10:50:12AM +0200, George Duffield wrote:
>>> Running a traditional raid5 array of that size is statistically
>>> guaranteed to fail in the event of a rebuild.
>>
>>     Except that if it were, you wouldn't see anyone running RAID-5
>> arrays of that size and (considerably) larger. And successfully
>> replacing devices in them.
>>
>>     As I understand it, the calculations that lead to the conclusion
>> you quote are based on the assumption that the bit error rate (BER) of=

>> the drive is applied on all reads -- this is not the case. The BER is
>> the error rate of the platter after the device has been left unread
>> (and powered off) for some long period of time. (I've seen 5 years
>> been quoted for that).
>
> I think the confusion comes from the Unrecovered Read Error (URE) or
> "Non-recoverable read errors per bits read" in the drive spec sheet.
> e.g. on a WDC Red this is written as "<1 in 10^14" but this gets
> (wrongly) reinterpreted into an *expected* URE once every 12.5TB (not
> TiB) read, which is of course complete utter bullshit. But it gets
> repeated all the time.
>
> It's as if symbols have no meaning, and < is some sort of arrow, or
> someone got bored and just didn't want to use a space. That symbol
> makes the URE value a maximum for what is ostensibly a scientific
> sample of drives. We have no idea what the minimum is, we don't even
> know the mean, and it's not in the manufacturer's best interest to do
> that. The mean between consumer SATA and enterprise SAS may not be all
> that different, while the maximum is two orders magnitude better for
> enterprise SAS so it makes sense to try to upsell us with that
> promise.
>
That probably is the case, the truly sad thing is that there are so many =

engineers (read as 'people who are supposed to actually pay attention to =

the specs') who do this on a regular basis.



--------------ms060509060804060301090307
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgMFADCABgkqhkiG9w0BBwEAAKCC
Brgwgga0MIIEnKADAgECAgMQblUwDQYJKoZIhvcNAQENBQAweTEQMA4GA1UEChMHUm9vdCBD
QTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNp
Z25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcwHhcN
MTUwMzI1MTkzNDM4WhcNMTUwOTIxMTkzNDM4WjBjMRgwFgYDVQQDEw9DQWNlcnQgV29UIFVz
ZXIxIzAhBgkqhkiG9w0BCQEWFGFoZmVycm9pbjdAZ21haWwuY29tMSIwIAYJKoZIhvcNAQkB
FhNhaGVtbWVsZ0BvaGlvZ3QuY29tMIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEA
nQ/81tq0QBQi5w316VsVNfjg6kVVIMx760TuwA1MUaNQgQ3NyUl+UyFtjhpkNwwChjgAqfGd
LIMTHAdObcwGfzO5uI2o1a8MHVQna8FRsU3QGouysIOGQlX8jFYXMKPEdnlt0GoQcd+BtESr
pivbGWUEkPs1CwM6WOrs+09bAJP3qzKIr0VxervFrzrC5Dg9Rf18r9WXHElBuWHg4GYHNJ2V
Ab8iKc10h44FnqxZK8RDN8ts/xX93i9bIBmHnFfyNRfiOUtNVeynJbf6kVtdHP+CRBkXCNRZ
qyQT7gbTGD24P92PS2UTmDfplSBcWcTn65o3xWfesbf02jF6PL3BCrVnDRI4RgYxG3zFBJuG
qvMoEODLhHKSXPAyQhwZINigZNdw5G1NqjXqUw+lIqdQvoPijK9J3eijiakh9u2bjWOMaleI
SMRR6XsdM2O5qun1dqOrCgRkM0XSNtBQ2JjY7CycIx+qifJWsRaYWZz0aQU4ZrtAI7gVhO9h
pyNaAGjvm7PdjEBiXq57e4QcgpwzvNlv8pG1c/hnt0msfDWNJtl3b6elhQ2Pz4w/QnWifZ8E
BrFEmjeeJa2dqjE3giPVWrsH+lOvQQONsYJOuVb8b0zao4vrWeGmW2q2e3pdv0Axzm/60cJQ
haZUv8+JdX9ZzqxOm5w5eUQSclt84u+D+hsCAwEAAaOCAVkwggFVMAwGA1UdEwEB/wQCMAAw
VgYJYIZIAYb4QgENBEkWR1RvIGdldCB5b3VyIG93biBjZXJ0aWZpY2F0ZSBmb3IgRlJFRSBo
ZWFkIG92ZXIgdG8gaHR0cDovL3d3dy5DQWNlcnQub3JnMA4GA1UdDwEB/wQEAwIDqDBABgNV
HSUEOTA3BggrBgEFBQcDBAYIKwYBBQUHAwIGCisGAQQBgjcKAwQGCisGAQQBgjcKAwMGCWCG
SAGG+EIEATAyBggrBgEFBQcBAQQmMCQwIgYIKwYBBQUHMAGGFmh0dHA6Ly9vY3NwLmNhY2Vy
dC5vcmcwMQYDVR0fBCowKDAmoCSgIoYgaHR0cDovL2NybC5jYWNlcnQub3JnL3Jldm9rZS5j
cmwwNAYDVR0RBC0wK4EUYWhmZXJyb2luN0BnbWFpbC5jb22BE2FoZW1tZWxnQG9oaW9ndC5j
b20wDQYJKoZIhvcNAQENBQADggIBABr5e8W+NiTER+Q/7wiA2LxWN3UdhT3eZJjqqSlP370P
KL5iWqeTfxQ67Ai/mHbJcT2PgAJ+/D2Ji+aRR03UWnU/vtOwzyDLUMstqnfl0Zs+sz/CJe7x
nBA5jlpjC2DKuMVfbPze7eySaen7XSGFHKE1QoVIIpQ2kVjC4nbbJQnUbAVX1Iz29WxeVGt9
XYigz3tDPf3tglN+q23E7YjQl4abTIoM7i98yV1H9gfY8lFfKZ6jREB9+n6ie2EwS3Kat2mG
tl2wBx4MfRnoSQSKsLKQ5oTwhWf0JqlFwpLfl374p0Njcykej9/jnWG8Ks1V/AXTHqI4eyIP
Mf5yMZkPv7n7LS9WWKdG4Nd38iv4T2EiAaWsmgu+r81qL5CJu9AyA0SBS4ttKf6k3e63w2Mv
N9R45vpQ3QhAhfWyFxFhZN95APe3YECDG3+XIRJpRYPEtHuIsOyzI70ajF93gg/BidvqKsmV
MM2ccktDMfqwZXea6zey7F8Geu9R7BqjXmG2HlNuXu7e/xnHOgXf5D3wPmnRLlBhXL1Ch97a
w2KjaupjpAHfFjv5kGnZXN87UvvlwzIZiKXwa3vTDwK+rrKn/sHPkfDZPSiyt/ZBIK6lX83P
34H/CzGg+Kx57rHYOIHGumIvpDa5vfWp8O0sGgawb1C2Aae4sTUVIWmIjVuGI062MYIE0TCC
BM0CAQEwgYAweTEQMA4GA1UEChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNl
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxBuVTANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUwODI4MTcxMTI4WjBPBgkq
hkiG9w0BCQQxQgRAT7tC/yT2Zdcre0ZjYQY3Ur16yFYF2hSpBlVACFFuyjC4zmvZTYYVy3FP
R6CneMnxxr6xwfJCuQ1JoBUPU5uUBjBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxBuVTCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxBuVTAN
BgkqhkiG9w0BAQEFAASCAgBKQM+hXcZbBMaUbp3pccIIzOFn87Vtt1DEoqOrIEgXiDvH+Oae
r2jJ65/fGxNDh6p75PxH3qtFcoKmiCfB1fpUfx2TrcFPh6Efd7qxGe3njeQRmmgvymXH9+5y
k+i2NOx2AorFwTMrAkTNA352D2sbSiv30RdC9C5O3I5yXmS5GBhQRjitrB6yzkOX3b3kZDMU
jzoE8U1L4asVbPQ/Fx5/Bq65FY9bTeRFkxllSxMv0VWpaC2esrAmJOnODI+NvfYppdBlBXX1
4F134P/SdT/AKwNN5TW3v3ZvV2gTLvlqzz8rtUn4dpAkf9X3GLS8ixhM3sY3GepIVoqfpYSD
q8+mCp+jLCq7/AxH8NY7Xo75u+SY/wRtwhHkDJiuz2/S/8Uv6ZyS4/ODuCE0sTt1yXHqdzLg
cQtRtKrhL1mxILLXq13ao1pgZvawI3S2bJ3UhvA2rCLOAuURX7Qtkfqnfy/oyzSifLjC36G1
fgsv7giTfZnVnEMEb4D37e/OriLr4HrCHNl69egCFhQLPHgC722JA2k7GQvHCnopu80N+XBq
1TaY5p4s5lfRPGK83Hh3k/L9b9VV2PqA7KVRrAjMj8y+1nBi1XtDnkS7AJWiRQJF8ypOyX8f
HvBvmU8RJFkBWtJPj9sFv6PiYFb/8tZ7/TvE7SyHWqPYW8HpEx3tUfD4EwAAAAAAAA==
--------------ms060509060804060301090307--
