Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f169.google.com ([209.85.223.169]:35490 "EHLO
	mail-io0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755877AbbJ1LYs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 28 Oct 2015 07:24:48 -0400
Received: by iofz202 with SMTP id z202so6550515iof.2
        for <linux-btrfs@vger.kernel.org>; Wed, 28 Oct 2015 04:24:47 -0700 (PDT)
Subject: Re: random i/o error without error in dmesg
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
References: <562E0D31.2080003@dblaci.hu> <5339076.FcC2BAjqs5@thetick>
 <pan$69543$b4766f34$8286648d$3871cb8f@cox.net> <1844690.p2LsPbdn9l@thetick>
 <pan$31224$86839f8e$da37e2a5$124e475b@cox.net>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <5630B040.8020203@gmail.com>
Date: Wed, 28 Oct 2015 07:23:44 -0400
MIME-Version: 1.0
In-Reply-To: <pan$31224$86839f8e$da37e2a5$124e475b@cox.net>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms040804000008040300040903"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms040804000008040300040903
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-10-28 01:21, Duncan wrote:
> Marc Joliet posted on Tue, 27 Oct 2015 21:54:40 +0100 as excerpted:
>
>>> IOW, does it take a full reboot to clear the problem, or is a simple
>>> ro/rw mount cycle enough, or an unmount/remount?
>>
>> Seems that a full reboot is needed, but I would expect that it would
>> have the same effect if I were to pivot back into the initramfs, unmou=
nt
>> / from there,
>> then boot back into the system.  Because quite frankly, I can't think =
of
>> any reason why a power cycle to the SSD should make a difference here.=

>> I vaguely remember that systemd can do that, so I'll see if I can find=

>> out how.
>
> Agree with both the systemd returning to the initr* point (which I
> actually had in mind while writing the above but don't remember the
> details either, so chose to omit in the interest of limiting the size o=
f
> the reply and research necessary to generate it), and the ssd power-cyc=
le
> point.
>
>>> Finally, assuming root itself isn't btrfs, if you have btrfs configur=
ed
>>> as a module, you could try unmounting all btrfs and then unloading th=
e
>>> module, then reloading and remounting.  That should entirely clear al=
l
>>> in-memory btrfs state, so if that doesn't solve the problem, while
>>> rebooting does, then the problem's very possibly outside of btrfs sco=
pe.
>>> Of course if root is btrfs, you can't really check that.
>>
>> Nope, btrfs is built-in (though it doesn't have to be, what with me
>> using an initramfs).
>
> Same here, also gentoo as I guess you know from previous exchanges.  Bu=
t
> unfortunately, if your initr* is anything like mine, and your kernel
> monolithic as mine, making btrfs a module with a btrfs root isn't the
> easy thing it might seem to those who run ordinary distro supplied bina=
ry
> kernels with pretty much everything modularized, as doing so involves a=

> whole new set of research on how to get that module properly included i=
n
> the initr* and loaded there, as well as installing and building the who=
le
> module-handling infrastructure (modprobe and friends) again, as it's no=
t
> actually installed on the system at all at this point, because with the=

> kernel entirely monolithic, module-handling tools are unnecessary and
> thus just another unnecessary package to have to keep building updates
> for, if they remain installed.
FWIW, I'm pretty sure that genkernel-next (and possibly genkernel too at =

this point, but that's never had working userland support for BTRFS=20
AFAICT) includes btrfs.ko and it's dependencies in any initr* it=20
generates when it sees those modules on the system, although I'm not=20
100% certain because I always build the driver for my root filesystem=20
into the kernel directly.
>
[ snip ]
> What's left in the lib_user list after a dip to emergency mode, whether=

> you've returned to multi-user mode or not, is often only systemd and
> perhaps its journald service, itself.  Journald can be restarted manual=
ly
> in the usual way (systemctl restart journald.service or whatever, I
> usually use tab completion so don't pay all that much attention to the
> specific name), if necessary, while systemd itself can be "reexecuted"
> using the systemctl daemon-reexec (tab-completion again) command.
Udev might also be listed (for some reason, a lot of distros don't stop=20
it when going to emergency mode, I don't know about what Gentoo does in=20
this case though because I don't use systemd), and at least the last=20
time I checked, dropping to emergency mode on Debian and Fedora testing=20
versions also keeps any dhcp clients or other stuff needed for=20
maintaining the network connection running as well.



--------------ms040804000008040300040903
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUxMDI4MTEyMzQ0WjBPBgkq
hkiG9w0BCQQxQgRAz/JTBMXp/2QsIfWqtdJaiRzquR5k7pub7quxjmy7Fv+xB9H7hLBNDrbC
ZbNgZgJg9Fltfh7SbHoTf+KBw2HEITBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxEt+DCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DAN
BgkqhkiG9w0BAQEFAASCAgAQAs04ZrAINsag4Hs+ENZvu0RaE/t+JCR+G7zhLD3FF0yb5DpJ
EUY1/bjxiFDO8MZKWgblVaCarahB16oAxnV68HHO8jEEr1Ug5tA8wLEE81G399OIlKrLE9wc
KCzaAk22vX3pw9YpW1MAuBYOezXISiiWmLwxFS3oiSFllvAuZEoSegs9FLBT8cjJ+xUO8/zo
R4Ke2CukcT8sLgBwtgs+Xa5YDLt4coS6zymylLwKKzfYCXpT7PD6v6Tr3EcRk+1aN9DrIgEM
60gsjGbs/c4+Ss4OoQw4FV1Z0JeZGY/VGxVF8e9Kl3HIN5/EwFkxjxxq79m7aOLPn0ik6bmr
L0OTkuJdqYISm6KaO7/e3siz3C7twX23Y+0/yWDOSQU3jHRcFZ1wkXd8/+CRvsf6dFv9GsTL
fwwF2Fqcgn1IoKpVhe2/V7w9MfxkB/6mbFadks7MQMndPFY57ImQLJ7QlxScdDqBLTYZslGl
RO9ShKZ0njUeGH62WH9nI0hVufF9rHao7N6Q26Lj+NMyn3k0KwVqxXxRpLenx3NRi/CXba1Y
NKZI5jbmYdJCyKsHW2Xe3BWOuNdXDyVAHsqSZA0SEWv3MpA9Pa0/znoJiMEM2UmVI0dUhgr1
f/sSvAdytEPQ2h7IeTwuFWs52rMSXIpjiIkuWpof4zceR1IMUNOntUsySQAAAAAAAA==
--------------ms040804000008040300040903--
