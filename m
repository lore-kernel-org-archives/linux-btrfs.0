Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f176.google.com ([209.85.223.176]:34793 "EHLO
	mail-io0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752031AbbIRONk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 Sep 2015 10:13:40 -0400
Received: by iofb144 with SMTP id b144so57817614iof.1
        for <linux-btrfs@vger.kernel.org>; Fri, 18 Sep 2015 07:13:40 -0700 (PDT)
Subject: Re: BTRFS as image store for KVM?
To: Chris Murphy <lists@colorremedies.com>, Gert Menke <gert@menke.ac>
References: <55F88ECC.1040604@menke.ac>
 <pan$a7c37$760f233d$6b18271c$f9ac2029@cox.net> <55FAFEB8.6030404@menke.ac>
 <CAJCQCtR_3eiWWmpJHC9RT4EJOzUb_AmrQkkm0X4R0OE4FYUHMQ@mail.gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <55FC1C09.7030006@gmail.com>
Date: Fri, 18 Sep 2015 10:13:29 -0400
MIME-Version: 1.0
In-Reply-To: <CAJCQCtR_3eiWWmpJHC9RT4EJOzUb_AmrQkkm0X4R0OE4FYUHMQ@mail.gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms010402000408010803000508"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms010402000408010803000508
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-09-17 14:35, Chris Murphy wrote:
> On Thu, Sep 17, 2015 at 11:56 AM, Gert Menke <gert@menke.ac> wrote:
>> Hi,
>>
>> thank you for your answers!
>>
>> So it seems there are several suboptimal alternatives here...
>>
>> MD+LVM is very close to what I want, but md has no way to cope with si=
lent
>> data corruption. So if I'd want to use a guest filesystem that has no
>> checksums either, I'm out of luck.
>
> You can use Btrfs in the guest to get at least notification of SDC. If
> you want recovery also then that's a bit more challenging. The way
> this has been done up until ZFS and Btrfs is T10 DIF (PI). There are
> already checksums on the drive, but this adds more checksums that can
> be confirmed through the entire storage stack, not just internal to
> the drive hardware.
>
> Another way is to put a conventional fs image on e.g. GlusterFS with
> checksumming enabled (and at least distributed+replicated filtering).
>
> If you do this directly on Btrfs, maybe you can mitigate some of the
> fragmentation issues with bcache or dmcache; and for persistent
> snapshotting, use qcow2 to do it instead of Btrfs. You'd use Btrfs
> snapshots to create a subvolume for doing backups of the images, and
> then get rid of the Btrfs snapshot.
>
>
The other option (which for some reason I almost never see anyone=20
suggest), is to expose 2 disks to the guest (ideally stored on different =

filesystems), and do BTRFS raid1 on top of that.  In general, this is=20
what I do (except I use LVM for the storage back-end instead of a=20
filesystem) when I have data integrity requirements in the guest.  On=20
the other hand of course, most of my VM's are trivial for me to=20
recreate, so I don't often need this and just use DM-RAID via LVm.


--------------ms010402000408010803000508
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxBuVTANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUwOTE4MTQxMzI5WjBPBgkq
hkiG9w0BCQQxQgRA06sV4SGcR7spP6hJCKKkVtvLMmjf5zD6ka6722c05UIYRo+rQw4n3Z1K
rpe97dcQ3SCHUPbv0P+cOPd3WarGrjBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxBuVTCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxBuVTAN
BgkqhkiG9w0BAQEFAASCAgBZmU4GXcqtf34podUcqiROmhJbPMf0tzw1Nd4AYFpi97QQL2Ky
fo3TYatxA/ofL3bECTh1Ne6xtpHZOnKtKxSiu1qxk/kKeyvt5rY9qwn8vjExxE1/OK91kFGD
8lKvKS7NncePmt7xgflqNVhKAxG0MHU434qF7IyRCjkq9vLuKpCUajjd5WmimV2EFuxOD4Ke
oP0xBXsseqU4GIs0qQequuG0LfYgJWuc+MOFVZc6YMT14hQDBGOdEGnVkZMddmmTXOwwnKNP
/UYkevP/vs4EjN7IOcRNN1a370yAE6AnaZLdFhYv3E4KlWpmCXEPdhRCxJ3ZZJtU1pqK/8FN
aY4PiPt+FmlFRL4RoqHkM8xIRJGD9EQ/+motzF7v9bypozTnlGR1eefz/suPQjS66ZXjelPI
uiK79GhJoG7GQlD3WEB3xQyZhqQ2Z6C5JiOr5867RhBSKA0j6XkKp9N2q2r6xa0u1LAE+7HM
6OvA2qipBCzQzkgR2676AKeyZmkBgKo1WnfLytDM2IEERii5LY+2E1LiSxFeJEeWvcs6HHcX
+JPH2SDMOepybZYL2ZnVSVVrCRO9Ztpcw7BQyg89PCNLv4l1XhhbQQoM4GFq1bL9qS492P6c
br7MX0NefCeDW4gqoGt1ej4uTsmaefxSiLTS0zE8DQZTzQiKJrLRSNYQEQAAAAAAAA==
--------------ms010402000408010803000508--
