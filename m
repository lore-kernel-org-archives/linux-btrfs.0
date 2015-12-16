Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailgw-02.dd24.net ([193.46.215.43]:50305 "EHLO
	mailgw-02.dd24.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934451AbbLPXzn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Dec 2015 18:55:43 -0500
Message-ID: <1450310139.6242.90.camel@scientia.net>
Subject: Re: [auto-]defrag, nodatacow - general suggestions?(was: btrfs:
 poor performance on deleting many large files?)
From: Christoph Anton Mitterer <calestyo@scientia.net>
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
Date: Thu, 17 Dec 2015 00:55:39 +0100
In-Reply-To: <pan$ebb43$1588cbbe$750076d0$4848c51f@cox.net>
References: <CA+ve2MYBAPbLPiX4i2oZeDeu+9=JurXHsx5fMef2iV3rRrCKxg@mail.gmail.com>
	 <56530DAD.9080607@gmail.com> <1448497439.28195.33.camel@scientia.net>
	 <20151126003342.GA24333@carfax.org.uk>
	 <1450057495.2388.40.camel@scientia.net>
	 <pan$ebb43$1588cbbe$750076d0$4848c51f@cox.net>
Content-Type: multipart/signed; micalg="sha-512";
	protocol="application/x-pkcs7-signature";
	boundary="=-+giVUdOek9Gy7uWwzSwy"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--=-+giVUdOek9Gy7uWwzSwy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2015-12-14 at 10:51 +0000, Duncan wrote:
> > AFAIU, the one the get's fragmented then is the snapshot, right,
> > and the
> > "original" will stay in place where it was? (Which is of course
> > good,
> > because one probably marked it nodatacow, to avoid that
> > fragmentation
> > problem on internal writes).
>=20
> No.=C2=A0=C2=A0Or more precisely, keep in mind that from btrfs' perspecti=
ve, in
> terms of reflinks, once made, there's no "original" in terms of
> special=20
> treatment, all references to the extent are treated the same.
Sure... you misunderstood me I guess..

>=20
> What a snapshot actually does is create another reference (reflink)
> to an=20
> extent.
[snip snap]
> So in the=20
> case of nocow, a cow1 (one-time-cow) exception must be made,
> rewriting=20
> the changed data to a new location, as the old location continues to
> be=20
> referenced by at least one other reflink.
That's what I've meant.


> So (with the fact that writable snapshots are available and thus it
> can=20
> be the snapshot that changed if it's what was written to) the one
> that=20
> gets the changed fragment written elsewhere, thus getting fragmented,
> is=20
> the one that changed, whether that's the working copy or the snapshot
> of=20
> that working copy.
Yep,.. that's what I've suspected and asked for.

The "original" file, in the sense of the file that first reflinked the
contiguous blocks,... will continue to point to these continuous
blocks.

While the "new" file, i.e he CoW-1-ed snapshot's file, will partially
reflink blocks form the contiguous range, and it's rewritten blocks
will reflink somewhere else.
Thus the "new" file is the one that gets fragmented.


> > And one more:
> > You both said, auto-defrag is generally recommended.
> > Does that also apply for SSDs (where we want to avoid unnecessary
> > writes)?
> > It does seem to get enabled, when SSD mode is detected.
> > What would it actually do on an SSD?
> Did you mean it does _not_ seem to get (automatically) enabled, when
> SSD=20
> mode is detected, or that it _does_ seem to get enabled, when=20
> specifically included in the mount options, even on SSDs?
I does seem to get enabled, when specifically included in the mount
options (the ssd mount option is not used), i.e.:
/dev/mapper/system=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0btrfs=C2=A0=C2=A0=C2=A0subvol=3D/root,defaults,noat=
ime,autodefrag=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A00=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A01
leads to:
[=C2=A0=C2=A0=C2=A0=C2=A05.294205] BTRFS: device label foo devid 1 transid =
13 /dev/disk/by-label/foo
[=C2=A0=C2=A0=C2=A0=C2=A05.295957] BTRFS info (device sdb3): disk space cac=
hing is enabled
[=C2=A0=C2=A0=C2=A0=C2=A05.296034] BTRFS: has skinny extents
[=C2=A0=C2=A0=C2=A067.082702] BTRFS: device label system devid 1 transid 60=
710 /dev/mapper/system
[=C2=A0=C2=A0=C2=A067.111185] BTRFS info (device dm-0): disk space caching =
is enabled
[=C2=A0=C2=A0=C2=A067.111267] BTRFS: has skinny extents
[=C2=A0=C2=A0=C2=A067.305084] BTRFS: detected SSD devices, enabling SSD mod=
e
[=C2=A0=C2=A0=C2=A068.562084] BTRFS info (device dm-0): enabling auto defra=
g
[=C2=A0=C2=A0=C2=A068.562150] BTRFS info (device dm-0): disk space caching =
is enabled



> Or did you actually mean it the way you wrote it, that it seems to be
> enabled (implying automatically, along with ssd), when ssd mode is=20
> detected?
No, sorry for being unclear.
I meant it that way, that having the ssd detected doesn't auto-disable
auto-defrag, which I thought may make sense, given that I didn't know
exactly what it would do on SSDs...
IIRC, Hugo or Austin, mentioned the thing with making for better IOPS,
but I haven't had considered that to have impact enough... so I thought
it could have made sense to ignore the "autodefrag" mount option in
case an ssd was detected.



> There are three factors I'm aware of here as well, all favoring=20
> autodefrag, just as the two above favored leaving it off.
>=20
> 1) IOPS, Input/Output Operations Per Second.=C2=A0=C2=A0SSDs typically ha=
ve
> both an=20
> IOPS and a throughput rating.=C2=A0=C2=A0And unlike spinning rust, where =
raw
> non-
> sequential-write IOPS are generally bottlenecked by seek times, on
> SSDs=20
> with their zero seek-times, IOPS can actually be the bottleneck.
Hmm it would be really nice to get someone who has found a way to make
some sound analysis/benchmarking of that.


> 2) SSD physical write and erase block sizes as multiples of the
> logical/
> read block size.=C2=A0=C2=A0To the extent that extent sizes are multiples=
 of
