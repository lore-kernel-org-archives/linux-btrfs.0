Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f180.google.com ([209.85.223.180]:33189 "EHLO
	mail-io0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650AbbKLOiM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Nov 2015 09:38:12 -0500
Received: by iouu10 with SMTP id u10so58802685iou.0
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Nov 2015 06:38:11 -0800 (PST)
Subject: Re: Ideas for btrfs-convert fix(or rework)
To: Roman Mamedov <rm@romanrm.net>
References: <56418E5D.9020604@gmx.com> <20151110125501.1aa6f155@natsu>
 <5641A7DA.6010102@gmx.com> <20151110140855.3ae7297c@natsu>
 <5641B64A.9020606@gmx.com> <pan$edd20$481e3529$4248bf13$5caaf119@cox.net>
 <CAO5K3OfBy72Yn1s4Ow2h_2KkE7U4wQA66oxjQLva82-D2LqScA@mail.gmail.com>
 <564493D5.2070609@gmail.com> <20151112190918.3820dd2a@natsu>
Cc: Vytautas D <vytdau@gmail.com>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <5644A44B.6050804@gmail.com>
Date: Thu, 12 Nov 2015 09:38:03 -0500
MIME-Version: 1.0
In-Reply-To: <20151112190918.3820dd2a@natsu>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms060004090805020308060004"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms060004090805020308060004
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-11-12 09:09, Roman Mamedov wrote:
> On Thu, 12 Nov 2015 08:27:49 -0500
> Austin S Hemmelgarn <ahferroin7@gmail.com> wrote:
>
>> know of (Arch and Gentoo), because the very fact that you installed a
>> system with either one means that you are fully capable of backing up
>> your data, and reprovisioning the system using BTRFS instead of whatev=
er
>> filesystem you are already using
>
> Uhm, what?... How does the fact that I use one particular distro or ano=
ther,
> reflect on my ability to (easily) back up and restore my 10 TB storage =
array?
> "You should maintain backups anyway so you could easily restore" -- yea=
h I do,
> and they are in a remote location over a relatively slow link.
I did not mean to imply that you had the ability to do it quickly, just=20
the ability to do it.  I specifically stated 'very little' instead of=20
'none' to account for cases like yours.  However, the statement is still =

accurate because Arch and Gentoo both have very low-level user=20
involvement in the install process (no GUI, user manually provisions the =

storage and handles installing the base system).  If you are capable of=20
installing such a system (and as such, capable of correctly using stuff=20
like parted or fdisk without breaking anything), you are absolutely=20
capable of reprovisioning such a system (how long that would take is a=20
completely different matter).
> I chose Ext4 instead of the other options which seemed more attractive
> (primarily XFS, but also JFS) for this array back when creating it a lo=
ng time
> ago, when Btrfs was still in its much earlier days than now, **SPECIFIC=
ALLY**
> with the intent to use btrfs-convert "as soon as Btrfs somewhat matures=
". So
> as time went, it did, I acted on this plan, and everything went just pe=
rfectly.
And you got somewhat lucky in that case (and actually did proper=20
research, sadly most people don't seem to do anywhere near enough=20
research when it comes to stuff like this).  Doing an in-place=20
conversion of a filesystem (or an OS, or anything else for that matter)=20
is _always_ going to be inherently more risk than just properly=20
reprovisioning (take a look at the absolute insanity that is the 'free'=20
Windows 10 upgrade for an example of this on the OS side).  Admittedly,=20
compared to other software that does this (the only other program that I =

know of to do this is fstransform), btrfs-convert is relatively safe,=20
but it is not possible for it to be any safer than just reprovisioning.
> Why are people so quick to project "If I don't need this, nobody likely=
 does".
> Btrfs-convert is an amazing feature and it will be extremely sad if it =
ever
> goes away.
And as time goes on, it will be used less and less, and it's _always_=20
going to be something that 99% of users who actually use it (if you're=20
doing any kind of RAID, it makes more sense from a data safety=20
perspective to just reprovision so you can use BTRFS's native raid=20
functionality) run exactly once per filesystem per system (once you've=20
converted existing systems, you don't need it unless you were using dump =

for backups).  I'm not arguing that it should just go away, I'm trying=20
to argue that it shouldn't be a development priority if it works correctl=
y.


--------------ms060004090805020308060004
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUxMTEyMTQzODAzWjBPBgkq
hkiG9w0BCQQxQgRADuUsI5xDU/4hluuwWaiv+lIeJm0bj7ecSrI++0vVJzuEKlySKGtRiMOi
Ti5/xVevENeNpVsfmmjSyQIoq3XrLTBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxEt+DCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DAN
BgkqhkiG9w0BAQEFAASCAgB8YreP/wBl/oyp1tBZWrkHxtDvODz8MuZn0zzR7vhR9DJadfaB
MLdy+HFCcb7iE7ZtwGlLBzsUtOhUBMzAMZn3PHImv6QCYb6aWvl4tdcNlPWQjAnkSc6GNdnS
z6wv50DK+WdvG5fivMwS1Uue4hcz5dUHxjk/8E7qZSbMJ4eoul2FZ7t4gpEolJtmFlO74AKh
m7Q59o0QEWZ2X43WVWuJx1RBBTrphmXNlhIWai//jFaR8AtjpTivbmNZUPFN+s+rlaU3mtQl
U82Ne/Z0q3pMRdj2MDZ4/ZnHIKq4WS37BlC7JGYijvjC6YpRGxgLh1F0drzfmOxka3RfXRN7
mzKmP/6eY+4gHgUSnKxqZP9Tbf7it9/LbaUciCGCav8FiUmY1YkWxvwDOwGSJOqKhoVbHdrp
DKqCwvqY2ZzkDrfi8s/iQZls8s7bSro7ywiH+dFDhrnmNrkahm5qnDoSKlmNV2w4QTTF6D1Q
/wh04nmwt8fqBGujLWj0o5RAbJxnKp+Wzatv69OBG0HOA2InUOA0Opdw1gExWB5VRcultw2M
WcUb6kdr3JV3nTgLHvCRmn3ZKrb4rcvVGY2FOguDbzYwh329XPBwT9LCvk76OlDStTUFyZo8
7yxlpnXAi+TLiNKlU4xfzbGOw8iwzomrcCW+v44wEwje1eTbz3HZCHr8cAAAAAAAAA==
--------------ms060004090805020308060004--
