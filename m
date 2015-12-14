Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailgw-02.dd24.net ([193.46.215.43]:45439 "EHLO
	mailgw-02.dd24.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265AbbLNE7W (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 13 Dec 2015 23:59:22 -0500
Received: from mailpolicy-01.live.igb.homer.key-systems.net (mailpolicy-02.live.igb.homer.key-systems.net [192.168.1.27])
	by mailgw-02.dd24.net (Postfix) with ESMTP id 44F065FC5D
	for <linux-btrfs@vger.kernel.org>; Mon, 14 Dec 2015 04:59:21 +0000 (UTC)
Received: from mailgw-02.dd24.net ([192.168.1.36])
	by mailpolicy-01.live.igb.homer.key-systems.net (mailpolicy-02.live.igb.homer.key-systems.net [192.168.1.25]) (amavisd-new, port 10236)
	with ESMTP id vnRm6D8c_t03 for <linux-btrfs@vger.kernel.org>;
	Mon, 14 Dec 2015 04:59:19 +0000 (UTC)
Received: from heisenberg.fritz.box (ppp-93-104-122-99.dynamic.mnet-online.de [93.104.122.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by mailgw-02.dd24.net (Postfix) with ESMTPSA
	for <linux-btrfs@vger.kernel.org>; Mon, 14 Dec 2015 04:59:18 +0000 (UTC)
Message-ID: <1450069158.2388.72.camel@scientia.net>
Subject: dear developers, can we have notdatacow + checksumming, plz?
From: Christoph Anton Mitterer <calestyo@scientia.net>
To: linux-btrfs@vger.kernel.org
Date: Mon, 14 Dec 2015 05:59:18 +0100
Content-Type: multipart/signed; micalg="sha-512";
	protocol="application/x-pkcs7-signature";
	boundary="=-czfw9mdPangjpJ+rY15c"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--=-czfw9mdPangjpJ+rY15c
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

(consider that question being asked with that face on:=C2=A0http://goo.gl/L=
QaOuA)

Hey.

I've had some discussions on the list these days about not having
checksumming with nodatacow (mostly with Hugo and Duncan).

They both basically told me it wouldn't be straight possible with CoW,
and Duncan thinks it may not be so much necessary, but none of them
could give me really hard arguments, why it cannot work (or perhaps I
was just too stupid to understand them ^^)... while at the same time I
think that it would be generally utmost important to have checksumming
(real world examples below).

Also, I remember that in 2014, Ted Ts'o told me that there are some
plans ongoing to get data checksumming into ext4, with possibly even
some guy at RH actually doing it sooner or later.

Since these threads were rather admin-work-centric, developers may have
skipped it, therefore, I decided to write down some thoughts&ideas
label them with a more attracting subject and give it some bigger
attention.
O:-)




1) Motivation why, it makes sense to have checksumming (especially also
in the nodatacow case)


I think of all major btrfs features I know of (apart from the CoW
itself and having things like reflinks), checksumming is perhaps the
one that distinguishes it the most from traditional filesystems.

Sure we have snapshots, multi-device support and compression - but we
could have had that as well with LVM and software/hardware RAID... (and
ntfs supported compression IIRC ;) ).
Of course, btrfs does all that in a much smarter way, I know, but it's
nothing generally new.
The *data* checksumming at filesystem level, to my knowledge, is
however. Especially that it's always verified. Awesome. :-)


When one starts to get a bit deeper into btrfs (from the admin/end-user=20
side) one sooner or later stumbles across the recommendation/need to
use nodatacow for certain types of data (DBs, VM images, etc.) and the
reason, AFAIU, being the inherent fragmentation that comes along with
the CoW, which is especially noticeable for those types of files with
lots of random internal writes.

Now duncan implied, that this could improve in the future, with the
auto-defragmentation getting (even) better, defrag becoming usable
again for those that do snapshots or reflinked copies and btrfs itself
generally maturing more and more.
But I kinda wonder to what extent one will be really able to solve
that, what seems to me a CoW-inherent "problem",...
Even *if* one can make the auto-defrag much smarter, it would still
mean that such files, like big DBs, VMs, or scientific datasets that
are internally rewritten, may get more or less constantly defragmented.
That may be quite undesired...
a) for performance reasons (when I consider our research software which
often has IO as the limiting factor and where we want as much IO being
used by actual programs as possible)...
b) SSDs...
Not really sure about that; btrfs seems to enable the autodefrag even
when an SSD is detected,... what is it doing? Placing the block in a
smart way on different chips so that accesses can be better
parallelised by the controller?
Anyway, (a) is could be already argument enough, not to run solve the
problem by a smart-[auto-]defrag, should that actually be implemented.

