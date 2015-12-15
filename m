Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailgw-02.dd24.net ([193.46.215.43]:54706 "EHLO
	mailgw-02.dd24.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752240AbbLODPR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Dec 2015 22:15:17 -0500
Message-ID: <1450149311.701.126.camel@scientia.net>
Subject: Re: dear developers, can we have notdatacow + checksumming, plz?
From: Christoph Anton Mitterer <calestyo@scientia.net>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>, linux-btrfs@vger.kernel.org
Date: Tue, 15 Dec 2015 04:15:11 +0100
In-Reply-To: <566ECF41.10709@gmail.com>
References: <1450069158.2388.72.camel@scientia.net>
	 <566ECF41.10709@gmail.com>
Content-Type: multipart/signed; micalg="sha-512";
	protocol="application/x-pkcs7-signature";
	boundary="=-g1LcFtvdltdmnuI+/Uef"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--=-g1LcFtvdltdmnuI+/Uef
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2015-12-14 at 09:16 -0500, Austin S. Hemmelgarn wrote:
> > When one starts to get a bit deeper into btrfs (from the admin/end-
> > user
> > side) one sooner or later stumbles across the recommendation/need
> > to
> > use nodatacow for certain types of data (DBs, VM images, etc.) and
> > the
> > reason, AFAIU, being the inherent fragmentation that comes along
> > with
> > the CoW, which is especially noticeable for those types of files
> > with
> > lots of random internal writes.
> It is worth pointing out that in the case of DB's at least, this is=20
> because at least some of the do COW internally to provide the=20
> transactional semantics that are required for many workloads.
Guess that also applies to some VM images then, IIRC qcow2 does CoW.



> > a) for performance reasons (when I consider our research software
> > which
> > often has IO as the limiting factor and where we want as much IO
> > being
> > used by actual programs as possible)...
> There are other things that can be done to improve this.=C2=A0=C2=A0I wou=
ld
> assume=20
> of course that you're already doing some of them (stuff like using=20
> dedicated storage controller cards instead of the stuff on the=20
> motherboard), but some things often get overlooked, like actually
> taking=20
> the time to fine-tune the I/O scheduler for the workload (Linux has=20
> particularly brain-dead default settings for CFQ, and the deadline
> I/O=20
> scheduler is only good in hard-real-time usage or on small hard
> drives=20
> that actually use spinning disks).
Well sure, I think we'de done most of this and have dedicated
controllers, at least of a quality that funding allows us ;-)
But regardless how much one tunes, and how good the hardware is. If
you'd then loose always a fraction of your overall IO, and be it just
5%, to defragging these types of files, one may actually want to avoid
this at all, for which nodatacow seems *the* solution.


> The big argument for defragmenting a SSD is that it makes it such
> that=20
> you require fewer I/O requests to the device to read a file
I've had read about that too, but since I haven't had much personal
experience or measurements in that respect, I didn't list it :)


> The problem is not entirely the lack of COW semantics, it's also the
> fact that it's impossible to implement an atomic write on a hard
> disk.=20
Sure... but that's just the same for the nodatacow writes of data.
(And the same, AFAIU, for CoW itself, just that we'd notice any
corruption in case of a crash due to the CoWed nature of the fs and
could go back to the last generation).


> > but I wouldn't know that relational DBs really do cheksuming of the
> > data.
> All the ones I know of except GDBM and BerkDB do in fact provide the=20
> option of checksumming.=C2=A0=C2=A0It's pretty much mandatory if you want=
 to be
> considered for usage in financial, military, or medical applications.
Hmm I see... PostgreSQL seem to have it since 9.3 ... didn't know
that... only crc16 but at least something.


> > Long story short, it does happen every now and then, that a scrub
> > shows
> > file errors, for neither the RAID was broken, nor there were any
> > block
> > errors reported by the disks, or anything suspicious in SMART.
> > In other words, silent block corruption.
> Or a transient error in system RAM that ECC didn't catch, or a=20
> undetected error in the physical link layer to the disks, or an error
> in=20
> the disk cache or controller, or any number of other things.
Well sure,... I was referring to these particular cases, where silent
block corruption was the most likely reason.
The data was reproducibly read identical, which probably rules out bad
RAM or controller, etc.


