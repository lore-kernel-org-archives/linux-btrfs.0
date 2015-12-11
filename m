Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailgw-02.dd24.net ([193.46.215.43]:47072 "EHLO
	mailgw-02.dd24.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640AbbLKWGI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Dec 2015 17:06:08 -0500
Message-ID: <1449871563.31388.62.camel@scientia.net>
Subject: Re: attacking btrfs filesystems via UUID collisions?
From: Christoph Anton Mitterer <calestyo@scientia.net>
To: linux-btrfs@vger.kernel.org
Cc: Qu Wenruo <quwenruo.btrfs@gmx.com>, "S.J." <sorry@anonym.com>
Date: Fri, 11 Dec 2015 23:06:03 +0100
In-Reply-To: <5668A1CB.1020007@anonym.com>
References: <20151204120529.37E47D5A28@emkei.cz>
	 <20151204130758.GR8775@carfax.org.uk>
	 <1449286104.18841.14.camel@scientia.net>
	 <pan$7e229$ce87d3b$b8d75c44$337e15c7@cox.net>
	 <1449366680.3183.37.camel@scientia.net> <56644785.4090702@gmx.com>
	 <1449639588.7835.2.camel@scientia.net> <5668A1CB.1020007@anonym.com>
Content-Type: multipart/signed; micalg="sha-512";
	protocol="application/x-pkcs7-signature";
	boundary="=-I4+z9shvQu0j747iKhKG"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--=-I4+z9shvQu0j747iKhKG
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2015-12-09 at 22:48 +0100, S.J. wrote:
> > 3. Some way to fail gracefully, when there's ambiguity that cannot
> > be
> > resolved. Once there are duplicate devs (dd or lvm snapshots, etc)
> > then there's simply no way to resolve the ambiguity automatically,
> > and
> > the volume should just refuse to rw mount until the user resolves
> > the
> > ambiguity. I think it's OK to fallback to ro mount (maybe) by
> > default
> > in such a case rather than totally fail to mount.
> About 3:
> RO fallback for the second device/partitions is not good.
> It won't stop confusing the two partitions, and even if both are RO,
> thinking it's ok to read and then reading the wrong data is bad.
Adding my two cents about that, just to emphasise it, even though S.J.
already covered it:

Even romounts, if anything is ambiguous, are evil:
Even if the filesystem itself wouldn't be destroyed by that, it could
mean that bogus data (or even evil data by an attacker) shows up in the
system that is then used and causes damage by being used.

In the "accidental" scenario, data from the wrong device could e.g.
contain outdated binaries, that still have security holes, or they
could contain lists of datasets to be deleted by some software, but
since being outdated or simply garbage, the wrong data could be
deleted.

In the "attacker" scenario,... well again as above, old binaries could
get used, or garbage data injected into the system (even if ro) could
make it compromised or be used for DoS.




In general, the longer I think about it, the more I come to the
conclusion that any form of auto activation (mounting, assembling,
rebuilding, etc.) is kind of dangerous... (see below)

And this applies in general, not just when using UUIDs,... but since in
btrfs UUIDs are the main criterion for selecting/auto-assembling these
devices, it's what applies for us here.

We have several stages, where wrong devices could be picked up and lead
to damage (either accidentally or as part of a tricky attack):
1) When the system boots, i.e. replacing parts of the system (e.g.=C2=A0
=C2=A0 =C2=A0root fs) itself.
=C2=A0 =C2=A0There's little we can do here in general (regardless of UUID,
=C2=A0 =C2=A0labels or device=3D/dev/sda,/dev/sdb). If an attacker can exch=
ange
=C2=A0 =C2=A0one of the devices, he may do evil things.
=C2=A0 =C2=A0That's bad of course, but I think "fixing" it, is beyond the s=
cope
=C2=A0 =C2=A0of btrfs.
=C2=A0 =C2=A0- If e.g. the ATM has an unsecured BIOS/UEFI/bootloader and al=
lows=C2=A0
=C2=A0 =C2=A0 =C2=A0the attacker easily to access these and select which de=
vice to=C2=A0
=C2=A0 =C2=A0 =C2=A0boot from,... well than I feel no sorry for the owner (=
their=C2=A0
=C2=A0 =C2=A0 =C2=A0fault).
=C2=A0 =C2=A0- If they configure their grub/initrd/etc. to boot LABEL/UUID.=
..=C2=A0
=C2=A0 =C2=A0 =C2=A0well that's certainly handy, but it's also stupid if th=
ese boots=C2=A0
=C2=A0 =C2=A0 =C2=A0happen unattended, and there is an way around it (speci=
fy the=C2=A0
=C2=A0 =C2=A0 =C2=A0device paths or e.g. /dev/sda)... if the HDDs are prope=
rly
=C2=A0 =C2=A0 =C2=A0secured by steel, and attacker cannot use the possibly =
more
=C2=A0 =C2=A0 =C2=A0easily accessible USB bus.
=C2=A0 =C2=A0- Another way to partially help here is: use disk dm-crypt and=
=C2=A0
=C2=A0 =C2=A0 =C2=A0boot/assemble your system based on the dm-crypt devices=
.
=C2=A0 =C2=A0 =C2=A0E.g. boot from the multi-device-btrfs=C2=A0
=C2=A0 =C2=A0 =C2=A0device=3D/dev/mapper/crypt1,/dev/mapper/crypt2 and so o=
n.
=C2=A0 =C2=A0 =C2=A0As long as the kernel and initrd (which does all that) =
are secure=C2=A0
=C2=A0 =C2=A0 =C2=A0(which is assumed here), then even when the attacker ma=
nages to=C2=A0
=C2=A0 =C2=A0 =C2=A0replace one of the devices, it wouldn't help him, as th=
e he=C2=A0
=C2=A0 =C2=A0 =C2=A0couldn't present a device for which a dm-crypt mapping =
can be set=C2=A0
=C2=A0 =C2=A0 =C2=A0up (unless he has the keys, but then game's over anyway=
)

