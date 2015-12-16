Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailgw-01.dd24.net ([193.46.215.41]:38219 "EHLO
	mailgw-01.dd24.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934103AbbLPM43 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Dec 2015 07:56:29 -0500
Message-ID: <1450270585.6259.49.camel@scientia.net>
Subject: Re: attacking btrfs filesystems via UUID collisions?
From: Christoph Anton Mitterer <calestyo@scientia.net>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Date: Wed, 16 Dec 2015 13:56:25 +0100
In-Reply-To: <5670218C.2010104@gmail.com>
References: <20151204120529.37E47D5A28@emkei.cz>
	 <20151204130758.GR8775@carfax.org.uk>
	 <1449286104.18841.14.camel@scientia.net>
	 <pan$7e229$ce87d3b$b8d75c44$337e15c7@cox.net>
	 <1449366680.3183.37.camel@scientia.net> <56644785.4090702@gmx.com>
	 <1449639588.7835.2.camel@scientia.net> <5668A1CB.1020007@anonym.com>
	 <CAJCQCtQCoi52o2REWZGObq-19EpgCv+7QmKvP=Gvk1myVq-+_g@mail.gmail.com>
	 <1449872498.31388.74.camel@fo>
	 <CAJCQCtSXkXs0jQ=zaP6FJvRZS0yvz5CrjP8a06K0+htG5H8LTg@mail.gmail.com>
	 <1450052868.30943.27.camel@scientia.net> <566EC2D7.3000101@gmail.com>
	 <1450138105.701.24.camel@scientia.net> <5670218C.2010104@gmail.com>
Content-Type: multipart/signed; micalg="sha-512";
	protocol="application/x-pkcs7-signature";
	boundary="=-lb0Gh9SEG9fvY0N7XXUx"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--=-lb0Gh9SEG9fvY0N7XXUx
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2015-12-15 at 09:19 -0500, Austin S. Hemmelgarn wrote:
> Um, no you don't have direct physical access to the hardware with an
> ATM, at least, not unless you are going to take apart the cover and=20
> anything else in your way (and probably set off internal alarms).
Well access to the services ports (which may be USB) is typically much
easier, and doesn't require to completely dismantle the steel and so...
Simply because service teams also need to access these "regularly".

But even if we don't count ATMs here, use any other publicly accessible
computer terminals.
Library computer, the entertainment systems in airplanes, TVs in a
shopping centre, etc. pp.


> =C2=A0=C2=A0And=20
> even without that, it's still possible to DoS an ATM without much=20
> effort.=C2=A0=C2=A0Most of them have a 3.5mm headphone jack for TTS for p=
eople=20
> with poor vision, and that's more than enough to overload at least
> part=20
> of the system with a relatively simple to put together bit of=20
> electronics that would cost you less than 10 USD.
As I've said before,.. you always find another weak link, of course,...
as it was pointed out before, USB itself is quite a security problem
(firmware attacks and that like).

But just because there are other issues, right now, there is no
justification to make btrfs "weak" as well... because this just leads
to the=C2=A0vicious circle, that everyone has security issues, not willing
to solve them, pointing to others as an excuse.


> > imageine you're running a VM hosting service, where you allow users
> > to
> > upload images and have them deployed.
> > In the cheap" case these will end up as regular files, where they
> > couldn't do any harm (even if colliding UUIDs)... but even there
> > one
> > would have to expect, that the hypervisor admin may losetup them
> > for
> > whichever reason.
> > But if you offer more professional services, you may give your
> > clients
> > e.g. direct access to some storage backend, which are then probably
> > also seen on the host by its kernel.
> > And here we already have the case, that a client could remotely
> > trigger
> > such collision.
> In that particular situation, it's not relevant unless the host admin
> goes to mount them.=C2=A0=C2=A0UUID collisions are only an issue if the=
=20
> filesystems get mounted.
Hmm from the impression I got so far, it was not only a problem when
actually mounting... but even if... this doesn't change the situation.
Same problem as before, the host system may have btrfs filesystems
whose IDs have leaked, the attacker may upload them as VM images as
described above, and even if the host's admin doesn't want to mount
those, he may mount what he considers his filsystems, which however
also collide.
Boom. Same issues as before.

Turn it as you want, resistance is futile ;-)


> > Well I think it's a proper way to e.g. handle the multi-device
> > case.
> > You have n devices, you want to differ them,... using a pseudo-
> > random
> > UUID is surely better than giving them numbers.
> That's debatable, the same issues are obviously present in both cases
> (individual numbers can collide too).
Sure, as I've said. You always must handle the case of accidentally or
maliciously colliding IDs if you count on data integrity and security.
But using UUIDs makes chances at least small that you run into
collisions (that users must than manually resolve somehow) *even when*
you just create fresh filesystem, have no attacker and no dd or that
like goes in your way.


