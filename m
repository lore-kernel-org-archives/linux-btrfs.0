Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailgw-02.dd24.net ([193.46.215.43]:38836 "EHLO
	mailgw-02.dd24.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624AbbLNCqG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 13 Dec 2015 21:46:06 -0500
Message-ID: <1450061161.2388.66.camel@scientia.net>
Subject: Re: [auto-]defrag, nodatacow - general suggestions?(was: btrfs:
 poor performance on deleting many large files?)
From: Christoph Anton Mitterer <calestyo@scientia.net>
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
Date: Mon, 14 Dec 2015 03:46:01 +0100
In-Reply-To: <pan$ab79a$6d00d5c9$95504338$ca8d2761@cox.net>
References: <CA+ve2MYBAPbLPiX4i2oZeDeu+9=JurXHsx5fMef2iV3rRrCKxg@mail.gmail.com>
	 <56530DAD.9080607@gmail.com> <1448497439.28195.33.camel@scientia.net>
	 <20151126003342.GA24333@carfax.org.uk>
	 <1449639781.7835.3.camel@scientia.net>
	 <pan$ab79a$6d00d5c9$95504338$ca8d2761@cox.net>
Content-Type: multipart/signed; micalg="sha-512";
	protocol="application/x-pkcs7-signature";
	boundary="=-FH3EBVYyfavoJDv7oSFT"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--=-FH3EBVYyfavoJDv7oSFT
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2015-12-09 at 13:36 +0000, Duncan wrote:
> Answering the BTW first, not to my knowledge, and I'd be
> skeptical.=C2=A0=C2=A0In=20
> general, btrfs is cowed, and that's the focus.=C2=A0=C2=A0To the extent t=
hat
> nocow=20
> is necessary for fragmentation/performance reasons, etc, the idea is
> to=20
> try to make cow work better in those cases, for example by working on
> autodefrag to make it better at handling large files without the
> scaling=20
> issues it currently has above half a gig or so, and thus to confine
> nocow=20
> to a smaller and smaller niche use-case, rather than focusing on
> making=20
> nocow better.
> Of course it remains to be seen how much better they can do with=20
> autodefrag, etc, but at this point, there's way more project=20
> possibilities than people to develop them, so even if they do find
> they=20
> can't make cow work much better for these cases, actually working on
> nocow=20
> would still be rather far down the list, because there's so many
> other=20
> improvement and feature opportunities that will get the focus
> first.=C2=A0=C2=A0
> Which in practice probably puts it in "it'd be nice, but it's low
> enough=20
> priority that we're talking five years out or more, unless of course=20
> someone else qualified steps up and that's their personal itch they
> want=20
> to scratch", territory.
I guess I'll split out my answer on that, in a fresh thread about
checksums for nodatacow later, hoping to attract some more devs there
:-)

I think however, again with my naive understanding on how CoW works and
what it inherently implies, that there cannot be a real good solution
to the fragmentation problem for DB/etc. files.

And as such, I'd think that having a checksumming feature for
notdatacow as well, even if it's not perfect, is definitely worth it.


> As for the updated checksum after modification, the problem with that
> is=20
> that in the mean time, the checksum wouldn't verify,
Well one could either implement some locking,.. but I don't see the
general problem here... if the block is still being written (and I
count updating the meta-data, including checksum, to that) it cannot be
read anyway, can it? It may be only half written and the data returned
would be garbage.


>  and while btrfs=20
> could of course keep status in memory during normal operations,
> that's=20
> not the problem, the problem is what happens if there's a crash and
> in-
> memory state vaporizes.=C2=A0=C2=A0In that case, when btrfs remounted, it=
'd
> have no=20
> way of knowing why the checksum didn't match, just that it didn't,
> and=20
> would then refuse access to that block in the file, because for all
> it=20
> knows, it /is/ a block error.
And this would only happen in the rare cases that anything crashes,
where it's anyway quite likely that this no-CoWed block will be
garbage.
I'll talk about that more in the separate thread... so let's move
things there.


