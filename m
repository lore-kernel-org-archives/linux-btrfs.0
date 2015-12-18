Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailgw-01.dd24.net ([193.46.215.41]:57717 "EHLO
	mailgw-01.dd24.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752424AbbLRAVl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 Dec 2015 19:21:41 -0500
Message-ID: <1450398096.6498.34.camel@scientia.net>
Subject: Re: [auto-]defrag, nodatacow - general suggestions?(was: btrfs:
 poor performance on deleting many large files?)
From: Christoph Anton Mitterer <calestyo@scientia.net>
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
Date: Fri, 18 Dec 2015 01:21:36 +0100
In-Reply-To: <pan$7df3b$2174f8e9$efd1ab67$2dbe2f31@cox.net>
References: <CA+ve2MYBAPbLPiX4i2oZeDeu+9=JurXHsx5fMef2iV3rRrCKxg@mail.gmail.com>
	 <56530DAD.9080607@gmail.com> <1448497439.28195.33.camel@scientia.net>
	 <pan$3c463$5dc6ffa1$704b2ca2$141e65cc@cox.net>
	 <5667C00B.4010100@scientia.net>
	 <pan$7e682$345fe6d2$de13162d$f5ac4118@cox.net>
	 <1450303141.6242.50.camel@scientia.net>
	 <pan$7df3b$2174f8e9$efd1ab67$2dbe2f31@cox.net>
Content-Type: multipart/signed; micalg="sha-512";
	protocol="application/x-pkcs7-signature";
	boundary="=-rweaMm/WA21KCyxfIPbK"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--=-rweaMm/WA21KCyxfIPbK
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

[I'm combining the messages again, since I feel a bit bad, when I write
so many mails to the list ;) ]
But from my side, feel free to split up as much as you want (perhaps
not single characters or so ;) )


On Thu, 2015-12-17 at 04:06 +0000, Duncan wrote:
> Just to mention here, that I said "integrity management features",
> which=C2=A0
> includes more than checksumming.=C2=A0=C2=A0As Austin Hemmelgarn has been
> pointing=C2=A0
> out, DBs and some VMs do COW, some DBs do checksumming or at least
> have=C2=A0
> that option, and both VMs and DBs generally do at least some level
> of=C2=A0
> consistency checking as they load.=C2=A0=C2=A0Those are all "integrity
> management=C2=A0
> features" at some level.
Okay... well, but the point of that whole thread was obviously data
integrity protection in the sense of what data checksumming does in
btrfs for CoWed data and for meta-data.
In other words: checksums at some blockleve, which are verified upon
every read.



> As for bittorrent, I /think/ the checksums are in the torrent files=C2=A0
> themselves (and if I'm not mistaken, much as git, the chunks within
> the=C2=A0
> file are actually IDed by checksum, not specific position, so as long
> as=C2=A0
> the torrent is active, uploading or downloading, these will by
> definition=C2=A0
> be retained).=C2=A0=C2=A0As long as those are retained, the checksums sho=
uld
> be=C2=A0
> retained.=C2=A0=C2=A0And ideally, people will continue to torrent the fil=
es
> long=C2=A0
> after they've finished downloading them, in which case they'll still
> need=C2=A0
> the torrent files themselves, along with the checksums info.
Well I guess we don't need to hook up ourselves so much on the p2p
formats.
They're just one examples, even if these would actually be integrity
protected in the sense as described above, well, fine, but there are
other major use cases left, for which this is not the case.

Of course one can also always argue, that users can then manually move
the files out of the no-CoWed area or manually create their own
checksums as I do and store them in XATTRS.
But all this is not real proper full checksum protection: there are
gaps, where things are not protected and normal users may simply not
do/know all this (and why shouldn't they still benefit from proper
checksumming if we can make it for them).
IMHO, even the argument that one could manually make checksums or move
the file to CoWed area, while the e.g. downloaded files are still in
cache doesn't count: that wouldn't work for VMs, DBs, and certainly not
for torrent files larger than the memory.


