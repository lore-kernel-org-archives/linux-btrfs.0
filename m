Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f53.google.com ([209.85.218.53]:55475 "EHLO
	mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144AbaJIL3f (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Oct 2014 07:29:35 -0400
Received: by mail-oi0-f53.google.com with SMTP id v63so2204060oia.40
        for <linux-btrfs@vger.kernel.org>; Thu, 09 Oct 2014 04:29:34 -0700 (PDT)
Message-ID: <54367193.6000202@gmail.com>
Date: Thu, 09 Oct 2014 07:29:23 -0400
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: Eric Sandeen <sandeen@redhat.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: What is the vision for btrfs fs repair?
References: <54358C77.2070808@redhat.com>
In-Reply-To: <54358C77.2070808@redhat.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms040808020308050002030301"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms040808020308050002030301
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2014-10-08 15:11, Eric Sandeen wrote:
> I was looking at Marc's post:
>
> http://marc.merlins.org/perso/btrfs/post_2014-03-19_Btrfs-Tips_-Btrfs-S=
crub-and-Btrfs-Filesystem-Repair.html
>
> and it feels like there isn't exactly a cohesive, overarching vision fo=
r
> repair of a corrupted btrfs filesystem.
>
> In other words - I'm an admin cruising along, when the kernel throws so=
me
> fs corruption error, or for whatever reason btrfs fails to mount.
> What should I do?
>
> Marc lays out several steps, but to me this highlights that there seem =
to
> be a lot of disjoint mechanisms out there to deal with these problems;
> mostly from Marc's blog, with some bits of my own:
>
> * btrfs scrub
> 	"Errors are corrected along if possible" (what *is* possible?)
> * mount -o recovery
> 	"Enable autorecovery attempts if a bad tree root is found at mount tim=
e."
> * mount -o degraded
> 	"Allow mounts to continue with missing devices."
> 	(This isn't really a way to recover from corruption, right?)
> * btrfs-zero-log
> 	"remove the log tree if log tree is corrupt"
> * btrfs rescue
> 	"Recover a damaged btrfs filesystem"
> 	chunk-recover
> 	super-recover
> 	How does this relate to btrfs check?
> * btrfs check
> 	"repair a btrfs filesystem"
> 	--repair
> 	--init-csum-tree
> 	--init-extent-tree
> 	How does this relate to btrfs rescue?
> * btrfs restore
> 	"try to salvage files from a damaged filesystem"
> 	(not really repair, it's disk-scraping)
>
>
> What's the vision for, say, scrub vs. check vs. rescue?  Should they re=
pair the
> same errors, only online vs. offline?  If not, what class of errors doe=
s one fix vs.
> the other?  How would an admin know?  Can btrfs check recover a bad tre=
e root
> in the same way that mount -o recovery does?  How would I know if I sho=
uld use
> --init-*-tree, or chunk-recover, and what are the ramifications of usin=
g
> these options?
>
> It feels like recovery tools have been badly splintered, and if there's=
 an
> overarching design or vision for btrfs fs repair, I can't tell what it =
is.
> Can anyone help me?

Well, based on my understanding:
* btrfs scrub is intended to be almost exactly equivalent to scrubbing a =

RAID volume; that is, it fixes disparity between multiple copies of the=20
same block.  IOW, it isn't really repair per se, but more preventative=20
maintnence.  Currently, it only works for cases where you have multiple=20
copies of a block (dup, raid1, and raid10 profiles), but support is=20
planned for error correction of raid5 and raid6 profiles.
* mount -o recovery I don't know much about, but AFAICT, it s more for=20
dealing with metadata related FS corruption.
* mount -o degraded is used to mount a fs configured for a raid storage=20
profile with fewer devices than the profile minimum.  It's primarily so=20
that you can get the fs into a state where you can run 'btrfs device=20
replace'
* btrfs-zero-log only deals with log tree corruption.  This would be=20
roughly equivalent to zeroing out the journal on an XFS or ext4=20
filesystem, and should almost never be needed.
* btrfs rescue is intended for low level recovery corruption on an=20
offline fs.
     * chunk-recover I'm not entirely sure about, but I believe it's=20
like scrub for a single chunk on an offline fs
     * super-recover is for dealing with corrupted superblocks, and=20
tries to replace it with one of the other copies (which hopefully isn't=20
corrupted)
* btrfs check is intended to (eventually) be equivalent to the fsck=20
utility for most other filesystems.  Currently, it's relatively good at=20
identifying corruption, but less so at actually fixing it.  There are=20
however, some things that it won't catch, like a superblock pointing to=20
a corrupted root tree.
* btrfs restore is essentially disk scraping, but with built-in=20
knowledge of the filesystem's on-disk structure, which makes it more=20
reliable than more generic tools like scalpel for files that are too big =

to fit in the metadata blocks, and it is pretty much essential for=20
dealing with transparently compressed files.

In general, my personal procedure for handling a misbehaving BTRFS=20
filesystem is:
* Run btrfs check on it WITHOUT ANY OTHER OPTIONS to try to identify=20
what's wrong
* Try mounting it using -o recovery
* Try mounting it using -o ro,recovery
* Use -o degraded only if it's a BTRFS raid set that lost a disk
* If btrfs check AND dmesg both seem to indicate that the log tree is=20
corrupt, try btrfs-zero-log
* If btrfs check indicated a corrupt superblock, try btrfs rescue=20
super-recover
* If all of the above fails, ask for advice on the mailing list or IRC
Also, you should be running btrfs scrub regularly to correct bit-rot and =

force remapping of blocks with read errors.  While BTRFS technically=20
handles both transparently on reads, it only corrects thing on disk when =

you do a scrub.


--------------ms040808020308050002030301
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
GAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTQxMDA5MTEyOTIz
WjAjBgkqhkiG9w0BCQQxFgQUi5jZRBH9fGNo8AUUiLU1npRQ5A4wbAYJKoZIhvcNAQkPMV8w
XTALBglghkgBZQMEASowCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMA4GCCqGSIb3DQMCAgIA
gDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggqhkiG9w0DAgIBKDCBkQYJKwYBBAGCNxAE
MYGDMIGAMHkxEDAOBgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6Ly93d3cuY2FjZXJ0
Lm9yZzEiMCAGA1UEAxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEhMB8GCSqGSIb3DQEJ
ARYSc3VwcG9ydEBjYWNlcnQub3JnAgMPYFQwgZMGCyqGSIb3DQEJEAILMYGDoIGAMHkxEDAO
BgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6Ly93d3cuY2FjZXJ0Lm9yZzEiMCAGA1UE
AxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEhMB8GCSqGSIb3DQEJARYSc3VwcG9ydEBj
YWNlcnQub3JnAgMPYFQwDQYJKoZIhvcNAQEBBQAEggEAjeQggWxz0m5Z2WsnFKSl665ryKAb
KzEyWCzoauxWhBLHtAyskPeSsc9ALyJm+ZPPuG2sfnjXC8bvmEVcw+61RU69S1GmqOKRb8E+
kjMJAvNEYVSa5QIfLT9UnsNcyvDiZFd2uestcxYnT4vyFY4IYFi0MYLSWgLZhcWD1kFPCRc2
I902lSTJWnV0AZ9iRD6rYLB2/zGgjjKKS2ToTtyg0Las+fqC9CL0QxrH7Bae/6pSFlxbVQGE
IMRQi2vLMc+dewOEv50HgVNahjSOnCtDO6/vqAu2zWfWl4OmA2ngTe7GdOADapunmXmUy4vi
AzGKBgAdKrwRNCm3EDpcUvq3aAAAAAAAAA==
--------------ms040808020308050002030301--