> > Same for the fs UUID, e.g. when used for mounting devices whose
> > paths
> > aren't stable.
> In the case of a sanely designed system using LVM for example, device
> paths are stable.
Well, but LVM itself works with UUIDs again, so you just delegate the
problem.
And apart from that, with btrfs, I thought, we rather want to avoid
using LVM below.


> > As said before, using the UUID isn't the problem - not protecting
> > against collisions is.
> No, the issues are:
> 1. We assume that the UUID will be unique for the life of the=20
> filesystem, which is not a safe assumption.
> 2. We don't sanely handle things if it isn't unique.
Well isn't that what I've said? At least it's what I've meant ;)


> > Well,... I don't think that writing *into* the filesystem is
> > covered by
> > common practise anymore.
> For end users, I agree.=C2=A0=C2=A0Part of the discussion involves attack=
s on
> the=20
> system, and for a attacker it's not a far stretch to write directly
> to=20
> the block device if possible (and it's even common practice for=20
> bypassing permission checks done in the VFS layer).
Well but that's something else here what I don't think we can cover.
What we must assume is, that devices show up with colliding IDs, either
by "accident" or means like dd... or by an attacker somehow being able
to make them show up (USB, the image upload scenarios I've described
before, and so on).

If the attacker can however write to *arbitrary* (and not just "his")
devices, bypassing checks in the VFS layer or anything else... well
than game over.
He wouldn't need bothering to do a probably compelx attack based on
btrfs colliding UUIDs - he could simply overwrite the root filesystem
and reboot with his own malicious kernel/etc.


> My point is that by changing the UUID in a superblock (and properly=20
> updating the checksum for the superblock), you can trivially break a=20
> multi-device filesystem.=C2=A0=C2=A0And it's a whole lot easier to do tha=
t than
> it=20
> is to do the equivalent for LVM.
I'm a bit unsure what you try to show:
- Arbitrarily writing into a device (e.g. in the superblock) is IMHO
=C2=A0 not common practise, an not justified by common or historical use.
- If one does however do it (and it doesn't matter if the admin does it
=C2=A0 or an attacker), one would of course end up in the situation, where
=C2=A0 btrfs should detect this, and refuse mounting, fsck'ing, and that
=C2=A0 like.
=C2=A0 Problem solved.



Cheers,
Chris.

--=-lb0Gh9SEG9fvY0N7XXUx
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
ggFjMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTE1MTIxNjEyNTYy
NVowTwYJKoZIhvcNAQkEMUIEQMqYI+4Feqn2OU05aSczlB1C+R4gWQukR15E+E9tYm95RKnF1VGM
9a1Ff50t5UVKhmqRx7t2rZB57+bV4Fdz56IwagYJKwYBBAGCNxAEMV0wWzBUMRQwEgYDVQQKEwtD
QWNlcnQgSW5jLjEeMBwGA1UECxMVaHR0cDovL3d3dy5DQWNlcnQub3JnMRwwGgYDVQQDExNDQWNl
cnQgQ2xhc3MgMyBSb290AgMCOakwbAYLKoZIhvcNAQkQAgsxXaBbMFQxFDASBgNVBAoTC0NBY2Vy
dCBJbmMuMR4wHAYDVQQLExVodHRwOi8vd3d3LkNBY2VydC5vcmcxHDAaBgNVBAMTE0NBY2VydCBD
bGFzcyAzIFJvb3QCAwI5qTANBgkqhkiG9w0BAQEFAASCAQCAJgi5VShddClHnFwer+DDGYlJcUaq
2T4RjSXZVBpo/k45o9MziWdyZU3xOuGXwrfMqV1yI9+dpLl7BYnyn9m3haohROr7bQlv9kGTEu7t
etks95q7hoDYkfvwWYVa9MTWVC4aVE7RXkfZrPgsXSbULwZg7f7xn6q5yEDkJO8EMyq+qyibRwsv
pcNQeRZXj37AdlKmSTLTUlE2S2C6H3VwH5nhz2Cj8npnAcnXzD0yoeubGwjgdqqAL2TgZFEZ8CYt
ny/IWOKBXgB5/pjyQxTVEl2gFFHJPLewoetXgBS+P2uMY72W+oYAPgbKDRUmLIlVNIxSdRQOak9+
CssoRed7AAAAAAAA


--=-lb0Gh9SEG9fvY0N7XXUx--