> Same here.=C2=A0=C2=A0In fact, my most anticipated feature is N-way-mirro=
ring,=20
Hmm ... not totally sure about that...
AFAIU, N-way-mirroring is what currently the currently wrongly called
RAID1 is in btrfs, i.e. having N replicas of everything on M devices,
right?
In other words, not being a N-parity-RAID and not guaranteeing that
*any* N disks could fail, right?

Hmm I guess that would be definitely nice to have, especially since
then we could have true RAID1, i.e. N=3DM.

But it's probably rather important for those scenarios, where either
resilience matters a lot... and/or =C2=A0 those where write speed doesn't
but read speed does, right?

Taking the example of our use case at the university, i.e. the LHC
Tier-2 we run,... that would rather be uninteresting.
We typically have storage nodes (and many of them) of say 16-24
devices, and based on funding constraints, resilience concerns and IO
performance, we place them in RAID6 (yeah i know, RAID5 is faster, but
even with hotspares in place, practise lead too often to lost RAIDs).

Especially for the bigger nodes, with more disks, we'd rather have a N-
parity RAID, where any N disks can fail)... of course performance
considerations may kill that desire again ;)


> It is a big and basic feature, but turning it off isn't the end of
> the=20
> world, because then it's still the same level of reliability other=20
> solutions such as raid generally provide.
Sure... I never meant it as "loss to what we already have in other
systems"... but as "loss compared to how awesome[0] btrfs could be ;-)"


> But as it happens, both VM image management and databases tend to
> come=20
> with their own integrity management, in part precisely because the=20
> filesystem could never provide that sort of service.
Well that's only partially true, to my knowledge.
a) I wouldn't know that hypervisors do that at all.
b) DBs have of course their journal, but that protects only against
crashes,... not against bad blocks nor does it help you to decide which
block is good when you have multiple.


> After all, you can always decide not to run it if you're worried
> about the space effects it's going to have
Hmm well,... and the manpage actually mentions that it blows up when
snapshots are used... at least in some technical language...
So,.. you're possibly right, here,... though I guess many may just do=C2=A0
btrfs filesystem --help which looses no word about the possible grave
effects of defrag.


> But even at that point, while snapshot-aware-defrag is still on the
> list, =C2=A0I'm not sure if it's ever going to be actually viable.=C2=A0=
=C2=A0It may
> be that the scaling issues are just too big, and it simply can't be
> made to work =C2=A0both correctly and in anything approaching practical
> time.
Well, I shall hope not
:)


> Worst-case, you =C2=A0set nocow and turn off snapshotting, but that's=C2=
=A0
> exactly the situation
> you're in anyway with other filesystems, so you're no worse off than
> if you were using them.
> Meanwhile, where those btrfs features *can* be used, which is on
> /most/=20
> files, with only limited exceptions, it's all upside! =3D:^)
Sure :D ... but that doesn't mean we should try do minimise the upside
cases if possible :-)


> FWIW, I've seen it asserted that autodefrag is snapshot aware a few
> times=20
> now, but I'm not personally sure that is the case and I don't see any
> immediately obvious reason it would be, when (manual) defrag isn't,
> so=20
> I've refrained from making that claim, myself.=C2=A0=C2=A0If I were to se=
e
> multiple=20
> devs make that assertion, I'd be more confident, but I believe I've
> only=20
> seen it from Hugo, and while I trust him in general because in
> general=20
> what he says makes sense, here, as I said, it just doesn't make
> immediate=20
> sense to me that the two would be so different
Yes, that was my concern as well...


> The biggest downside of autodefrag is its performance on large
> (generally=20
> noticeable at between half a gig and a gig) random-rewrite-pattern
> files=20
> in actively-being-rewritten use.=C2=A0=C2=A0For all other cases it's gene=
rally=20
> recommended, but that's why it's not the default.
Hmm that makes it a bit difficult to use when you have mixed use cases.
Can't they just add a feature that allows one to select up to which
file sizes autodefrag kicks in.

