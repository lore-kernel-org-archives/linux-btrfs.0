Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f179.google.com ([209.85.213.179]:48838 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753103AbaJMLiH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 Oct 2014 07:38:07 -0400
Received: by mail-ig0-f179.google.com with SMTP id h18so10086003igc.6
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Oct 2014 04:38:06 -0700 (PDT)
Message-ID: <543BB996.6040606@gmail.com>
Date: Mon, 13 Oct 2014 07:37:58 -0400
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: Martin Steigerwald <Martin@lichtvoll.de>
CC: Chris Murphy <lists@colorremedies.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: What is the vision for btrfs fs repair?
References: <54358C77.2070808@redhat.com> <5437BAB2.1040605@shiftmail.org> <93B9D2BD-1F0F-4C94-899F-16A3A2A0D57E@colorremedies.com> <2313804.P0rE2GFdbV@merkaba>
In-Reply-To: <2313804.P0rE2GFdbV@merkaba>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms030206010000030101070000"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms030206010000030101070000
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2014-10-12 06:14, Martin Steigerwald wrote:
> Am Freitag, 10. Oktober 2014, 10:37:44 schrieb Chris Murphy:
>> On Oct 10, 2014, at 6:53 AM, Bob Marley <bobmarley@shiftmail.org> wrot=
e:
>>> On 10/10/2014 03:58, Chris Murphy wrote:
>>>>> * mount -o recovery
>>>>>
>>>>> 	"Enable autorecovery attempts if a bad tree root is found at mount=

>>>>> 	time."
>>>>
>>>> I'm confused why it's not the default yet. Maybe it's continuing to
>>>> evolve at a pace that suggests something could sneak in that makes
>>>> things worse? It is almost an oxymoron in that I'm manually enabling=
 an
>>>> autorecovery
>>>>
>>>> If true, maybe the closest indication we'd get of btrfs stablity is =
the
>>>> default enabling of autorecovery.>
>>> No way!
>>> I wouldn't want a default like that.
>>>
>>> If you think at distributed transactions: suppose a sync was issued o=
n
>>> both sides of a distributed transaction, then power was lost on one s=
ide,
>>> than btrfs had corruption. When I remount it, definitely the worst th=
ing
>>> that can happen is that it auto-rolls-back to a previous known-good
>>> state.
>> For a general purpose file system, losing 30 seconds (or less) of
>> questionably committed data, likely corrupt, is a file system that won=
't
>> mount without user intervention, which requires a secret decoder ring =
to
>> get it to mount at all. And may require the use of specialized tools t=
o
>> retrieve that data in any case.
>>
>> The fail safe behavior is to treat the known good tree root as the def=
ault
>> tree root, and bypass the bad tree root if it cannot be repaired, so t=
hat
>> the volume can be mounted with default mount options (i.e. the ones in=

>> fstab). Otherwise it's a filesystem that isn't well suited for general=

>> purpose use as rootfs let alone for boot.
>
> To understand this a bit better:
>
> What can be the reasons a recent tree gets corrupted?
>
Well, so far I have had the following cause corrupted trees:
1. Kernel panic during resume from ACPI S1 (suspend to RAM), which just=20
happened to be in the middle of a tree commit.
2. Generic power loss during a tree commit.
3. A device not properly honoring write-barriers (the operations=20
immediately adjacent to the write barrier weren't being ordered=20
correctly all the time).

Based on what I know about BTRFS, the following could also cause problems=
:
1. A single-event-upset somewhere in the write path.
2. The kernel issuing a write to the wrong device (I haven't had this=20
happen to me, but know people who have).

In general, any of these will cause problems for pretty much any=20
filesystem, not just BTRFS.
> I always thought with a controller and device and driver combination th=
at
> honors fsync with BTRFS it would either be the new state of the last kn=
own
> good state *anyway*. So where does the need to rollback arise from?
>
I think that in this case the term rollback is a bit ambiguous, here it=20
means from the point of view of userspace, which sees the FS as having=20
'rolled-back' from the most recent state to the last known good state.
> That said all journalling filesystems have some sort of rollback as far=
 as I
> understand: If the last journal entry is incomplete they discard it on =
journal
> replay. So even there you use the last seconds of write activity.
>
> But in case fsync() returns the data needs to be safe on disk. I always=

> thought BTRFS honors this under *any* circumstance. If some proposed
> autorollback breaks this guarentee, I think something is broke elsewher=
e.
>
> And fsync is an fsync is an fsync. Its semantics are clear as crystal. =
There
> is nothing, absolutely nothing to discuss about it.
>
> An fsync completes if the device itself reported "Yeah, I have the data=
 on
> disk, all safe and cool to go". Anything else is a bug IMO.
>
Or a hardware issue, most filesystems need disks to properly honor write =

barriers to provide guaranteed semantics on an fsync, and many consumer=20
disk drives still don't honor them consistently.


--------------ms030206010000030101070000
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
GAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTQxMDEzMTEzNzU4
WjAjBgkqhkiG9w0BCQQxFgQU0dnaYZn5L+6Rc/B+YrklzVgopbswbAYJKoZIhvcNAQkPMV8w
XTALBglghkgBZQMEASowCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMA4GCCqGSIb3DQMCAgIA
gDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggqhkiG9w0DAgIBKDCBkQYJKwYBBAGCNxAE
MYGDMIGAMHkxEDAOBgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6Ly93d3cuY2FjZXJ0
Lm9yZzEiMCAGA1UEAxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEhMB8GCSqGSIb3DQEJ
ARYSc3VwcG9ydEBjYWNlcnQub3JnAgMPYFQwgZMGCyqGSIb3DQEJEAILMYGDoIGAMHkxEDAO
BgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6Ly93d3cuY2FjZXJ0Lm9yZzEiMCAGA1UE
AxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEhMB8GCSqGSIb3DQEJARYSc3VwcG9ydEBj
YWNlcnQub3JnAgMPYFQwDQYJKoZIhvcNAQEBBQAEggEAo5vfw7W59YfhP0jqadakERw9Ihe7
Fih97Dxxsp/r5o9FP+GcBVtKJenkHDgFs+dgscuhbMdyvgkh00wxEg5noPnPlQ72sjTwNB8W
4zdDxUsvFryPQHUxyBihmSntPIYGfkoB1xKqei6Xh+nP/gtBRHVIX738dsUnInSauNHQKEoP
KEo7CyWQKn2xEwqOaKpXEo0fE54ZwAGvOE3VTKxEXermswhf7s9wsYLKuE7+bFSuatl98+Wn
pEGXY56choM2RHHGPhYMxN1h0GQBFotFmEuLA2eIdZmAf2sRZoxOrxPrc4y41SlZpke4O/LQ
ZwBLKmXUKzkW6MpWQsVymf/MwgAAAAAAAA==
--------------ms030206010000030101070000--
