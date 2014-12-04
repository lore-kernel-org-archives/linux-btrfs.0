Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:59292 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753837AbaLDOS3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 Dec 2014 09:18:29 -0500
Received: by mail-ie0-f174.google.com with SMTP id rl12so15320520iec.5
        for <linux-btrfs@vger.kernel.org>; Thu, 04 Dec 2014 06:18:28 -0800 (PST)
Message-ID: <54806D2F.6000809@gmail.com>
Date: Thu, 04 Dec 2014 09:18:23 -0500
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: Shriramana Sharma <samjnaa@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Possible to undo subvol delete?
References: <CAH-HCWW+C9VSV0vb5D1SfU+5md8=zfrZiAbK4cqFiGFW4bKR4w@mail.gmail.com> <20141130042306.GE8916@merlins.org> <547C6922.6030206@gmail.com> <CAH-HCWW4vUXzM6S1fCzwxdPiWHBZaf5ZNZexjRmND2WkzNK-qg@mail.gmail.com> <20141201184621.5dd7fcd9@natsu> <CAH-HCWV7mAz0cqO9r910aNa+wzufauvc_nOOpoB9ogDPdf7RsA@mail.gmail.com> <20141202031403.GZ17395@hungrycats.org> <CAH-HCWWnxqExQOexPF3jY6F1=jJA35Se5RkVw87u52F6BSic2g@mail.gmail.com> <20141202125610.GS12140@twin.jikos.cz> <CAH-HCWUm1CiapmHjy66DRKHa6NRegEW03es1DkK1SWv0159ZMw@mail.gmail.com> <20141203185311.GX12140@twin.jikos.cz> <CAH-HCWUj-3PAPDPnQcSvBm7DidzfFfiOB+v-LTOi08uTMZQaWw@mail.gmail.com>
In-Reply-To: <CAH-HCWUj-3PAPDPnQcSvBm7DidzfFfiOB+v-LTOi08uTMZQaWw@mail.gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms070303080404060108080305"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms070303080404060108080305
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2014-12-04 09:06, Shriramana Sharma wrote:
> On Thu, Dec 4, 2014 at 12:23 AM, David Sterba <dsterba@suse.cz> wrote:
>> On Tue, Dec 02, 2014 at 08:45:10PM +0530, Shriramana Sharma wrote:
>>> On Tue, Dec 2, 2014 at 6:26 PM, David Sterba <dsterba@suse.cz> wrote:=