=3D> Long story short, if the system boots unattended, then people
=C2=A0 =C2=A0should not use UUID/LABEL to select the device, if they do, th=
eir=C2=A0
=C2=A0 =C2=A0fault, not btrfs scope.
=C2=A0 =C2=A0If boots are attended, there's anyway not problem.
=3D> IHMO, this conceptually "fixes" (in the sense, that there's nothing
=C2=A0 =C2=A0to do specifically from the btrfs side) the possible problems =
of
=C2=A0 =C2=A0such a system being booted, with an attacker having replaced o=
r=C2=A0
=C2=A0 =C2=A0added some devices to it (especially when unattended).
=C2=A0 =C2=A0And also the situation, that such system was left back, in an
=C2=A0 =C2=A0incomplete multi-device state (i.e. left back unattended with =
a
=C2=A0 =C2=A0degraded RAID)


In other words, I think any problems, resulting of auto-
assembly/activation/mounting, based on UUIDs/device-scanning/etc. that
affect the valid system becoming running (i.e. booting) are beyond our
scope here.
Yes there are problems, but one can at least try to avoid them, by
using dm-crypt =C2=A0or =C2=A0device paths instead of LABELS/UUIDs, and pro=
perly
securing (i.e. steel and so on) the system disks, mainboard, bios, etc.


So the remaining issues are those we discussed already before:
The system runs already.
1) Further devices show up with colliding UUIDs /device IDs.
=C2=A0 =C2=A0a) Either none of them are used (mounted, fsck, etc.) already.
=C2=A0 =C2=A0b) Or =C2=A0 =C2=A0 some of them are used (mounted, fsck, etc.=
) already.
2)
Further devices show up, that have no UUID / device ID collisions,
=C2=A0
=C2=A0but that may fit to an already used multi-device btrfs.
=C2=A0 =C2=A0E.g. in the
sense of: I have degraded RAID1 btrfs where my system
=C2=A0 =C2=A0runs upon. A
new device shows up that would fit to that btrfs.

