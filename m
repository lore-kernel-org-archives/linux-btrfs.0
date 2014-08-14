Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yh0-f50.google.com ([209.85.213.50]:36762 "EHLO
	mail-yh0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754493AbaHNPFs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Aug 2014 11:05:48 -0400
Received: by mail-yh0-f50.google.com with SMTP id v1so1116039yhn.37
        for <linux-btrfs@vger.kernel.org>; Thu, 14 Aug 2014 08:05:47 -0700 (PDT)
Message-ID: <53ECD046.709@gmail.com>
Date: Thu, 14 Aug 2014 11:05:42 -0400
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: "G. Richard Bellamy" <rbellamy@pteradigm.com>,
        Chris Murphy <lists@colorremedies.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Large files, nodatacow and fragmentation
References: <CADw2B2Neg6-iG4uwGoW6XPomY4+-1BkUTx-7zPrAZPS6R3pRYg@mail.gmail.com>	<20140812011401.568c16e6@natsu>	<AC90CAC7-A8F5-4C74-8295-4360A6A8FE45@colorremedies.com>	<CADw2B2NnWFY=rOvArTDtnw2jkRe-HqNCcqeB0r80et60euEy3g@mail.gmail.com>	<9EB33BE3-FAC0-4AE8-BB95-ABE68C578D47@colorremedies.com> <CADw2B2MGyDAvAxrZOML0kX_shdFD6QSyMV9XWxKfJAoZpLXsSQ@mail.gmail.com>
In-Reply-To: <CADw2B2MGyDAvAxrZOML0kX_shdFD6QSyMV9XWxKfJAoZpLXsSQ@mail.gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms040902050708000002030902"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms040902050708000002030902
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 2014-08-14 10:30, G. Richard Bellamy wrote:
> On Wed, Aug 13, 2014 at 9:23 PM, Chris Murphy <lists@colorremedies.com>=
 wrote:
>> lsattr /var/lib/libvirt/images/atlas.qcow2
>>
>> Is the xattr actually in place on that file?
>=20
> 2014-08-14 07:07:36
> $ filefrag /var/lib/libvirt/images/atlas.qcow2
> /var/lib/libvirt/images/atlas.qcow2: 46378 extents found
> 2014-08-14 07:08:34
> $ lsattr /var/lib/libvirt/images/atlas.qcow2
> ---------------C /var/lib/libvirt/images/atlas.qcow2
>=20
> So, yeah, the attribute is set.
>=20
>>
>> It will fragment somewhat but I can't say that I've seen this much fra=
gmentation with xattr C applied to qcow2. What's the workload? How was th=
e qcow2 created? I recommend -o preallocation=3Dmetadata,compat=3D1.1,laz=
y_refcounts=3Don when creating it. My workloads were rather simplistic: O=
S installs and reinstalls. What's the filesystem being used in the guest =
that's using the qcow2 as backing?
>=20
> When I created the file, I definitely preallocated the metadata, but
> did not set compat or lazy_refcounts. However, isn't that more a
> function of how qemu + KVM managed the image, rather than how btrfs?
> This is a p2v target, if that matters. Workload has been minimal since
> virtualizing because I have yet to get usable performance with this
> configuration. The filesystem in the guest is Win7 NTFS. I have seen
> massive thrashing of the underlying volume during VSS operations in
> the guest, if that signifies.
>=20
>>
>> It might be that your workload is best suited for a preallocated raw f=
ile that inherits +C, or even possibly an LV.
>=20
> I'm close to that decision. As I mentioned, I much prefer the btrfs
> subvolume story over lvm, so moving to raw is probably more desirable
> than that... however, then I run into my lack of understanding of the
> difference between qcow2 and raw with respect to recoverability, e.g.
> does raw have the same ACID characteristics as a qcow2 image, or is
> atomicity a completely separate concern from the format? The ability
> for the owning process to recover from corruption or inconsistency is
> a key factor in deciding whether or not to turn COW off in btrfs - if
> your overlying system is capable of such recovery, like a database
> engine or (presumably) virtualization layer, then COW isn't a
> necessary function from the underlying system.
>=20
> So, just since I started this reply, you can see the difference in
> fragmentation:
> 2014-08-14 07:25:04
> $ filefrag /var/lib/libvirt/images/atlas.qcow2
> /var/lib/libvirt/images/atlas.qcow2: 46461 extents found
>=20
> That's 17 minutes, an OS without interaction (I wasn't doing anything
> with it, but it may have been doing its own work like updates, etc.),
> and I see an fragmentation increase of 83 extents, and a raid10 volume
> that was beating itself up (I could hear the drives chattering away as
> they worked).
The fact that it is Windows using NTFS is probably part of the problem.
 Here's some things you can do to decrease it's background disk