> the=20
> write and/or erase-block size, writing larger extents will reduce
> write=20
> amplification due to writing and blocks smaller than the write or
> erase=20
> block size.
Hmm... okay I don't know the details of how btrfs does this, but I'd
have expected that all extents are aligned to the underlying physical
devices' block structure.
Thus each extent should start at such write/erase block, and at most it
shouldn't perfectly at the end of the extent.
If the file is fragmented (i.e. more than one extent), I'd have even
hoped that all but the last one fit perfectly.

So what you basically mean, AFAIU, is that by having auto-defrag, you
get larger extents (i.e. smaller ones collapsed into one) and by thus
you get less cut off at the end of extents where these don't match
exactly the underlying write/erase blocks?

I still don't see the advantage here,... neighbouring extents would
hopefully still be aligned,... and it doesn't seem that one saves write
cycles but rather have more due to the defrag.


> While the initial autodefrag rewrite is a second-cycle write after a=20
> fragmented write, spending a write cycle for the autodefrag,
> consistent=20
> use of autodefrag should help keep file fragmentation and thus
> ultimately=20
> space fragmentation to a minimum, so initial writes, where there's
> enough=20
> data to write an initially large extent, won't be forced to be broken
> into smaller extents because there's simply no large free-space
> extents=20
> left due to space fragmentation.
> IOW, autodefrag used consistently should reduce space fragmentation
> as=20
> well as file fragmentation, and this reduced space fragmentation will
> lead to the possibility of writing larger extents initially, where
> the=20
> amount of data to be written allows it, thereby reducing initial file
> write fragmentation and the need for autodefrag as a result.
Okay... but AFAIU, that's more like the effects described in (1) and
has less to do with erase/write block sizes...