> Meanwhile, if they do it correctly there's no window without
> protection,=C2=A0
> as the torrent file can be used to double-verify the file once moved,
> as=C2=A0
> well, before deleting it.
Again, would work only for torrent-like files, not for VM images, only
partially for DBs... plus... why requiring users to make it manually,
if the fs could take care of it.







On Thu, 2015-12-17 at 05:07 +0000, Duncan wrote:
> > In kinda curios, what free space fragmentation actually means here.
> >=C2=A0
> > Ist simply like this:
> > +----------+-----+---+--------+
> > >=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0F=C2=A0=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A0D=
=C2=A0=C2=A0| F |=C2=A0=C2=A0=C2=A0=C2=A0D=C2=A0=C2=A0=C2=A0|
> > +----------+-----+---+--------+
> > Where D is data (i.e. files/metadata) and F is free space.
> > In other words, (F)ree space itself is not further subdivided and
> > only
> > fragmented by the (D)ata extents in between.
> >=C2=A0
> > Or is it more complex like this:
> > +-----+----+-----+---+--------+
> > >=C2=A0=C2=A0F=C2=A0=C2=A0|=C2=A0=C2=A0F |=C2=A0=C2=A0D=C2=A0=C2=A0| F =
|=C2=A0=C2=A0=C2=A0=C2=A0D=C2=A0=C2=A0=C2=A0|
> > +-----+----+-----+---+--------+
> > Where the (F)ree space itself is subdivided into "extents" (not
> > necessarily of the same size), and btrfs couldn't use e.g. the
> > first two
> > F's as one contiguous amount of free space for a larger (D)ata
> > extent
> At the one level, I had the simpler f/d/f/d scheme in mind, but that=C2=
=A0
> would be the case inside a single data chunk.=C2=A0=C2=A0At the higher fi=
le
> level,=C2=A0
> with files significant fractions of the size of a single data chunk
> to=C2=A0
> much larger than a single data chunk, the more complex and second
> f/f/d/f/d case would apply, with the chunk boundary as the
> separation=C2=A0
> between the f/f.
Okay, but that's only when there are data chunks that neighbour each
other... since the data chunks are rather big normally (1GB) that
shouldn't be such a big issue,... so I guess the real world looks like
this:
=C2=A0DC#1 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0DC=
#2
...----+---------------------------------...
...---+|+----------+-----+-
--+--------+
... F ||| =C2=A0 =C2=A0 F=C2=A0=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A0D=C2=A0=C2=A0=
| F |=C2=A0=C2=A0=C2=A0=C2=A0D=C2=A0=C2=A0=C2=A0|
...---+|+--------
--+-----+---+--------+
...----++---------------------------------...
(with DC =3D data chunk)

but it could NOT look like this:
=C2=A0DC#1 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0DC=
#2
...----+---------------------------------...
...---+|+-----+----+-----+---+--------+
... F ||| =C2=A0F=C2=A0 | =C2=A0F |=C2=A0=C2=A0D=C2=A0=C2=A0| F
|=C2=A0=C2=A0=C2=A0=C2=A0D=C2=A0=C2=A0=C2=A0|
...---+|+-----+----+-----+---+--------+
...----++-------------
--------------------...
in other words, there could be =3D2 adjacent free
space "extents", when these are actually parts of different
neighbouring chunks, but there could NOT be >=3D2 adjacent free space
"extents" as part of the same data chunk.
Right?


=C2=A0
> IOW, files larger than data chunk size will always be fragmented
> into=C2=A0
> data chunk size fragments/extents, at the largest, because chunks
> are=C2=A0
> designed to be movable using balance, device remove, replace, etc.
IOW, filefrag doesn't really show me directly, whether a file is
fragged or not (at least not, when the file is > chunk size)...
There should be a better tool for that from the btrfs :)