utilization (these also improve performance on real hardware):
1. Disable system restore points.  These aren't really necessary if you
are running in a VM and can take snapshots from the host OS.
2. Disable the indexing service.  This does a lot of background disk IO,
and most people don't need the high speed search functionality.
3. Turn off Windows Features that you don't need.  This won't help disk
utilization much, but can greatly improve overall system performance.
4. Disable the paging file.  Windows does a lot of unnecessary
background paging, which can cause lots of unneeded disk IO.  Be careful
doing this however, as it may cause problems for memory hungry applicatio=
ns.
5. See if you can disable boot time services you don't need.  Bluetooth,
SmartCard, and Adaptive Screen Brightness are all things you probably
don't need in a VM environment.

Of these, 1, 2, and 4 will probably help the most.  The other thing is
that NTFS is a journaling file system, and putting a journaled file
system image on a COW backing store will always cause some degree of
thrashing, because the same few hundred MB of the disk get rewritten
over and over again, and the only way to work around that on BTRFS is to
make the file NOCOW, AND preallocate the entire file in one operation
(use the fallocate command from util-linux to do this).



--------------ms040902050708000002030902
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
GAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTQwODE0MTUwNTQy
WjAjBgkqhkiG9w0BCQQxFgQUkepFatPRCaVc2neevaQSTcZrK8wwbAYJKoZIhvcNAQkPMV8w
XTALBglghkgBZQMEASowCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMA4GCCqGSIb3DQMCAgIA
gDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggqhkiG9w0DAgIBKDCBkQYJKwYBBAGCNxAE
MYGDMIGAMHkxEDAOBgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6Ly93d3cuY2FjZXJ0
Lm9yZzEiMCAGA1UEAxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEhMB8GCSqGSIb3DQEJ
ARYSc3VwcG9ydEBjYWNlcnQub3JnAgMPYFQwgZMGCyqGSIb3DQEJEAILMYGDoIGAMHkxEDAO
BgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6Ly93d3cuY2FjZXJ0Lm9yZzEiMCAGA1UE
AxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEhMB8GCSqGSIb3DQEJARYSc3VwcG9ydEBj
YWNlcnQub3JnAgMPYFQwDQYJKoZIhvcNAQEBBQAEggEAwxxeu5/1b770o51x/bttcG6qsVRU
EMGYm1FuzxvPaVmKvVxwCcl/jj0NInnKGzG/llHf1I//04fR31Bke1w3yAnwTzq/w9Ouf+6p
in713A4q4xFz7qOvsr4eFgUosLgYIeaSo0GeM81aRcdtkZn+9Vrao03z19Z9seO0rW9Aq/TN
f+zIbcA9+OSvD8wBsgHUP2QF2rVbHCHOCRdVgvA7liGyZlZVKb036OpthB5PYV+PO7RkGI82
+pg0FyOZvkQ/8FgKWgWcEwsU1P8GOdSo8h9lU+dHC0TReSqp41wl5BpTSUtYKAldTufkv2hO
CPVUE7UpLmn+1AuexhX4vDfIcQAAAAAAAA==
--------------ms040902050708000002030902--