>>>>
>>>> Works for me without the root password on a Tumbleweed installation
>>>> (without apparmor/selinux).
>>>
>>> Are you then referring to a btrfs partition mounted with user_subvol_=
rm_allowed?
>>
>> The context was 'does creating a subvolume require root password'.
>
> Well I don't know about you, but I'm just running an openSUSE 13.2
> system updated to Tumbleweed here, and even if I just hit "btrfs"
> enter (no sudo, no btrfs commands) on my regular (non-root) prompt, I
> am getting:
>
> $ btrfs
> Absolute path to 'btrfs' is '/usr/sbin/btrfs', so running it may
> require superuser privileges (eg. root).
> $
>
> ... so what to say of btrfs subvol, whether followed by crea or del!
>
> On Kubuntu Trusty, doing the above at least gives me the help list of
> btrfs subcommands and only when I try to execute some actual *action*
> which requires privileges (like accessing some root-read-only file or
> such) do I get an error message for not using sudo. For some (wierd)
> reason SuSE (possibly thinking it's being helpful) is requiring me to
> use sudo and enter password for even just *running* the btrfs
> executable. If there were a way to disable this and/or get the Kubuntu
> behaviour it'd be great (but of course this is not a SuSE forum!).
>
> What seems weird to me here is that it says it *may* require root
> privileges but simply drops me back to the prompt -- it doesn't seem
> to check whether the executable *actually* requires root permission.
> Granted, if it's under /sbin or /ust/sbin, it probably does, but the
> wording is quite strange, and the behaviour stranger.
>
AFAIK, the behavior is something in whatever patched version of whatever =

shell SuSE uses by default (IIRC, it's bash, but I'm not 100% certain=20
about that).  I would go looking in /etc/profile and the other system=20
wide startup files for that shell to see if you could override the=20
behavior there.  It may also be something SELinux or file permissions=20
related though.


--------------ms070303080404060108080305
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIFuDCC
BbQwggOcoAMCAQICAw9gVDANBgkqhkiG9w0BAQ0FADB5MRAwDgYDVQQKEwdSb290IENBMR4w
HAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMTGUNBIENlcnQgU2lnbmlu
ZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2FjZXJ0Lm9yZzAeFw0xNDA4
MDgxMTMwNDRaFw0xNTAyMDQxMTMwNDRaMGMxGDAWBgNVBAMTD0NBY2VydCBXb1QgVXNlcjEj
MCEGCSqGSIb3DQEJARYUYWhmZXJyb2luN0BnbWFpbC5jb20xIjAgBgkqhkiG9w0BCQEWE2Fo
ZW1tZWxnQG9oaW9ndC5jb20wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDdmm8R
BM5D6fGiB6rpogPZbLYu6CkU6834rcJepfmxKnLarYUYM593/VGygfaaHAyuc8qLaRA3u1M0
Qp29flqmhv1VDTBZ+zFu6JgHjTDniBii1KOZRo0qV3jC5NvaS8KUM67+eQBjm29LhBWVi3+e
a8jLxmogFXV0NGej+GHIr5zA9qKz2WJOEoGh0EfqZ2MQTmozcGI43/oqIYhRj8fRMkWXLUAF
WsLzPQMpK19hD8fqwlxQWhBV8gsGRG54K5pyaQsjne7m89SF5M8JkNJPH39tHEvfv2Vhf7EM
Y4WGyhLAULSlym1AI1uUHR1FfJaj3AChaEJZli/AdajYsqc7AgMBAAGjggFZMIIBVTAMBgNV
HRMBAf8EAjAAMFYGCWCGSAGG+EIBDQRJFkdUbyBnZXQgeW91ciBvd24gY2VydGlmaWNhdGUg
Zm9yIEZSRUUgaGVhZCBvdmVyIHRvIGh0dHA6Ly93d3cuQ0FjZXJ0Lm9yZzAOBgNVHQ8BAf8E
BAMCA6gwQAYDVR0lBDkwNwYIKwYBBQUHAwQGCCsGAQUFBwMCBgorBgEEAYI3CgMEBgorBgEE
AYI3CgMDBglghkgBhvhCBAEwMgYIKwYBBQUHAQEEJjAkMCIGCCsGAQUFBzABhhZodHRwOi8v
b2NzcC5jYWNlcnQub3JnMDEGA1UdHwQqMCgwJqAkoCKGIGh0dHA6Ly9jcmwuY2FjZXJ0Lm9y
Zy9yZXZva2UuY3JsMDQGA1UdEQQtMCuBFGFoZmVycm9pbjdAZ21haWwuY29tgRNhaGVtbWVs
Z0BvaGlvZ3QuY29tMA0GCSqGSIb3DQEBDQUAA4ICAQCr4klxcZU/PDRBpUtlb+d6JXl2dfto
OUP/6g19dpx6Ekt2pV1eujpIj5whh5KlCSPUgtHZI7BcksLSczQbxNDvRu6LNKqGJGvcp99k
cWL1Z6BsgtvxWKkOmy1vB+2aPfDiQQiMCCLAqXwHiNDZhSkwmGsJ7KHMWgF/dRVDnsl6aOQZ
jAcBMpUZxzA/bv4nY2PylVdqJWp9N7x86TF9sda1zRZiyUwy83eFTDNzefYPtc4MLppcaD4g
Wt8U6T2ffQfCWVzDirhg4WmDH3MybDItjkSB2/+pgGOS4lgtEBMHzAGQqQ+5PojTHRyqu9Jc
O59oIGrTaOtKV9nDeDtzNaQZgygJItJi9GoAl68AmIHxpS1rZUNV6X8ydFrEweFdRTVWhUEL
70Cnx84YBojXv01LYBSZaq18K8cERPLaIrUD2go+2ffjdE9ejvYDhNBllY+ufvRizIjQA1uC
OdktVAN6auQob94kOOsWpoMSrzHHvOvVW/kbokmKzaLtcs9+nJoL+vPi2AyzbaoQASVZYOGW
pE3daA0F5FJfcPZKCwd5wdnmT3dU1IRUxa5vMmgjP20lkfP8tCPtvZv2mmI2Nw5SaXNY4gVu
WQrvkV2in+TnGqgEIwUrLVbx9G6PSYZZs07czhO+Q1iVuKdAwjL/AYK0Us9v50acIzbl5CWw
ZGj3wjGCA6EwggOdAgEBMIGAMHkxEDAOBgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6
Ly93d3cuY2FjZXJ0Lm9yZzEiMCAGA1UEAxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEh
MB8GCSqGSIb3DQEJARYSc3VwcG9ydEBjYWNlcnQub3JnAgMPYFQwCQYFKw4DAhoFAKCCAfUw
GAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTQxMjA0MTQxODIz
WjAjBgkqhkiG9w0BCQQxFgQUskegeWfyEoZaM1Eo/kx+B2VlY10wbAYJKoZIhvcNAQkPMV8w
XTALBglghkgBZQMEASowCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMA4GCCqGSIb3DQMCAgIA
gDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggqhkiG9w0DAgIBKDCBkQYJKwYBBAGCNxAE
MYGDMIGAMHkxEDAOBgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6Ly93d3cuY2FjZXJ0
Lm9yZzEiMCAGA1UEAxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEhMB8GCSqGSIb3DQEJ
ARYSc3VwcG9ydEBjYWNlcnQub3JnAgMPYFQwgZMGCyqGSIb3DQEJEAILMYGDoIGAMHkxEDAO
BgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6Ly93d3cuY2FjZXJ0Lm9yZzEiMCAGA1UE
AxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEhMB8GCSqGSIb3DQEJARYSc3VwcG9ydEBj
YWNlcnQub3JnAgMPYFQwDQYJKoZIhvcNAQEBBQAEggEAnplMl0bJX1/Jn02S6FnBXf4nN1L8
TnTAiC0ThboXBTgxrfNsrHrZjX7IYpSDHwWaaJWxgc9+njRDLi88MjnNVXAzt/8mKyz3Pwed
1dxPenqu/+ST8vfCBtgUBaZ/gbjFgAp+TXrAsk1Mj62fnAevB+dt6ThC2f3SDvyT4ZWI6whA
m4YW7dcHDYZOeyxx7TfHV7srDf9nkfsfhgh3H26SnD/6V+SlFk0vXWL8XiTH+UXvmEzmPo1w
X1rUfRJJpu251curTTsaiKruT8YWnStZLJPtzVkcijmHYm8yYgup6L160qkiUsN2tr0p5IP3
8x+1q0i/IuJ81EO+B/+/NXaDjwAAAAAAAA==
--------------ms070303080404060108080305--