So I think having notdatacow is great and not just a workaround till
everything else gets better to handle these cases.
Thus, checksumming, which is such a vital feature, should also be
possible for that.


Duncan also mention that in some of those cases, the integrity is
already protected by the application layer, making it less important to
have it at the fs-layer.
Well, this may be true for file-sharing protocols, but I wouldn't know
that relational DBs really do cheksuming of the data.
They have journals, of course, but these protect against crashes, not
against silent block errors and that like.
And I wouldn't know that VM hypervisors do checksuming (but perhaps
I've just missed that).

Here I can give a real-world example, from the Tier-2 that I run for
LHC at work/university.
We have large amounts of storage (perhaps not as large as what Google
and Facebook have, or what the NSA stores about us)... but it's still
some ~ 2PiB, or a bit more.
That's managed with some special storage management software called
dCache. dCache even stores checksums, but per file, so that means for
normal reads, these cannot be verified (well technically it's
supported, but with our usual file sizes, this is not working) so what
remains are scrubs.
For The two PiB, we have some... roughly 50-60 nodes, each with
something between 12 and 24 disks, usually in either one or two RAID6
volumes, all different kinds of hard disks.
And we do run these scrubs quite rarely, since it costs IO that could
be used for actual computing jobs (a problem that wouldn't be there
with how btrfs calculates the sums on read, the data is then read
anyway)... so likely there are even more errors that are just never
noticed, because the datasets are removed again, before being scrubbed.


Long story short, it does happen every now and then, that a scrub shows
file errors, for neither the RAID was broken, nor there were any block
errors reported by the disks, or anything suspicious in SMART.
In other words, silent block corruption.

One may rely on the applications to do integrity protection, but I
think that's not realistic, and perhaps that shouldn't be their task
anyway (at least not when it's about storage device block errors and
that like).

I don't think it's on the horizon that things like DBs or large
scientific data files do their own integrity protection (i.e. one that
protects against bad blocks, and not just journalling that preserves
consistency in case of crashes).
And handling that on the fs level is anyway quite nice, I think.
It doesn't mean that countless applications need to handle this on the
application layer, making it configurable whether it should be enabled
(for integrity protection) or disabled (for more speed), each of them
writing a lot of code for that.
If we can control that on the fs layer, by setting datasum/nodatasum,
all needed is already there - except, that as of now, nodatacowed stuff
is excluded in btrfs.





2) Technical


Okay the following is obviously based on my naive view of how things
could work, which may not necessarily go well with how an actual fs
developer sees things ;-)

As said in the introduction, I can't quite believe that data
checksumming should in principle be possible for ext4, but not for
btrfs non-CoWed parts.


Duncan&Hugo said, the reason is basically it cannot do checksums with
no-CoW, because there's no guarantee that the fs doesn't end up
inconsistently...

But, AFAIU, not doing CoW, while not having a journal (or does it have
one for these cases???) almost certainly means that the data (not
necessarily the fs) will be inconsistent in case of a crash during a
no-CoWed write anyway, right?
Wouldn't it be basically like ext2?

Or we have the case of multi-device, e.g. RAID1, multiple copies of the
same blocks, a crash has happened during writing such (no-CoWed and no-
checksummed)...
Again it's almost certainly that at least one (maybe even both) of the
blocks contains garbage and likely (at least a 50% chance) we get that
one when the actual read happens later (I was told btrfs would behave
in these cases like e.g MD RAID does,... deliver what the first
readable block said).

If btrfs would calculate checksums and write them e.g. after or before
the actual data was written,... what would be the worst that could
happen (in my naive understanding of course ;-) ) at a crash?
- I'd say either one is lucky, and checksum and data matches.
=C2=A0 Yay.
- Or it doesn't match, which could boil down to the following two
=C2=A0 cases:
=C2=A0 - the data wasn't written out correctly and is actually garbage
=C2=A0=C2=A0=C2=A0=C2=A0=3D> then we can be happy, that the checksum wouldn=
't match and we'd=C2=A0
=C2=A0 =C2=A0 =C2=A0 =C2=A0get an error
=C2=A0 - the data was written out correctly, but before the csum was
=C2=A0=C2=A0=C2=A0=C2=A0written the system crashed, so the csum would now t=
ell us that the
=C2=A0=C2=A0=C2=A0=C2=A0block is bad, while in reality it isn't.
=C2=A0 =C2=A0 or the other way round:
=C2=A0 =C2=A0 the csum was written out (completely)... and no data was writ=
ten
=C2=A0 =C2=A0 at all before the system crashed (so the old block would be s=
till=C2=A0
=C2=A0 =C2=A0 completely there)
=C2=A0=C2=A0=C2=A0=C2=A0=3D> in both cases: so what? Having that particular=
 case happening