And one more (think I found parts of the answer already below):
Does defrag only try to defrag within chunks, or would it also try to
align datachunks the "belong" together next to each other - or better
said would it try to place extents beloning together in neighbouring
extents?
Or is it basically not really forseen in btrfs, that file sizes > chunk
size are really fully consecutively on disk?
Similar perhaps, whether freshly allocating a file larger than > chunk
size, would try to choose the (already existing) and allocate new
chunks so that its extents are contiguous even at chunk borders?

I think if files > chunk size, would be always fragmented at the chunk
level,.. this may show up a problematic edge case:
If a file is heavily accessed at regions that are at the chunk borders,
one would have always seeks (at HDDs) when the next chunk is actually
needed... and one could never defrag it fully, or at least any balance
could "destroy" it again.
I guess nodatacow'ed areas also use the 1GB chunk size, right?


> Using the 1 GiB nominal figure, files over 1 GiB would always be
> broken=C2=A0
> into 1 GiB maximum size extents, corresponding to 1 extent per chunk.
I see...

=C2=A0
> But based on real reports posting before and after numbers from
> filefrag=C2=A0
> (on uncompressed btrfs), we do have cases where defrag can't find 256
> KiB=C2=A0
> free-space blocks and thus can actually fragment a file worse than it
> was=C2=A0
> before, so free-space fragmentation is indeed a very real problem.
btw: That's IMHO quite strange... or rather said: I'd have thought that
the check whether an extent get's even more fragmented than before,
would have been rather trivial...







On Thu, 2015-12-17 at 06:00 +0000, Duncan wrote:
> but as has been discussed elsewhere, on btrfs
> compressed=C2=A0
> files it will interpret each 128 KiB btrfs compression block as its
> own=C2=A0
> extent, even if (as seen in verbose mode) the next one begins where
> the=C2=A0
> previous one ends so it's really just a single extent.
Hmm I took the opportunity and reported that as a wishlist bug
upstream:
http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D808265


Cheers,
Chris.
--=-rweaMm/WA21KCyxfIPbK
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
ggFjMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTE1MTIxODAwMjEz
NlowTwYJKoZIhvcNAQkEMUIEQJJ42NqhVviipl0DoUUaYvHH1ZEKBbxpxzex+BCFHN9VoTocllVL
LFITGAm0wiGUNGnnhYtb2T4e0yrQcwLqN8cwagYJKwYBBAGCNxAEMV0wWzBUMRQwEgYDVQQKEwtD
QWNlcnQgSW5jLjEeMBwGA1UECxMVaHR0cDovL3d3dy5DQWNlcnQub3JnMRwwGgYDVQQDExNDQWNl
cnQgQ2xhc3MgMyBSb290AgMCOakwbAYLKoZIhvcNAQkQAgsxXaBbMFQxFDASBgNVBAoTC0NBY2Vy
dCBJbmMuMR4wHAYDVQQLExVodHRwOi8vd3d3LkNBY2VydC5vcmcxHDAaBgNVBAMTE0NBY2VydCBD
bGFzcyAzIFJvb3QCAwI5qTANBgkqhkiG9w0BAQEFAASCAQCrjaSqow1PiEVC8cwkxl1pvhEkjxQF
G2g2ioK2UZJZUSH4c84YrVmCuho6QHtGfIQ9K8M7mbM4pom/jUZnPXELbbbZ3BkM7kVLBLHMqHWO
D3rxYQXeAG3YLupleFKnoKzR98OAKLJb7E7nredzaf0iA12pMoywVB92tjP4k9DzxqsOQMb9WW1O
1QXIQCJKCMWMpOJZ9daCwPrrWZ+NQ1n34UHTwEy+MKf31SV+ABb7r+KJDbSCAo7DgGhVwSzsDUg5
eG/TggjMJMu5CZXph8QQ3liwhrYFdw+t6nkxXdpENOvzwsvsXiEPjGy+ozeBQCWrmA/DLkGbh5pp
zVx7KPPsAAAAAAAA


--=-rweaMm/WA21KCyxfIPbK--