> =C2=A0=C2=A0BTRFS=20
> could only protect against some cases, not all (for example, if you
> have=20
> a big enough error in RAM that ECC doesn't catch it, you've got
> serious=20
> issues that just about nothing short of a cold reboot can save you
> from).
Sure, I haven't claimed, that checksumming for no-CoWed data is a
solution for everything.


> > But, AFAIU, not doing CoW, while not having a journal (or does it
> > have
> > one for these cases???) almost certainly means that the data (not
> > necessarily the fs) will be inconsistent in case of a crash during
> > a
> > no-CoWed write anyway, right?
> > Wouldn't it be basically like ext2?
> Kind of, but not quite.=C2=A0=C2=A0Even with nodatacow, metadata is still=
 COW,=20
> which is functionally as safe as a traditional journaling filesystem=20
> like XFS or ext4.
Sure, I was referring to the data part only, should have made that more
clear.


> Absolute worst case scenario for both nodatacow on=20
> BTRFS, and a traditional journaling filesystem, the contents of the
> file=20
> are inconsistent.=C2=A0=C2=A0However, almost all of the things that are=
=20
> recommended use cases for nodatacow (primarily database files and VM=20
> images) have some internal method of detecting and dealing with=20
> corruption (because of the traditional filesystem semantics ensuring=20
> metadata consistency, but not data consistency).
What about VMs? At least a quick google search didn't give me any
results on whether there would be e.g. checksumming support for qcow2.
For raw images there surely is not.

And even if DBs do some checksumming now, it may be just a consequence
of that missing in the filesystems.
As I've written somewhere else in the previous mail: it's IMHO much
better if one system takes care on this, where the code is well tested,
than each application doing it's own thing.


> > =C2=A0 =C2=A0- the data was written out correctly, but before the csum =
was
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0written the system crashed, so the csum w=
ould now tell us that
> > the
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0block is bad, while in reality it isn't.
> There is another case to consider, the data got written out, but the
> crash happened while writing the checksum (so the checksum was
> partially=20
> written, and is corrupt).=C2=A0=C2=A0This means we get a false positive o=
n a
> disk=20
> error that isn't there, even when the data is correct, and that
> should=20
> be avoided if at all possible.
I've had that, and I've left it quoted above.
But as I've said before: That's one case out of many? How likely is it
that the crash happens exactly after a large data block has been
written followed by a relatively tiny amount of checksum data.
I'd assume it's far more likely that the crash happens during writing
the data.

And regarding "reporting data to be in error, which is actually
correct"... isn't that what all journaling systems may do?
And, AFAIU, isn't that also what can happen in btrfs? The data was
already CoWed, but the metadata wasn't written out... so it would fall
back somehow - here's where the unicorn[0] does it's job - to an older
generation?
So that would be nothing really new.


> Also, because of how disks work, and the internal layout of BTRFS,
> it's=20
> a lot more likely than you think that the data would be written but
> the=20
> checksum wouldn't.=C2=A0=C2=A0The checksum isn't part of the data block, =
nor is
> it=20
> stored with it, it's actually a part of the metadata block that
> stores=20
> the layout of the data for that file on disk.
Well it was clear to me, that data+csum isn't sequentially on disk are
there any numbers from real studies how often it would happen that data
is written correctly but not the metadata?
And even if such study would show that - crash isn't the only problem
we want to protect here (silent block errors, bus errors, etc).
I don't want to say crashes never happen, but in my practical
experience they don't happen that often either,...

Losing a few blocks of valid data in the rare case of crashes, seems to
be a penalty worth, when one gains confidence in data integrity in all
others.


> Because of the nature of=20
> the stuff that nodatacow is supposed to be used for, it's almost
> always=20
> better to return bad data than it is to return no data (if you can
> get=20
> any data, then it's usually possible to recover the database file or
> VM=20
> image, but if you get none, it's a lot harder to recover the file).
No. Simply no! :D

Seriously:
If you have bad data, for whichever reason (crash, silent block errors,
etc.), it's always best to notice.
*Then* you can decide what to do:
- Is there a backup and does one want to get the data from that
=C2=A0 backup, rather than continuing to use bad data, possibly even
=C2=A0 overwriting good backups one week later
- Is there either no backup or the effort of recovering it is to big
=C2=A0 and the corruption doesn't matter enough (e.g. when you have large
=C2=A0 video files, and there is a sinlge bit flip... well that may just
=C2=A0 mean that one colour looks a tiny bit different)

