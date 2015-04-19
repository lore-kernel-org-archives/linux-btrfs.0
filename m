Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailgw-02.dd24.net ([193.46.215.43]:39309 "EHLO
	mailgw02.dd24.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751764AbbDSUAb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 19 Apr 2015 16:00:31 -0400
Received: from mailpolicy-01.live.igb.homer.key-systems.net (mailpolicy-01.live.igb.homer.key-systems.net [192.168.1.26])
	by mailgw02.dd24.net (Postfix) with ESMTP id 1580E5FAD4
	for <linux-btrfs@vger.kernel.org>; Sun, 19 Apr 2015 20:00:29 +0000 (UTC)
Received: from mailgw02.dd24.net ([192.168.1.36])
	by mailpolicy-01.live.igb.homer.key-systems.net (mailpolicy-01.live.igb.homer.key-systems.net [192.168.1.25]) (amavisd-new, port 10236)
	with ESMTP id 3gBSkyjXw0Kn for <linux-btrfs@vger.kernel.org>;
	Sun, 19 Apr 2015 20:00:27 +0000 (UTC)
Received: from heisenberg.fritz.box (ppp-188-174-18-198.dynamic.mnet-online.de [188.174.18.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by mailgw02.dd24.net (Postfix) with ESMTPSA
	for <linux-btrfs@vger.kernel.org>; Sun, 19 Apr 2015 20:00:26 +0000 (UTC)
Message-ID: <1429473624.24823.38.camel@scientia.net>
Subject: Re: how to clone a btrfs filesystem
From: Christoph Anton Mitterer <calestyo@scientia.net>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Date: Sun, 19 Apr 2015 22:00:24 +0200
In-Reply-To: <201504190102.42660.russell@coker.com.au>
References: <1429312124.8371.62.camel@scientia.net>
	 <201504180424.40385.russell@coker.com.au>
	 <1429334269.8371.75.camel@scientia.net>
	 <201504190102.42660.russell@coker.com.au>
Content-Type: multipart/signed; micalg="sha-512";
	protocol="application/x-pkcs7-signature";
	boundary="=-XjLS7Ja179sTdab3Q7lA"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--=-XjLS7Ja179sTdab3Q7lA
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2015-04-19 at 01:02 +1000, Russell Coker wrote:=20
> An rsync on block devices wouldn't lose BTRFS checksums, you could run a =
scrub=20
> on the target at any time to verify them.  For a dd or anything based on =
that=20
> the target needs to be at least as big as the source.  But typical use of=
=20
> BTRFS for backup devices tends to result in keeping as many snapshots as=
=20
> possible without running out of space which means that no matter how you =
were=20
> to copy it the target would need to be as big.
Hmm all not really satisfying.



> > Can't one do something like the following:
> > 1) The source fs has several snapshots and subvols.
> >    The target fs is empty (the first time).
> >=20
> >=20
> > For the first time populating the target fs:
> >=20
> > 2) Make ro snapshots of all non-ro snapshots and subvols on the
> > source-fs.
> >=20
> > 3) Send/receive the first of the ro snapshots to the target fs, with no
> > parent and no clone-src.
> >=20
> > 4) Send/receive all further ro snapshots to the target fs, with no
> > parents, but each time specifying one further clone-src (i.e. all that
> > have already been sent/received) so that they're used for reflinks and
> > so on
> >=20
> > 5) At the end somehow make rw-subvols from the snapshots/subvols that
> > have been previously rw (how?).
>=20
> Sure, for 5 I believe you can make a rw snapshot of a ro subvol.
So, is clone-src really what I think it is?
Or better, what exactly are the parent and clone-srcs and how do they
work?

