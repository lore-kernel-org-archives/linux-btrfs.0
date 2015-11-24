Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailgw-02.dd24.net ([193.46.215.43]:34416 "EHLO
	mailgw-02.dd24.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753961AbbKXVZy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Nov 2015 16:25:54 -0500
Message-ID: <1448400350.21291.88.camel@scientia.net>
Subject: Re: subvols and parents - how?
From: Christoph Anton Mitterer <calestyo@scientia.net>
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
Date: Tue, 24 Nov 2015 22:25:50 +0100
In-Reply-To: <pan$72d2a$22c54e26$a0b05056$57585aef@cox.net>
References: <1448340960.14125.51.camel@scientia.net>
	 <pan$72d2a$22c54e26$a0b05056$57585aef@cox.net>
Content-Type: multipart/signed; micalg="sha-512";
	protocol="application/x-pkcs7-signature";
	boundary="=-HSQPfcfqeMnQp2LxY16o"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--=-HSQPfcfqeMnQp2LxY16o
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2015-11-24 at 08:29 +0000, Duncan wrote:
> OK, found it on the wiki.=C2=A0=C2=A0It wasn't under use-cases, where I
> initially=20
> thought to look, but under sysadmin guide.=C2=A0=C2=A0Specifically, see s=
ection
> 4.2, managing snapshots, but I'd suggest reading the entire
> subvolumes=20
> discussion, section 4, or even most/all of the page.
>=20
> https://btrfs.wiki.kernel.org/index.php/SysadminGuide
Well I've had read that, but it's pretty vague and especially doesn't
mentioned any of the filesystem internal implications (if there are
any)... like I wondered before, whether this has effects on ref-links
not being used when e.g. sending/recieving ... or on future planned
extensions like recursive snapshots.


>=C2=A0
> Suppose you only want to rollback /, because some update screwed you
> up,=20
> but not /home, which is fine.=C2=A0=C2=A0If /home is a nested subvolume, =
then=20
> you're now mounting the nested home subvolume from some other nesting
> tree entirely,
That's a bit unclear to me,... I thought when I make a snapshot, any
nested subvols wouldn't be snapshotted and thus be empty dirs.
So I'd have rather that if I would simply have no /home (if I didn't
move it to the rolled-back subvol manually)


> 5
> >=20
> +-roots (dir not subvol, note the s, rootS, plural)
> > +-root (subvol, mountpoint /)
> > > +-boot/ (dir)
> > > +-root/ (dir)
> > > +-lib/=C2=A0=C2=A0(dir)
> > > +-home/ (empty dir as mountpoint)
> > +-root-snapshot-2015.0301 (dated snapshot of root)
> > +-root-snapshot-2015.0601 (dated snapshot of root)
> > +-root-snapshot-2015.0901 (dated snapshot of root)
> +-homes (dir not subvol)
> > +-home (subvol, mountpoint /home)
> > +-home-snapshot-2015.0301 (dated snapshot of home)
> ...
That's more what I've had in mind...
Actually something like this:
5
|
+-root =C2=A0 =C2=A0 =C2=A0 (=3Dsubvol)
| +-boot
| +-home =C2=A0 =C2=A0 (subvo=3D/home being mounted heron)
| +-lib
+-home =C2=A0 =C2=A0 =C2=A0 (subvol, the current version)
+-snapshots =C2=A0(=3Ddir)
=C2=A0 +-root
=C2=A0 | +-2015-01-14 (subvol, snapshot)
=C2=A0 | +-2015-09-30 (subvol, snapshot)
=C2=A0 +-home
=C2=A0 =C2=A0 +-2015-06-04 (subvol, snapshot)
=C2=A0 =C2=A0 +-2015-09-01 (subvol, snapshot)