=C2=A0 =C2=A0 =C2=A0 =C2=A0is probably far less likely, than csumming actua=
lly detecting a
=C2=A0 =C2=A0 =C2=A0 =C2=A0bad block, or not completely written data in cas=
e of a crash.
=C2=A0 =C2=A0 =C2=A0 =C2=A0(Not to talk about all the cases where nothing c=
rashes, and
=C2=A0 =C2=A0 =C2=A0 =C2=A0where we simply would want to detect block error=
s, bus errors,
=C2=A0 =C2=A0 =C2=A0 =C2=A0etc.)
=3D> Of course it wouldn't be as nice as in CoW, where it could
=C2=A0 =C2=A0simply take the most recent consistent state of that block, bu=
t
=C2=A0 =C2=A0still way better than:
=C2=A0 =C2=A0- delivering bogus data to the application in n other cases
=C2=A0 =C2=A0- not being able to decide which of m block copies is valid, i=
f a
=C2=A0 =C2=A0 =C2=A0RAID is scrubbed

And as said before, AFAIU, nodatacow'ed files have no journal in btrfs
as in ext3/4, so it's basically anyway that such files, when written
during a crash, may end up in any state, right? Which makes not having
a csum sound even worse, since nothing tells that this file is possibly
bad.


Not having checksumming seems to be especially bad in the multi-device
case... what happens when one runs a scrub? AFAIU, it simply does what
e.g. MD does: taking the first readable block, writing it to any
others, thereby possibly destroying the actually good one?



Not sure about whether the following would make any practical sense:
If data checksumming would work for nodatacow, then maybe some people
may even choose to run btrfs in CoW1 mode,.. they still could have most
fancy features from btrfs (checksumming, snapshots, perhaps even
refcopy?) but unless snapshots or refcopies are explicitly made, btrfs
doesn't do CoW.


Well, thanks for spending (hopefully not wasting ;-) ) your time on
reading my X-Mas wish ;)

Cheers,
Chris.
--=-czfw9mdPangjpJ+rY15c
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
ggFjMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTE1MTIxNDA0NTkx
OFowTwYJKoZIhvcNAQkEMUIEQAuThl9Bh/aoP5e9M2HBzzW/nXvxOwsHMe5FHf1amLzbu/2OWzuA
GVdgOjDnWzGMvBf2lNFg1BP6iQEzecFSaKQwagYJKwYBBAGCNxAEMV0wWzBUMRQwEgYDVQQKEwtD
QWNlcnQgSW5jLjEeMBwGA1UECxMVaHR0cDovL3d3dy5DQWNlcnQub3JnMRwwGgYDVQQDExNDQWNl
cnQgQ2xhc3MgMyBSb290AgMCOakwbAYLKoZIhvcNAQkQAgsxXaBbMFQxFDASBgNVBAoTC0NBY2Vy
dCBJbmMuMR4wHAYDVQQLExVodHRwOi8vd3d3LkNBY2VydC5vcmcxHDAaBgNVBAMTE0NBY2VydCBD
bGFzcyAzIFJvb3QCAwI5qTANBgkqhkiG9w0BAQEFAASCAQDb6E3HAoFwUfaNF8h7uWcOCghpJiKm
ZS4PfYmX1nrQeeiixiY0A9upchEJlP0XnI6dj+UbNPKkGy3DZFbACv97NDYtT1e4v04Lbb+FfTik
z0T8C1qN4PzFrn7sIAtIPmVDxzmgD373UKNjOUU4ytMT2oWKd6M+S6bXUbyBlxW4KtQTuAmF74AS
y80B8iCpd+7bbIcOrwFAtKm/fQU8186O+V/r26N/P6eiBFhZrMbtlLA1lHH/zcCc9ZhOsYYL1rfy
7iq7+yalqj7K0Lnh6gQ3yqey8hpWJOKmtfhe7tM38y/VfOvlSqrPvNR3XvwvD2G8m1daakyGO1Dn
L9PNbsmHAAAAAAAA


--=-czfw9mdPangjpJ+rY15c--