But that's nothing the fs could or should decide for the user.

After I've had sent the initial mail from this thread I remembered what
I've had forgotten to add:
Is there a way in btrfs, to tell it that gives clearance to a file
which it found to be in error based on checksums?

Cause *this* is IMHO the proper solution for your "it's almost always
better to return bad data than it is to return no data".

When we at the Tier-2 detect a file error that we cannot correct by
means of replicas, we determine the owner of that file, tell him about
the issue, and if he wants to continue using the broken file, there's a
way in the storage management system to rewrite the checksum.


> > =3D> Of course it wouldn't be as nice as in CoW, where it could
> > =C2=A0=C2=A0=C2=A0=C2=A0simply take the most recent consistent state of=
 that block, but
> > =C2=A0=C2=A0=C2=A0=C2=A0still way better than:
> > =C2=A0=C2=A0=C2=A0=C2=A0- delivering bogus data to the application in n=
 other cases
> > =C2=A0=C2=A0=C2=A0=C2=A0- not being able to decide which of m block cop=
ies is valid, if
> > a
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0RAID is scrubbed
> This gets _really_ scarily dangerous for a RAID setup, because we=20
> _absolutely_ can't ensure consistency between disks without using
> COW.=20
Hmm now I just thought "damn he got me" ;-)

> As of right now, we dispatch writes to disks one at a time (although=20
> this would still be just as dangerous even if we dispatched writes in
> parallel)
Sure...


> so if we crash it's possible that one disk would hold the old=20
> data, one would hold the new data
sure..


> and _both_ would have correct=20
> checksums, which means that we would non-deterministically return one
> block or the other when an application tries to read it, and which
> block=20
> we return could change _each_ time the read is attempted, which=20
> absolutely breaks the semantics required of a filesystem on any
> modern=20
> OS (namely, the file won't change unless something writes to it).
Here I do not longer follow you, so perhaps you (or someone else) can
explain a bit further. :-)

a) Are checksums really stored per device (and not just once in the
metadata? At least from my naive understanding this would either mean
that there's a waste of storage, or that the csums are made on data
that could vary from device to device (e.g. the same data split up in
different extents, or compression on one device but not on the other).
but..

b) that problem (different data each with valid corresponding csums)
should in principle exist for CoWed data as well, right? And there, I
guess, it's solved by CoWing the metadata... (which would still be the
case for no-dataCoWed files).
Don't know what btrfs does in the CoWed case when such incident
happens... how does it decide which of two such corresponding blocks
would be the newer one? The generations?

Anyway, since metadata would still be CoWed, I think I may have gotten
once again out of the tight spot - at least until you explain me, why=C2=A0
my naive understanding, as laid out just above, doesn't work out O:-)



> As I stated above, most of the stuff that nodatacow is intended for=20
> already has it's own built-in protection.=C2=A0=C2=A0No self-respecting R=
DBMS=20
> would be caught dead without internal consistency checks, and they
> all=20
> do COW internally anyway (because it's required for atomic
> transactions,=20
> which are an absolute requirement for database systems), and in fact=20
> that's part of why performance is so horrible for them on a COW=20
> filesystem.=C2=A0=C2=A0As far as VM's go, either the disk image should ha=
ve
> it's=20
> own internal consistency checks (for example, qcow2 format, used by=20
> QEMU, which also does COW internally), or the guest OS should have
> such=20
> checks.
Well, for PostgreSQL it's still fairly new (9.3, as I've said above,=C2=A0h=
t
tps://wiki.postgresql.org/wiki/What%27s_new_in_PostgreSQL_9.3#Data_Chec
ksums), but it's not done per default (http://www.postgresql.org/docs/c
urrent/static/app-initdb.html), and they warn about a noticable
performance benefit (though I have of course no data whether this would
be better/similar/worse to what is implied by btrfs checksumming).