(1) we already discussed:
Effects:
- it leads to data corruption
- attackers may use it to cause damage or even get out data
Possible solutions:
If such situations occur:
- In case (a) refuse to do (mount, fsck, =C2=A0anything else from the btrfs
=C2=A0 tools) anything unless the user specified the devices to be used=C2=
=A0
=C2=A0 manually (i.e. device=3D/dev/sda,/dev/sdb), perhaps even checking fo=
r,
=C2=A0 whether the given value, may be accidentally a UUID or label, e.g.
=C2=A0 /dev/disk/by-uuid/*
- In case (b), continue to use the already used/active/assembled=C2=A0
=C2=A0 devices (because we must assume they actually belong together),
=C2=A0 refuse to do anything (including mounting, adding to a multi-device
=C2=A0 fs, starting rebuild, etc. pp.) with the others unless the user
=C2=A0 manually says so via device=3Dfoo,bar,baz

(2) is similar to (1), but I think we haven't discussed it already in depth=
.
The effects here are the same as above (i.e. accidental data corruption, or=
 possible attacks), but here they would happen if btrfs would ever automati=
cally assemble/add devices to an already active (possibly degraded) fs.
Examples:
- I have a degraded RAID6, one disk missing, the system is e.g.
=C2=A0 unattended and an attacker can plug in a USB stick with IDs that
=C2=A0 just match perfectly.
=C2=A0 If btrfs would then start to automatically add that newly appeared
=C2=A0 device to the fs, being happy about the fact that it can now start
=C2=A0 to rebuild, we'd have a problem.
=C2=A0 In that example, because the attacker may use that to get data out o=
f
=C2=A0 the system.
=C2=A0 Take the same example without an attacker, a sysadmin may just
=C2=A0 accidentally plug in wrong HDD, that should actually serve as
=C2=A0 backup... it would start to get written at (this is why many HW RAID
=C2=A0 controllers have auto-activation disabled).
- One has a *non-degraded* RAID1, and an attacker manages to plug a
=C2=A0 device with matching IDs...
=C2=A0 If then btrfs would be happy about being able to enlarge the RAID to
=C2=A0 one more device, and automatically start to use that new device,
=C2=A0 perhaps even starting a balance, then same problem as above.
Possible solutions:
Long story short, never do auto-assemblies (i.e. add to an already active f=
s) in multi-device scenarios.
That is, don't do it per default.
I'd be fine if it was an option, e.g. a kernel parameter or whatever that e=
nables btrfs to such auto assemblies, and if the documentation clearly expl=
ains the possible issues (especially security issues) implied by it.... but=
 it shouln't be the default.


- IMHO, a fs should be secure by default, thus I think, adding devices to a=
n already active fs (e.g. for rebuild), should never happen (by default) au=
tomatically.

- But perhaps it would be useful to have one additional option, which gener=
ally disables that (i.e. not just in case of already active devices).
That option would make it mandatory in *all* cases, that the user specifies=
 device=3D/dev/foo,/dev/bar.
That behaviour may be preferred for some special use cases, and having a tr=
ue option for it, may be better than just trying to get it by removing any =
udev scripts or so (which may get accidentally added back by the distro).





> PS: Kudos to C.A. Mitterer for discovering that problem
Thanks, guess I have a hand for thinking about such "higher-level"
attacks,... unfortunately=C2=A0in most cases the people aren't that open
about it as here :-/


Cheers,
Chris.
--=-I4+z9shvQu0j747iKhKG
Content-Type: application/x-pkcs7-signature; name="smime.p7s"
Content-Disposition: attachment; filename="smime.p7s"
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgMFADCABgkqhkiG9w0BBwEAAKCCEZIw
ggW/MIIDp6ADAgECAgMCOakwDQYJKoZIhvcNAQENBQAwVDEUMBIGA1UEChMLQ0FjZXJ0IEluYy4x
HjAcBgNVBAsTFWh0dHA6Ly93d3cuQ0FjZXJ0Lm9yZzEcMBoGA1UEAxMTQ0FjZXJ0IENsYXNzIDMg
Um9vdDAeFw0xNDA2MTIxNjM2MThaFw0xNjA2MTExNjM2MThaMHwxITAfBgNVBAMTGENocmlzdG9w
aCBBbnRvbiBNaXR0ZXJlcjEkMCIGCSqGSIb3DQEJARYVY2FsZXN0eW9Ac2NpZW50aWEubmV0MTEw
LwYJKoZIhvcNAQkBFiJtYWlsQGNocmlzdG9waC5hbnRvbi5taXR0ZXJlci5uYW1lMIIBIjANBgkq
hkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA4phP/j9vT9dZT+k3ffHxvRWMOuzBnu5O3Fl4y2+WL7pL
rfLiEhWzGXhHvjSqpt4vCNSdqy43453nnu8+hMb+uEtqSIL1AHU5eLhuDNVN9S4bt9E7nA2WKYBU
LCUi/xCD/GL7ToyJNwhrhzcCZ7pXSc3xVqFoC4f6weU9ExhoEZQNRpTM0BFCOi4fRxvKFNnUYgjK
hqy0Ta5H0Xx86mAp0Q4dxoD7mhI5iTF6TRkUheELxF24JCuAf04M89Cwft6DRH1FpJ3yvgW2B5U5
aFSL4ZnF4N/wyCB7Dkm1rQ7RCAvw5btkf0VdPnU7ccDCx8HEc2nxK/lbCjrznvh3sa1CCwIDAQAB
o4IBcDCCAWwwDAYDVR0TAQH/BAIwADBWBglghkgBhvhCAQ0ESRZHVG8gZ2V0IHlvdXIgb3duIGNl
cnRpZmljYXRlIGZvciBGUkVFIGhlYWQgb3ZlciB0byBodHRwOi8vd3d3LkNBY2VydC5vcmcwDgYD
VR0PAQH/BAQDAgOoMEAGA1UdJQQ5MDcGCCsGAQUFBwMEBggrBgEFBQcDAgYKKwYBBAGCNwoDBAYK
KwYBBAGCNwoDAwYJYIZIAYb4QgQBMDIGCCsGAQUFBwEBBCYwJDAiBggrBgEFBQcwAYYWaHR0cDov
L29jc3AuY2FjZXJ0Lm9yZzA4BgNVHR8EMTAvMC2gK6AphidodHRwOi8vY3JsLmNhY2VydC5vcmcv
Y2xhc3MzLXJldm9rZS5jcmwwRAYDVR0RBD0wO4EVY2FsZXN0eW9Ac2NpZW50aWEubmV0gSJtYWls
QGNocmlzdG9waC5hbnRvbi5taXR0ZXJlci5uYW1lMA0GCSqGSIb3DQEBDQUAA4ICAQBefctiLgGl
e5baspuozyA4k7Up7SVhGHbif6pQfoFc/9Thx9GXnYpX+U64PMyWBfWwHZIy52Vg0RVkvPi1t6mi
GyBfoSpC6ooR0bKWtUIogw/ymqKWlTLVR8kbLqRmRk4juMtCXG2K3yMygX/rjkuUSuFj2Bjpkmzg
CtMojbUMYbszePmhQ7DJ62YEdtKpcjN94QAsI5GWlIAbs3KJazAcaNCRJeXCLcUMchyKHJA+NXH5
az/ekBxBMBzJP2An20PP88UI4JW18z31KiG9UVGa2uO4l4aWgVe2GnhNEdCD/o48msJEWKAt5vl2
yMqr7ihmNPocU2+/FW0xPe/vftdOTD9pgXdSGf4prdD+23q2YvpalOCzr2p8yCJZNVBPMxAP4mL0
3OEktXza4wohqAmceXKfGUNwRGBaPvtIGnPrpLhCQ+2YJDg8g1UEsk23bKyZlJWeKJyVqOBsDJmj
aBsN/qKhQFnav+zQdqGhMeaSisF/53mD3gyVYg2JRl18apgGbg32kyLmomqa0JbhnY3Dc3FVtZfe
+P+s2Cyep3pVKvFer2llRoGm8TwraG5Yhyx8Oq/1qETpstjbURJOVBLDCV4AjOEUj0ZnE/tEo/DK
yexgGaViNvjp+IZdFdJhYmsVjw4Q3vG7O0pfsLiYEyQjeDgjNEWDfa5/MufPywIfxzCCBb8wggOn
oAMCAQICAwI5qTANBgkqhkiG9w0BAQ0FADBUMRQwEgYDVQQKEwtDQWNlcnQgSW5jLjEeMBwGA1UE
CxMVaHR0cDovL3d3dy5DQWNlcnQub3JnMRwwGgYDVQQDExNDQWNlcnQgQ2xhc3MgMyBSb290MB4X
DTE0MDYxMjE2MzYxOFoXDTE2MDYxMTE2MzYxOFowfDEhMB8GA1UEAxMYQ2hyaXN0b3BoIEFudG9u
IE1pdHRlcmVyMSQwIgYJKoZIhvcNAQkBFhVjYWxlc3R5b0BzY2llbnRpYS5uZXQxMTAvBgkqhkiG
9w0BCQEWIm1haWxAY2hyaXN0b3BoLmFudG9uLm1pdHRlcmVyLm5hbWUwggEiMA0GCSqGSIb3DQEB
AQUAA4IBDwAwggEKAoIBAQDimE/+P29P11lP6Td98fG9FYw67MGe7k7cWXjLb5Yvukut8uISFbMZ
eEe+NKqm3i8I1J2rLjfjneee7z6Exv64S2pIgvUAdTl4uG4M1U31Lhu30TucDZYpgFQsJSL/EIP8
YvtOjIk3CGuHNwJnuldJzfFWoWgLh/rB5T0TGGgRlA1GlMzQEUI6Lh9HG8oU2dRiCMqGrLRNrkfR
fHzqYCnRDh3GgPuaEjmJMXpNGRSF4QvEXbgkK4B/Tgzz0LB+3oNEfUWknfK+BbYHlTloVIvhmcXg
3/DIIHsOSbWtDtEIC/Dlu2R/RV0+dTtxwMLHwcRzafEr+VsKOvOe+HexrUILAgMBAAGjggFwMIIB
bDAMBgNVHRMBAf8EAjAAMFYGCWCGSAGG+EIBDQRJFkdUbyBnZXQgeW91ciBvd24gY2VydGlmaWNh
dGUgZm9yIEZSRUUgaGVhZCBvdmVyIHRvIGh0dHA6Ly93d3cuQ0FjZXJ0Lm9yZzAOBgNVHQ8BAf8E
BAMCA6gwQAYDVR0lBDkwNwYIKwYBBQUHAwQGCCsGAQUFBwMCBgorBgEEAYI3CgMEBgorBgEEAYI3
CgMDBglghkgBhvhCBAEwMgYIKwYBBQUHAQEEJjAkMCIGCCsGAQUFBzABhhZodHRwOi8vb2NzcC5j
YWNlcnQub3JnMDgGA1UdHwQxMC8wLaAroCmGJ2h0dHA6Ly9jcmwuY2FjZXJ0Lm9yZy9jbGFzczMt
cmV2b2tlLmNybDBEBgNVHREEPTA7gRVjYWxlc3R5b0BzY2llbnRpYS5uZXSBIm1haWxAY2hyaXN0
b3BoLmFudG9uLm1pdHRlcmVyLm5hbWUwDQYJKoZIhvcNAQENBQADggIBAF59y2IuAaV7ltqym6jP
IDiTtSntJWEYduJ/qlB+gVz/1OHH0Zedilf5Trg8zJYF9bAdkjLnZWDRFWS8+LW3qaIbIF+hKkLq
ihHRspa1QiiDD/KaopaVMtVHyRsupGZGTiO4y0JcbYrfIzKBf+uOS5RK4WPYGOmSbOAK0yiNtQxh
uzN4+aFDsMnrZgR20qlyM33hACwjkZaUgBuzcolrMBxo0JEl5cItxQxyHIockD41cflrP96QHEEw
HMk/YCfbQ8/zxQjglbXzPfUqIb1RUZra47iXhpaBV7YaeE0R0IP+jjyawkRYoC3m+XbIyqvuKGY0
+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
AukCAQEwWzBUMRQwEgYDVQQKEwtDQWNlcnQgSW5jLjEeMBwGA1UECxMVaHR0cDovL3d3dy5DQWNl
cnQub3JnMRwwGgYDVQQDExNDQWNlcnQgQ2xhc3MgMyBSb290AgMCOakwDQYJYIZIAWUDBAIDBQCg
ggFjMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTE1MTIxMTIyMDYw
M1owTwYJKoZIhvcNAQkEMUIEQN4Vz5z/6fygfl7BrniIRHGoZ0yYIe8EQ9KfUYnM+/dPOzMzzDEl
dcTHLcB/K3lt8+VCOYSQ3tm0IwxOceobmUEwagYJKwYBBAGCNxAEMV0wWzBUMRQwEgYDVQQKEwtD
QWNlcnQgSW5jLjEeMBwGA1UECxMVaHR0cDovL3d3dy5DQWNlcnQub3JnMRwwGgYDVQQDExNDQWNl
cnQgQ2xhc3MgMyBSb290AgMCOakwbAYLKoZIhvcNAQkQAgsxXaBbMFQxFDASBgNVBAoTC0NBY2Vy
dCBJbmMuMR4wHAYDVQQLExVodHRwOi8vd3d3LkNBY2VydC5vcmcxHDAaBgNVBAMTE0NBY2VydCBD
bGFzcyAzIFJvb3QCAwI5qTANBgkqhkiG9w0BAQEFAASCAQCqRi34Mfa8sermAWpoJbAVbWir+Pq1
EaVMMT4X963Z763Y6pvg+PcnsE24rNt/YXVtonZslGnQpkIU8iqEUoLq5DJLK8HRt7AfWRZ2rIIE
J1sYTbq91uTi+l3XaNKZ49pyVTqfAWL3JLmqvkhpgAJAdgvfy5gSEoQ1awR7SfxGijmgJDwPiydc
dkwEmtWYHrgC6DZRF2PfPgUGvZIWKHx9/QQio+9Sng8c2/vOLEWGiD1Ctd85DmkkgNVuKWuvkRKJ
GVziTE8Bgft09KyHFi+VygQczWkFK4cXg0L/stAz8k0qCaV9NvswgMm9n6ETV9Jn7hUCIvWLKxeE
cjea/pJ5AAAAAAAA


--=-I4+z9shvQu0j747iKhKG--

