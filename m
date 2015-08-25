Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f180.google.com ([209.85.223.180]:34867 "EHLO
	mail-io0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755480AbbHYPyF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Aug 2015 11:54:05 -0400
Received: by iodt126 with SMTP id t126so192219179iod.2
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Aug 2015 08:54:04 -0700 (PDT)
Subject: Re: Response to Bcachefs Claims
To: Vincent Olivier <vincent@up4.com>, linux-btrfs@vger.kernel.org
References: <1440516154.040713246@apps.rackspace.com>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <55DC8F96.2010506@gmail.com>
Date: Tue, 25 Aug 2015 11:53:58 -0400
MIME-Version: 1.0
In-Reply-To: <1440516154.040713246@apps.rackspace.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms090502070506000103010906"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms090502070506000103010906
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-08-25 11:22, Vincent Olivier wrote:
> Hi,
>
> I have been using Btrfs for almost a year now with a 16x4TB RAID10 and =
its 8x4TB RAID0 backup (using incremental snapshots diffs). I have always=
 tried to stay at the latest stable kernel (currently 4.1.6). But I might=
 be moving to Fedora 22 because Centos 7 has significant incompatibilitie=
s with the 4.1.x kernel series.
>
> I have seen the news about Bcachefs aiming to be Btrfs-complete while b=
eing extX-stable.
>
> What are the chances Bcachefs beats Btrfs at being the Linux kernel's n=
ext "official" file system ? I chose Btrfs over ZFS because it seemed lik=
e the only "next-gen" heir to ext4/xfs.
>
> I have been having a few problems with Btrfs myself. I have only one th=
at remains unresolved : I haven't found the best way to mount Btrfs at bo=
ot time. "LABEL=3D" won't work for known reasons (I don't understand howe=
ver why a mount can't do its own "device scan" transparently). "UUID=3D" =
won't work for unknown reasons (haven't got a reply on this, maybe it's t=
he same as "LABEL=3D"). And I will use /dev/* in fstab for stability reas=
ons. Right now I'm mounting the fs manually after a "device scan" and pic=
king up the first device that shows up in the "fi show" run. I can "live"=
 with that but I suppose that things like this contribute to the feeling =
that Btrfs is actually still experimental contrarily to claims that it is=
 production-ready.
>
> For my own sake and other's I would like to maintain (if nobody is alre=
ady working on that nor needs any help) a centralized human-readable dige=
st of known issues that would be featured prominently on top of the Btrfs=
 wiki. I would merge the Gotchas page and the various known issues pages =
(including the various multi-device mount gotchas here and there).
>
> Answers ? Comments ? Help ?
First off, I think this is a wonderful idea.  The list of known issues=20
isn't always particularly up to date, and isn't as trivial to find as it =

should be.

Secondly, as far as UUID=3D not working from the kernel commandline, I=20
believe it's for the same reason that LABEL=3D doesn't work consistently.=
=20
  I would like to point out that LABEL=3D does work if you use a sane=20
initramfs (I boot my desktop using it, although I'm only using an=20
initramfs because I have root on a pair of LVM volumes), and I _think_=20
it might also work if you pas device=3D options in the rootoptions=3D str=
ing.

Thirdly, there is one issue that I haven't seen anyone else mention and=20
that is not present on any of the wiki pages at last check:
If you try to use BTRFS on top of LVM thin-provisioning (or=20
theoretically any dm-thinp setup), and turn off zeroing of newly=20
allocated blocks, this can cause BTRFS to have corruption issues.  I=20
think this is actually a dm-thinp issue, not a BTRFS one (turning this=20
option off does not clear the discard_zeroes_data flag for the device,=20
which I would assume that BTRFS trusts), but is still worth mentioning.



--------------ms090502070506000103010906
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxBuVTANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUwODI1MTU1MzU4WjBPBgkq
hkiG9w0BCQQxQgRAWJOgfXk2V9mi4MOmDui9ep8SqTLy38Lr2M6Ng9dHvMZ2LYoX9lc09DH2
RwYcQP/r3yDJjXVvJs4/NNJtFC/iJTBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxBuVTCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxBuVTAN
BgkqhkiG9w0BAQEFAASCAgAQhRtOWIEo3Qi8OqqnV/VUFAOIcU6Q3PuqOb8mrywVsBlygDbQ
fAX+mZdxUl1PyhOzzPyw8WlZOT6QSVtS2nhKofXR7n0/clUYkQPkxzdgGiq4aa/SPEuFZO3a
VkfCA9shx09VBB9+Nf1hcTNKBdDD9vDqUUYCFMosV7fQFfKKl9yc0Py/nCFM/QmmVwdnC4/C
ZhldzLCdLUrN5pKRVQon0Nai7BVWMAkmclFgTYkSG5a5c/N5ufvcjIXUaoV896H1/210hQDo
TWonmmtXusFFWI1SBdAKI4yr7rnNbOFVnTQOvwiVVsLD1ULpJYmuNREr44maIuEa/xO2FEYI
MusrqwSCU9CNICe4FBwgfCQpVN98LrEUfDRYcD2ClqhCKCVh9CO81kgSfQtun2FM23YxPw1Z
psip8EgyxLRBi5NcvvifD1Ck+W2rq5Bjm3gZ6jq4SZkhPVUP07X0268fD0exA595AsgMGoLj
arfvhKz3tHUvnemtpy5s/cTncSd+Wp7aU7J4WOeVuEZS8rpUAjMzGFbdKloFdnPFs4relMCn
ZceJwieozwtOXP9VQbiavNwPxZWS6WatFp+rQ628f+DxrSehcsBfs+r9BKKTy91qqGdi5B/e
Ya2vlZy1ify4zfcS7a1NphBcd9O5IRbQh5ic/2C0WAnx4qPglwJn9ShvfAAAAAAAAA==
--------------ms090502070506000103010906--