I've tried to find something for MySQL/MariaDB, but the only thing I
could find there was:=C2=A0CHECKSUM TABLE
But that seems to be a SQL command, i.e. not on-read checksumming as
we're talking about, but rather something the application/admin would
need to do manually.


BDB seems to support it (https://docs.oracle.com/cd/E17076_04/html/api_
reference/C/dbset_flags.html), but again not per default.
(And yes, we have quite big ones of them ^^)

SQLite doesn't seem to do it, at least not per default? (https://www.sq
lite.org/fileformat.html)


I tried once again to find any reference that qcow2 (which alone I
think would justify having csum support for nodatacow) supports
checksumming.
https://people.gnome.org/~markmc/qcow-image-format.html which seems to
be the original definition, doesn't tell[1] anything about it.
raw image, do of course not to any form of checksumming...
I had a short glance at OVF, but nothing popped up immediately that
would make me believe it supports checksumming.
Well there's VDI and VHD left... but are these still used seriously?
I guess KVM and Xen people mostly use raw or qcow2 these days, don't
they?


So given all that, the picture looks a bit different again, I think.
None of major FLOSS DBs doesn't do any checksumming per default, MySQL
doesn't seem to support it, AFAICT. No VM image format seems to even
support it.

And not to talk about countless of scientific data formats, which are
mostly not widely known to the FLOSS world, but which are used with
FLOSS software/Linux.


So AFAICT, the only thing left is torrent/edonkey files.
And do these store the checksums along the files? Or do they rather
wait until a chunk has been received, verify that and then throw it
away?
In any case however, at least some of these files types eventually end
up in the raw files, without any checksum (as that's only used during
download),... so when the files remain in the nodatacow area, they're
again at risk (+ during the time after the P2P software has finally
committed them to disk, and they'd be moved to CoWed and thus
checksummed areas)


Cheers,
Chris. :-)


[0]=C2=A0http://abstrusegoose.com/120
[1] admittedly I just cross read over it, and searched for the usual
suspect strings (hash, crc, sum) ;)
--=-g1LcFtvdltdmnuI+/Uef
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
ggFjMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTE1MTIxNTAzMTUx
MVowTwYJKoZIhvcNAQkEMUIEQBdO3+I11iXwSjp4QmH2QkUD0YTsE/wkp+62nbKNnXNj+vAqe1M1
pZ8vi22foMYLDxdHUaHQcRN5Dpdp5np/V24wagYJKwYBBAGCNxAEMV0wWzBUMRQwEgYDVQQKEwtD
QWNlcnQgSW5jLjEeMBwGA1UECxMVaHR0cDovL3d3dy5DQWNlcnQub3JnMRwwGgYDVQQDExNDQWNl
cnQgQ2xhc3MgMyBSb290AgMCOakwbAYLKoZIhvcNAQkQAgsxXaBbMFQxFDASBgNVBAoTC0NBY2Vy
dCBJbmMuMR4wHAYDVQQLExVodHRwOi8vd3d3LkNBY2VydC5vcmcxHDAaBgNVBAMTE0NBY2VydCBD
bGFzcyAzIFJvb3QCAwI5qTANBgkqhkiG9w0BAQEFAASCAQCBbDLZ/GU3rAvg6z76bgdtrQptRED4
oQVm5C8DAT9sIae+KeiAzadkPPMT+NsPxzbv6pL0myYPl/Jlndx/l5R61W7QCPN2Yjb43Vukwl0f
nkhGGwT2JLZfc58qx9w2FfHW5fRXjG4Jh/WImlkcnoZR6FVIBI3p7exGrQBA1qaWbugzUlnSgbeG
ih+E6la3sNaAQfRdc61v2cv6LmLepKp8CvG6aWrpysNDuHyT85G5pvMxcKbsypY9eRNeycv2Da2y
M5UBi7bLz1s5Cyb1Fu0k2NDcg/LoaOTqi3ELqavMKG61fa9nWxCeke/SnCjgOl1tQ9f3UsVTTZL/
XxFrgdEoAAAAAAAA


--=-g1LcFtvdltdmnuI+/Uef--

