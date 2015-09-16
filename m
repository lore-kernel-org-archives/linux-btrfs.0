Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f174.google.com ([209.85.213.174]:38874 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752031AbbIPMZN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Sep 2015 08:25:13 -0400
Received: by igxx6 with SMTP id x6so30920810igx.1
        for <linux-btrfs@vger.kernel.org>; Wed, 16 Sep 2015 05:25:12 -0700 (PDT)
Subject: Re: BTRFS as image store for KVM?
To: Brendan Heading <brendanheading@gmail.com>, Duncan <1i5t5.duncan@cox.net>
References: <55F88ECC.1040604@menke.ac>
 <pan$a7c37$760f233d$6b18271c$f9ac2029@cox.net>
 <CA+BsyQ44kPzk1txVUro7vv2=CH6SF3=9zoSkpMVmqnjtuws5Zw@mail.gmail.com>
Cc: linux-btrfs@vger.kernel.org
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <55F95FA3.1040409@gmail.com>
Date: Wed, 16 Sep 2015 08:25:07 -0400
MIME-Version: 1.0
In-Reply-To: <CA+BsyQ44kPzk1txVUro7vv2=CH6SF3=9zoSkpMVmqnjtuws5Zw@mail.gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms070806020306080107020403"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms070806020306080107020403
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-09-16 07:35, Brendan Heading wrote:
>> Btrfs has two possible solutions to work around the problem.  The firs=
t
>> one is the autodefrag mount option, which detects file fragmentation
>> during the write and queues up the affected file for a defragmenting
>> rewrite by a lower priority worker thread.  This works best on the sma=
ll
>> end, because as file size increases, so does time to actually write it=

>> out, and at some point, depending on the size of the file and how busy=

>> the database/VM is, writes are (trying to) come in faster than the fil=
e
>> can be rewritten.  Typically, there's no problem under a quarter GiB,
>> with people beginning to notice performance issues at half to 3/4 GiB,=

>> tho on fast disks and not too busy VMs/DBs (which may well include you=
r
>> home system, depending on what you use the VMs for), you might not see=

>> problems until size reaches 2 GiB or so.  As such, autodefrag tends to=
 be
>> a very good option for firefox sqlite database files, for instance, as=

>> they tend to be small enough not to have issues.  But it's not going t=
o
>> work so well for multi-GiB VM images.
>
> [unlurking for the first time]
>
> This problem has been faced by a certain very large storage vendor
> whom I won't name, who provide an option similar to the above. Reading
> between the lines I think their approach is to try to detect which
> accesses are read-sequential, and schedule those blocks for rewriting
> in sequence. They also have a feature to run as a background job which
> can be scheduled to run during an off peak period where they can
> reorder entire files that are significantly out of sequence. I'd
> expect the algorithm is intelligent ie there's no need to rewrite
> entire large files that are mostly sequential with a few out-of-order
> sections.
>
> Has anyone considered these options for btrfs ? Not being able to run
> VMs on it is probably going to be a bit of a killer ..
>
3 things to mention here:
1. It's perfectly possible to run VM's on BTRFS, it just takes some=20
effort to get decent efficiency, and you can't really over-provision=20
storage (the above mentioned effort is to create the file with NOCOW=20
set, and then use fallocate or dd to pre-allocate space for it).
2. If you are using a file for the disk image, you are already=20
sacrificing performance for portability, it's just a bigger tradeoff=20
with BTRFS than most other filesystems on Linux.
3. Almost all of the issues that BTRFS has with VM disk images are also=20
present in other filesystems, they are just much worse on BTRFS because=20
of the fact that it is COW based.


--------------ms070806020306080107020403
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxBuVTANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUwOTE2MTIyNTA3WjBPBgkq
hkiG9w0BCQQxQgRAyOMLsw2SEioTMih6HL5nTLKZ6G0I6wxoiJJSLBc1Y+yFMDMy1M3fWUHz
biXM9A33CYzuOaqF5NLGfn1w4xcSMjBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxBuVTCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxBuVTAN
BgkqhkiG9w0BAQEFAASCAgBEB+UKoZMGmPJ+QAV5PDYylb6ITsj5hsBBP2pcGtt2Ua0wPjWT
A80mbRWqUOc71edurRXwk/f9GtKMATmOzy9zPer/omdhgb2z8LF/FhzYkDNCaqdFLxYt4usC
OVFnWooJIOusTzOYdiBlZHcXuqGToyaaKozHNoKG+uuN5WZfcBJeRZ4r0EUBfN2RlpbMm4K/
JcGsaJ66Y4h1qOABh33jjr5rTJKd+6W1cMRLFQ1im5j5qt7YZM9knroh5hjEHV0/4T6AdkhH
k5KUuhfQiLmekU+MmLMpADRSVWhffxN7+G3cvKpwzE9DOh3izhe7PlTOTujfAFA1kYdTxlzx
V+CRx88i7JUIdQfCgIXRfWqj4dA+bzH8lHYmcLHLUvlfm5xNv6CXe2VliNNN4M/PjhJpCKMt
8y/clNRHCocCVfTVJtMllkfHqkUDAGFLlzVRFJyQuRSkH9YdBDkvBo/e9jEVCk9rEv4kp59l
fz5J7E//1NlJEXmgJdFe7KEOnKcWF7jj8nNPcAdQZPxWgpdQ6jXoLRNeZnXfhem636ny2ipN
4DjhhmmtVVGmiuYKPogHn9PCpKIBK/P8TlNGBlXTbY8jGwlK6ZPT6YXas1i1rQOgWuOsFMGR
hXGluBSwcgwjeU9/HLxiJ8BWIxrq18f8epmLORijiueqShirBN3gZ72PxwAAAAAAAA==
--------------ms070806020306080107020403--