And it once more points to the problem of the wiki... anyone can write
(I think even I) and it's totally unclear at the first glance how
"[non-]official" and outdated something may be.
Apart from the problem that many important questions (from the PoV of
an more advanced admin that doesn't just do mkfs.btrfs and then never
again thinks about it) :-(


> Meanwhile, if the intention for a subvolume is simply to exclude that
> subtree from snapshotting of the parent, as might be the case for
> example=20
that is in fact also use case.. so in practise I'll probably have a mix
of (a) and (b).


> if you have a VMs subvol, with the VM image files set NOCOW to avoid=20
> fragmentation, since snapshotting nocow files forces cow1 (a cow at
> the=20
> first write of that block, before returning to nocow, because a
> snapshot=20
> locks the existing extents in place for the snapshot, so initial
> writes=20
> to a block after a snapshot /can't be nocow or it'd change the
> snapshot=20
> too...)
Ah that's good to know how that works (or better said, that it works at
all)... I've already wondered myself several times what happens when I
snapshot NOCOW files, ... something that's I guess also missing from
the (missing ;-) ) btrfs-end-user overview and details documentation.


> OTOH, if there's a chance you might want to mount that subvolume in a
> roll-back scenario, under the snapshot you're rolling back to, then
> it=20
> makes sense to put it directly under ID 5 again, and mount it in any
> case.
Yes.


> Then there's the security angle to consider.=C2=A0=C2=A0With the (basical=
ly,=20
> possibly modified as I suggested) flat layout, mounting something
> doesn't=20
> automatically give people in-tree access to nested subvolumes
> (subject to=20
> normal file permissions, of course), like nested layout does.=C2=A0=C2=A0=
And
> with=20
> (possibly modified) flat layout, the whole subvolume tree doesn't
> need to=20
> be mounted all the time either, only when you're actually working
> with=20
> subvolumes.
Uhm, I don't get the big security advantage here... whether nested or
manually mounted to a subdir,... if the permissions are insecure I'll
have a problem... if they're secure, than not.

Of course I use insecure permissions and don't mount the subvols then
I'd be safe in flat setup, but not in a nested setup...(where they
subvol is "auto-mounted")...

But that seems pretty awkward.



Mhh I think my main question turns out to be whether the different
layouts would have any technical (i.e. not administrative) effects...
like the aforementioned stuff of recursive snapshots (should such thing
ever come to life).
But at least from the userspace tools it seems that I can move subvols
arbitrarily and they adapt their parent IDs accordingly...

So I guess whatever setup one uses nested/flat/mixed... doesn't rule
out any functionalities for the future?!

thx,
Chris.
--=-HSQPfcfqeMnQp2LxY16o
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
ggFjMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTE1MTEyNDIxMjU1
MFowTwYJKoZIhvcNAQkEMUIEQLVXgtvgCgVMHnlgbi0OidWGudiohogdiRNKYtrbeGxFS6Yddm4B
0RiUJW3BCKCoGVvdKhnqz6dhZTtwVGfayz8wagYJKwYBBAGCNxAEMV0wWzBUMRQwEgYDVQQKEwtD
QWNlcnQgSW5jLjEeMBwGA1UECxMVaHR0cDovL3d3dy5DQWNlcnQub3JnMRwwGgYDVQQDExNDQWNl
cnQgQ2xhc3MgMyBSb290AgMCOakwbAYLKoZIhvcNAQkQAgsxXaBbMFQxFDASBgNVBAoTC0NBY2Vy
dCBJbmMuMR4wHAYDVQQLExVodHRwOi8vd3d3LkNBY2VydC5vcmcxHDAaBgNVBAMTE0NBY2VydCBD
bGFzcyAzIFJvb3QCAwI5qTANBgkqhkiG9w0BAQEFAASCAQArAU1oq/8ev01xA5vPinBKRoYX59B1
pFJjnPddXPzvnIYK1stnECnGj+yxSlQc0dVqpWUzWgo2qrY9FHM/tzVQ2jI66qsGGOf8mjeXfu4k
gzVIaP3KMF+7LEECOPXQIg8oCXRPwJp9CIu5Rm7EroWABv7NkA9G1Hjhf7C9Yo31/gfcTSDy9PTH
ty8sVbV2NNCpcGbjJMvh792i7FUH2uv2it+3sI/SK0xQdLo/BNp3rdlYqsD5CooSP6X1MTzte6YJ
H11GZd70ZGN6sGB5gA8cmEF++9sjhibtHVhb15K3whIlwzaQM3TpCgjJGV4qeQiQEooMGym2ZaCU
pAzvzKMcAAAAAAAA


--=-HSQPfcfqeMnQp2LxY16o--

