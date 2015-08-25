Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f179.google.com ([209.85.223.179]:33937 "EHLO
	mail-io0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316AbbHYOAJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Aug 2015 10:00:09 -0400
Received: by iodb91 with SMTP id b91so186470568iod.1
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Aug 2015 07:00:09 -0700 (PDT)
Subject: Re: Btrfs tragedy: lack of space for metadata leads to loss of fs.
To: =?UTF-8?Q?Miguel_Negr=c3=a3o?=
	<miguel.negrao-lists@friendlyvirus.org>,
        linux-btrfs@vger.kernel.org
References: <loom.20150825T151154-787@post.gmane.org>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <55DC74E2.9000909@gmail.com>
Date: Tue, 25 Aug 2015 10:00:02 -0400
MIME-Version: 1.0
In-Reply-To: <loom.20150825T151154-787@post.gmane.org>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms090900090908030200020301"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms090900090908030200020301
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-08-25 09:44, Miguel Negr=C3=A3o wrote:
> Hi list,
>
> This weekend had my first btrfs horror story.
>
> system: 3.13.0-49-lowlatency, btrfs-progs v4.1.2
>
> A disclaimer: I know 3.13 is very out of date, but I the requirement of=

> keeping kernel up to date clashes with my requirement of keeping a stab=
le
> system. At the moment I can't disturb my system as I'm doing important =
work,
> upgrading kernel requires upgrading ubuntu, which will upgrade a lot of=

> packages and might lead to problems which I don't have time to fix. One=

> might argue that in the end I lost time anyway dealing with these btrfs=

> issues. When I'm done with this current work I will update the whole sy=
stem
> which will update the kernel in the process.
>
> Story:
>
> btrfs fi show / -> devid 1 size 92.27GiB used 92.27GiB.
>
> Suddenly a 100GB single device fs goes into a state where it doesn't ha=
ve
> more free space, no new files can be written. 'fi usage' says a minimum=
 of
> 20GB are free, but metadata is 4.97GiB allocated vs 4.45Gib used. I dec=
ide
> to do a 'balance -dusage=3D55' as lower values of usage don't balance
> anything. This starts a balance of '0 out of 0 chunks' which goes on fo=
r 24h
> (status always says 0 considered, -nan% left, dmesg had only 'relocatin=
g
> block group 32...... flags 36'). This is a OCZ vertex 3, a quite fast S=
SD.
> 24h seemed excessive to me, I assume that the balance has gone wrong
> somehow. I shutdown the system to see if the balance will stop. On the =
first
> boot up the fs is still mounted, on a second boot the fs no longer moun=
ts.
>
> I switch to a nixos usb pen running kernel 4.1.6 and progs up to date a=
lso
> (probably 4.1.x). Trying to mount the fs results in a kernel error (
> http://pastebin.com/CzryecsX ).
>
> trying mounting with '-o recovery,ro' hangs the system, a reboot is nee=
ded.
>
> I proceed to get contents of disk via 'restore'. I then do btrfs-zero-l=
og,
> still doesn't mount, and then do btrfs check --repair a couple of times=
 (log
> before running with '--repair' http://pastebin.com/VPZLjcXR)
>
> I then try to mount with '-o recovery,ro' and it works !! (thank you bt=
rfs
> check !!). I proceed to get the data out of the disk, this seems to go =
well,
> no errors in dmesg. I then try to mount without recovery,ro and again t=
he
> kernel hangs. One time I had the dmesg window open and was able to see =
that
> it was something about ..._async_reclaim_metadata_space.
>
> I finally give up on the filesystem and format it. I have an image prod=
uced
> via btrfs-image if it is of interest.
>
> A couple of notes:
>
> 1) I know btrfs is experimental, anything that I might have lost is my =
fault
> (I didn't loose anything).
> 2) I think this issue of free space is a known issues being worked on, =
that
> no space to allocate when metadata space is needed will cause no free s=
pace
> problem. It's on the faq. Still, it doesn't seem acceptable to me that =
the
> system can go into a state where in the end the fs is destroyed or the =
linux
> machine is unusable (can never turn it off because balance never stops)=
,
> specially since there was still a lot of space in the disk. If the syst=
em
> somehow had rebalanced itself automatically this could have been avoide=
d. It
> shouldn't let itself get into this corner. Perhaps a bit of space shoul=
d
> always be kept for emergency rebalancing ?
> 4) I wonder if that balance would have ended or if it had just stalled.=
 It
> seems that a reboot with a ongoing or stalled balance will cause fs
> destruction. Possibly an issue already fixed in later kernels. Also, wh=
y did
> it say 0 considered, -nan% left ? -nan% looks strange.
> 3) The system freezing when trying to mount a fs is possible not suppos=
ed to
> happen ? (this was on the latest kernel)
>
> Just wanted to share the story in case it is of some use for developers=
=2E
> Again, possibly this happened due to issues already fixed in later kern=
els.
> Anyway, despite this issue, I'm still quite happy with btrfs overall.
>
One comment I would like to make about this: I have heard numerous=20
stories of OCZ brand SSD's having significant data corruption issues=20
(along the lines of writes returning successful when they really failed, =

and blocks that are in use getting randomly erased) that can cause=20
severe data loss and filesystem problems.  While I do think that btrfs=20
needs to be improved when faced with such things, I would not at all be=20
surprised if the SSD was the root cause of the issue.



--------------ms090900090908030200020301
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxBuVTANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUwODI1MTQwMDAyWjBPBgkq
hkiG9w0BCQQxQgRAEfQtU6uRTGjm1pF11vlmAMk6MfzHR+0ttgZoiD+/O0+sd+CStgVOeTGB
GOwxDUjyrafLYrW4ix7tjZ1R5jEChTBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxBuVTCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxBuVTAN
BgkqhkiG9w0BAQEFAASCAgBXGBgl6oKGIKAjYjP3qGRQ2Lc2vBYLV5N78n4JAd3RhudhDIk9
XoTS9H1C70tzB3fwcgsighrmrav9PXqjZ84XW/ESlt2hYrw/C9oGpaqJ7qlhRdDbi5JkJHyO
rG2+nE4wmRzJgD1hSDRikJvLxvgsbohZv9OyA1CO+tOGJe4Oja7eFyZFv6rxmsS19Otoo+F0
7AIj0hAgxeigVQ3XlGhxC5P8C0AcjQZTUqpCfRg82R0Ov/i+7sOGjitpCkUCHb4+hafPmc1k
ohJt5hwHJ8tshvpHbKzgihXTtF/X7nRB4F9lp6TqqDbLuqcMvsQRUVSEUpWo/5i1KRoNQ5lL
swZYd/aS6QXv4pr/Tgnb+zFl6ADCqRUtApp2EKqyzJLOBvl0+A9ArEcK3bcwMuq+pj0jTqAO
61GdALfIdRR/Ivzm8HW4tVaIbbnG2ETYayKjWuyw6fUd6U0J4szg1LQNESOnkXWXrK+K78Tu
HKQCn1nEwMDdS/8dFZkbyGwwOZHjhWkEMlaVTVaz6XGxtbgbj1u/SQYu1QEpyUBIuqWIlTGG
5zsQEwxJ0HlFxMgHCyTxbrr0ul8K26uscymPJBlvVcuT+bCjD7ftCyACbMl/34CYO7MRdZQU
Jr7POfMOtNhAqZ4p83XYmgkDmM86/F0PaXI3v3LfTRa82ltJIJDL8jbMwgAAAAAAAA==
--------------ms090900090908030200020301--
