Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f182.google.com ([209.85.213.182]:34255 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752714AbbAERCo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 Jan 2015 12:02:44 -0500
Received: by mail-ig0-f182.google.com with SMTP id hn15so2784005igb.3
        for <linux-btrfs@vger.kernel.org>; Mon, 05 Jan 2015 09:02:43 -0800 (PST)
Message-ID: <54AAC3AD.3010802@gmail.com>
Date: Mon, 05 Jan 2015 12:02:37 -0500
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: kreijack@inwind.it, Lennart Poettering <lennart@poettering.net>,
        Harald Hoyer <harald@redhat.com>
CC: linux-btrfs@vger.kernel.org, Kay Sievers <kay@vrfy.org>,
        Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.cz>
Subject: Re: Extend BTRFS_IOC_DEVICES_READY for degraded RAID
References: <54AA5D86.1000503@redhat.com> <20150105113147.GA18350@gardel-login> <54AABD92.9050904@inwind.it>
In-Reply-To: <54AABD92.9050904@inwind.it>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms090402010005000001060509"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms090402010005000001060509
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-01-05 11:36, Goffredo Baroncelli wrote:
> On 2015-01-05 12:31, Lennart Poettering wrote:
>> On Mon, 05.01.15 10:46, Harald Hoyer (harald@redhat.com) wrote:
>>
>>> We have BTRFS_IOC_DEVICES_READY to report, if all devices are present=
, so that
>>> a udev rule can report ID_BTRFS_READY and SYSTEMD_READY.
>>>
>>> I think we need a third state here for a degraded RAID, which can be =
mounted,
>>> but should only after a certain timeout/kernel command line params.
>>>
>>> We also have to rethink how to handle the udev DB update for the chan=
ge of the
>>> state. incomplete -> degraded -> complete
>>
>> I am not convinced that automatically booting degraded arrays would be=

>> a good idea. Instead, requiring one manual step before booting a
>> degraded array sounds OK to me.
>
> I think that a good use case is when the root filesystem is a raid one.=

>
> However I don't think that the current architecture is enough flexible =
to
> perform this job:
> - mounting a raid filesystem in degraded mode is good for some setup
> but it is not the right solution for all: a configure
> parameter to allow one behavior or the other is needed:
> - the degraded mode should be allowed only if not all the devices are
> discovered AND a timeout is expired. This timeout is another variable w=
hich
> (IMHO) should be configurable;
These first 2 points can be easily handled with some simple logic in=20
userspace without needing a mount helper.
> - there are different degrees of degraded mode: if the raid is a RAID6,=

> losing a device would be acceptable; loosing two devices may be
> unacceptable. Again there is no a simple answer; it is needed a
> configurable policy;
This can be solved by providing 2 new return values for the=20
BBTRFS_IOC_DEVICES_READY ioctl (instead of just one), one for for arrays =

that are in such a state that losing another disk will almost certainly=20
cause data loss (ie, a RAID6 with two missing devices, or a BTRFS=20
raid1/10 with one missing device), and one for an array (theoretically)=20
won't lose any data if one more device drops out (ie, a RAID6 (or=20
something with higher parity) with one missing disk), and then provide a =

module parameter to allow forcing the kernel to report one or the other.
> - pay attention that the current architecture has some flaws: if a devi=
ce
> disappear during the device discovery, ID_BTRFS_READY returns OK
> even if a device is missing.
Point 4 would require for some kind of continuous scanning/notification=20
(and therefore add more bulk, the lack of which is in my opinion one of=20
the biggest advantages of BTRFS over ZFS), and even then there will=20
always be the possibility that a device drops out between you calling=20
the ioctl and trying to mount the filesystem.


--------------ms090402010005000001060509
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
GAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUwMTA1MTcwMjM3
WjAjBgkqhkiG9w0BCQQxFgQUNuO0G3WOwdy9M7/zo7j34xEKbDgwbAYJKoZIhvcNAQkPMV8w
XTALBglghkgBZQMEASowCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMA4GCCqGSIb3DQMCAgIA
gDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggqhkiG9w0DAgIBKDCBkQYJKwYBBAGCNxAE
MYGDMIGAMHkxEDAOBgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6Ly93d3cuY2FjZXJ0
Lm9yZzEiMCAGA1UEAxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEhMB8GCSqGSIb3DQEJ
ARYSc3VwcG9ydEBjYWNlcnQub3JnAgMPYFQwgZMGCyqGSIb3DQEJEAILMYGDoIGAMHkxEDAO
BgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6Ly93d3cuY2FjZXJ0Lm9yZzEiMCAGA1UE
AxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEhMB8GCSqGSIb3DQEJARYSc3VwcG9ydEBj
YWNlcnQub3JnAgMPYFQwDQYJKoZIhvcNAQEBBQAEggEAxipLQ9rFDxxyEyLa76umiywnNQjw
1OZXWRyNMqiFZ/347U6P7a/zi2RBhEe9AWWtkZIXFOdegEp1vklA35y9pa4lkXw14aKW2dc3
ooSPrfnjPMKCBxgaE3CSQMyvlWJDkS5xkX9UTpBlM8fOv+ZsUpgEYTSfg2kj+QRk6BvZ7eW2
QYXjMCkwDocK1E8oQwjvt+vUTguXX5W0OHHwE3Nxs/81IYR5Ci6ErUunxgL2NI81KTM8go5S
CsMiGo14FQn/8qpsfDRZicnajKEuluPOHRKCZPIOrS68gFseVtWP3ePxTX5+pk2+CaReyNiI
lF5Od6tSGCcqkSCk8FlRqv9nIwAAAAAAAA==
--------------ms090402010005000001060509--