AFAIU the clone-src is a ro snapshot on the SOURCE(!) fs, that has
previously sent to the target fs (thus it's there as well).
So for the snapshot that is sent "now" it looks for any blocks that are
also in the SOURCE fs version of clone-src and for those it only sends
reflinks... and on the target fs these are again used.
So I'd guess each of these blocks has some kind of ID that is sent?

But that already sounds quite similar to what I'd expect parent to be:
When I send a ro snapshot the first time, e.g.
$ btrfs subvolume create /src-btrfs/foo
  # do stuff in foo

  # first time backup of foo:
$ btrfs subvolume snapshot -r /src-btrfs/snapshots/foo-2015-01=20
$ btrfs send /src-btrfs/snapshots/foo-2015-01  |  btrfs receive /trgt-btrfs=
/

  # do more stuff in foo

  # secondary backup of foo:
$ btrfs subvolume snapshot -r /src-btrfs/snapshots/foo-2015-04=20
$ btrfs send -p /src-btrfs/snapshots/foo-2015-01 /src-btrfs/snapshots/foo-2=
015-04  |  btrfs receive /trgt-btrfs/
  # then it would know that foo-2015-01 is already on /trgt-btrfs/ and
  # only send the differences between those two?
  # I guess the UUID and gen of foo-2015-01 would be the same on both
  # sides? And foo-2015-04 would then have the UUID of foo-2015-01 as
  # parent on the target side?

Now if I make another subvolume on the source, which shares *some* refs
with foo, e.g.
$ btrfs subvolume create /src-btrfs/bar
  # do stuff in bar, or e.g let bar be another ro or rw snapshot of
  # foo that has been modified

  # Then I'd use clone sources to transfer this data efficiently?

$ btrfs send -c /src-btrfs/snapshots/foo-* /src-btrfs/bar  |  btrfs receive=
 /trgt-btrfs/


My actual situation is this:
I have a btrfs-fs, with one non-snapshot subvolume (i.e. the root
subvolume) and a number of snapshots, e.g.
2015-01
2015-02
2015-03
All being ro-snapshots from the root subvol.
And I want to get all these snapshots copied over to the target fs (i.e.
I want the snapshot history preserved).

ATM, I do I send receive on the first snapshot I've made like:=20
$ btrfs send /src-btrfs/snapshots/2015-03-10/ | btrfs receive /trgt-btrfs/
Afterwards I'd expect 2015-01 to be "copied" over.
How would I continue with -02 and -03? Using -01 as parent? Or as clone-src=
?

(Did I mention before, that the overall documentation seems to be really
in a... "suboptimal" state? :-( )


> > Does that sound as if it would somehow work like that? Especially would
> > it preserve all the reflink statuses and everything else (sparse files,
> > etc.)
> Yes, but it would take a bit of scripting work.
What do you mean? To automate if for arbitrary number of subvols?


> > Some additional questions:
> > a) Can btrfs send change anything(!) on the source fs?
> > b) Can one abort (Ctrl-C) a send and/or receive... and make it continue
> > at the same place were it was stopped?
>=20
> A yes
Mhh than it's really weird that it's allowed to work on a ro-mounted
fs?!
Doesn't look that trustworthy :-(

> , B I don't know.
Yeah, as posted somewhere above, I found out myself in the meantime that
one cannot even temporarily stop such process without having it failing.

> Also I'm not personally inclined to trust send/recv at this time.  I don'=
t=20
> think it's had a lot of testing.
Moreover, it seems to have rather bad performance (though I haven't done
any thorough testing/measuring).
Right now I send/receive a first subvolume from a HDD to another, the
2nd being a fresh btrfs, both fs with -o compress.
Both filesystems are on top of dm-crypt on a SATA 8TiB HDD connected via
USB (the source 3, the target 2).
The system is rather powerful, 8 cores, 16 TiB RAM.

Most of the time, only one of the two disks shows activity, while the
other is reading respectively writing.
The CPU isn't really under full load either (not even a single core),...
it's rather in the 5-10% utilisation.=20
The resulting transferspeed is about 21,5 MB/s (not MiB).
Seems to be pretty low...


Also, the system freezes up all the time for some seconds... so there is
probably some IO scheduling issue.

Further, when I run e.g. btrfs filesystem show, it actually prints the
info for both, but afterwards it seems to hang forever.


Thanks,
Chris.

--=-XjLS7Ja179sTdab3Q7lA
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
ggFjMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTE1MDQxOTIwMDAy
NFowTwYJKoZIhvcNAQkEMUIEQNeY/OuOtwLjCaxl9mhK3rGfYCKF1gkGKFGBze+vt/FxPTkyRRaX
2/4+C1PQ7XN6tmouD7nfcwhuNETG/yYj38YwagYJKwYBBAGCNxAEMV0wWzBUMRQwEgYDVQQKEwtD
QWNlcnQgSW5jLjEeMBwGA1UECxMVaHR0cDovL3d3dy5DQWNlcnQub3JnMRwwGgYDVQQDExNDQWNl
cnQgQ2xhc3MgMyBSb290AgMCOakwbAYLKoZIhvcNAQkQAgsxXaBbMFQxFDASBgNVBAoTC0NBY2Vy
dCBJbmMuMR4wHAYDVQQLExVodHRwOi8vd3d3LkNBY2VydC5vcmcxHDAaBgNVBAMTE0NBY2VydCBD
bGFzcyAzIFJvb3QCAwI5qTANBgkqhkiG9w0BAQEFAASCAQB+z/eSaQ4YxAu+TlmA6R4C2kKVdcW8
WYLW7/R/cHFYIJL0KWKwaaqP5ltGUbm8ylFIdG28x0MyPVrothx826XPwf76WDYI+YVeY7kaRqa4
HsjfU6dBWXuzKvsShhnIGk0LlkZFc13/yxfOmhAO6PvPMO6QX86kIuU7HBX72KmdqDko4qQO0Giv
Jw+IsCk0elEIzRSm1hs9FfPteXYvSB5qVAPTfGR8QqlZyEnU4kR/IDgHwvnH6sfK8Hyi5mTU1ESA
/HCU8nD6rP2OQqOUElaB5ADZ35Ettarp2q33tIVZWwr7XPnwjyQv1XtGNfE+FRm3GC9pm+egyM+J
aJtaQPJFAAAAAAAA


--=-XjLS7Ja179sTdab3Q7lA--