> 3) Btrfs metadata management overhead.=C2=A0=C2=A0While btrfs tracks thin=
gs
> like=20
> checksums at fixed sizes,
btw: over which amounts of data is each checksum calculated?


>  other metadata is per extent.=C2=A0=C2=A0Obviously, the=20
> more extents a file has, the harder btrfs has to work to track them
> all.=C2=A0=C2=A0
> Maintenance tasks such as balance and check already have scaling
> issues;=20
> do we really want to make them worse by forcing them to track
> thousands=20
> or tens of thousands of extents per (large) file where they could be=20
> tracking a dozen or two?
Okay, but these effects are IMHO also more similar to (1),... I'd
probably call them "meta-data compaction" or so...


> On balance, I was persuaded to use autodefrag on my own btrfs' on
> SSDs,=20
> and believe the near-term write-cycle damage may in fact be largely=20
> counteracted by indirect free-space defrag effect and the effect that
> in=20
> turn has on the ability to even find large areas of cohesive free
> space=20
> to write into in the first place.=C2=A0=C2=A0With that largely counteract=
ed,
> the=20
> other benefits in my mind again outweigh the negatives, so autodefrag
> continues to be worth it in general, even on SSDs.
Intuitively, I'd tend to agree... even though I either didn't fully
understand your (2) and count it and (3) rather to (1).

Would be interesting to see a actual analysis with measurements from
one of the filesystem/block device geeks.



> I suppose someone will eventually do that sort of testing, but of
> course=20
> even if they did it now, with btrfs code still to be optimized and=20
> various scaling work still to be done, it's anyone's guess if the
> test=20
> results would still apply a few years down the road, after that
> scaling=20
> and optimization work.
Sure... :-)

I guess I'll leave it on, and when in 5-10 years after btrfs has been
stabilised and optimised someone comes up with rock solid data proofing
it, I can claim that I always knew it...
And if data disproves it, I can claim it's all Duncan's fault who lured
me into this
;^-P

Cheers,
Chris.
--=-+giVUdOek9Gy7uWwzSwy
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
ggFjMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTE1MTIxNjIzNTUz
OVowTwYJKoZIhvcNAQkEMUIEQGizv0Jxz3HYLnLhCN6Ib3sc6kGlHW3PfnRSehoNUb7+JwWjNgXz
ErPUzd/rwA/dHL0lpfpiHW+Z9LvbTI0URk0wagYJKwYBBAGCNxAEMV0wWzBUMRQwEgYDVQQKEwtD
QWNlcnQgSW5jLjEeMBwGA1UECxMVaHR0cDovL3d3dy5DQWNlcnQub3JnMRwwGgYDVQQDExNDQWNl
cnQgQ2xhc3MgMyBSb290AgMCOakwbAYLKoZIhvcNAQkQAgsxXaBbMFQxFDASBgNVBAoTC0NBY2Vy
dCBJbmMuMR4wHAYDVQQLExVodHRwOi8vd3d3LkNBY2VydC5vcmcxHDAaBgNVBAMTE0NBY2VydCBD
bGFzcyAzIFJvb3QCAwI5qTANBgkqhkiG9w0BAQEFAASCAQCvdEB7XMBfFtzU2MRluUfU8KOICEzS
1Os/OUEwlHYDxEee4hoInpKtGKsQOdNSS++M3y+eRxMWbzEmzj/5AuvYvcmL11N2imHVAOPvCS9v
aIOHv3CBo7weISWihRFYnmyOD7GYdegSogKDoWb2N+m6h3CB/BQpJ2A3acstETK73hCcZkP7s/o4
mES46bvK4wv9a6GQQ66ul4ukwRiTPx0FKZlGR2PM7M1TbKO4DczQTSznfQvzjj1IjPslLpNkMxpd
OMoNJmheKFgABj37ZDIYHEiw+rDrQFRHfpk+SLnrybE5rQeVdb3ONSU+c8hVfkiV2xMu6LPWw/c8
SqSyQvnaAAAAAAAA


--=-+giVUdOek9Gy7uWwzSwy--