Interestingly, I've enabled it now, and as I've mentioned before I run
several VMs on that machine (which has a SSD), so far intentionally not
set nodatacow... however, so far I don't see any aggressive rewriting,
though admittedly, I wouldn't know how to properly tell whether auto-
defrag was doing heavy IO or not, it doesn't show up as a kernel thread
it seems.

> AFAIK autodefrag only queues up the defrag when it detects
> fragmentation=20
> beyond some threshold, and it only checks and thus only detects at
> file=20
> (re)write.
Sounds reasonable... especially I wouldn't want the situation in which
it basically constantly rewrites files, just because of few fragments.

Another case however, could be more tricky do detect: Files which
continuously and quickly fragment at whole or at least in parts.
AFAIU, it would basically not make any sense to try any defrag on such
(because of the "it quickly fragments" again).

Also it would be nice to have some knobs to control in more detail how
much IO it spends on autodefrag, perhaps even on a per fs basis or even
more detailed.


> Further, when a filesystem is highly fragmented and autodefrag is
> first=20
> turned on, often it actually rather negatively affects performance
> for a=20
> few days, because so many files are so fragmented that it's queuing
> up=20
> defrags for nearly everything written.
I've read that advice of your's before... so you basically think it
would also queue up files that are fragmented, even when these are not
written to since it was turned on.

Interestingly, I did turn it on just a few days, and so far I haven't
seem much disk activity that would point to autodefrag.



Thanks again for your time and answers :)
Chris.


[0] In Germany there's the term "eierlegende Wollmilchsau", it
basically describes a pig, which gives milk, eggs and wool... perhaps
one can translate it with "jack of all trades device".
(No I don't want btrfs, to include a webbrowser and PDF reader ;) )
--=-FH3EBVYyfavoJDv7oSFT
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
ggFjMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTE1MTIxNDAyNDYw
MVowTwYJKoZIhvcNAQkEMUIEQL2pBKbld+oJchLTuwVTm15T3XZP16Tb534Q717mtgusxMDbFCkF
nulu07WN6gArASOxYKac9fbPT33335gHfcQwagYJKwYBBAGCNxAEMV0wWzBUMRQwEgYDVQQKEwtD
QWNlcnQgSW5jLjEeMBwGA1UECxMVaHR0cDovL3d3dy5DQWNlcnQub3JnMRwwGgYDVQQDExNDQWNl
cnQgQ2xhc3MgMyBSb290AgMCOakwbAYLKoZIhvcNAQkQAgsxXaBbMFQxFDASBgNVBAoTC0NBY2Vy
dCBJbmMuMR4wHAYDVQQLExVodHRwOi8vd3d3LkNBY2VydC5vcmcxHDAaBgNVBAMTE0NBY2VydCBD
bGFzcyAzIFJvb3QCAwI5qTANBgkqhkiG9w0BAQEFAASCAQA4SJOyrw0ZR8cTKKFHO9M3GPG480vg
5Ot+q5rgdpGfjspbBMsJ71vHk/AaKOJLw7iYWsOx7V4smq1rOkRy70cYezWtvfyK7m0GFqPWSImq
H1oIR+htpCr8JuarqEPhb7A1AQFQA3oYUNcihVIdufXTcCH8+k9u8cYAG7/eOaIs/lA9Wd9uICuo
TisbFtxxGNYh0X8BAy6ci1LWgakKq9MfCJS2DrQ2VZWuyneW0FhQNSLAA2RroEUImNyLZ3Dj6BJc
XQRqekyERGLPlmGpg5AablxdON4CAOnJ7CvMbuUlwIZbNnziljZYNwUHsVK55/6hn2VeZxU1c9Q/
tnWTiqneAAAAAAAA


--=-FH3EBVYyfavoJDv7oSFT--

