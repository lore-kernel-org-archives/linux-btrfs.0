Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailgw-01.dd24.net ([193.46.215.41]:56604 "EHLO
	mailgw-01.dd24.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753814AbbLQCKD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Dec 2015 21:10:03 -0500
Message-ID: <1450318197.6242.170.camel@scientia.net>
Subject: Re: dear developers, can we have notdatacow + checksumming, plz?
From: Christoph Anton Mitterer <calestyo@scientia.net>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>, linux-btrfs@vger.kernel.org
Date: Thu, 17 Dec 2015 03:09:57 +0100
In-Reply-To: <56703928.7070003@gmail.com>
References: <1450069158.2388.72.camel@scientia.net>
	 <566ECF41.10709@gmail.com> <1450149311.701.126.camel@scientia.net>
	 <56703928.7070003@gmail.com>
Content-Type: multipart/signed; micalg="sha-512";
	protocol="application/x-pkcs7-signature";
	boundary="=-JXiYhCsYPZvP46y574TM"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--=-JXiYhCsYPZvP46y574TM
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2015-12-15 at 11:00 -0500, Austin S. Hemmelgarn wrote:
> > Well sure, I think we'de done most of this and have dedicated
> > controllers, at least of a quality that funding allows us ;-)
> > But regardless how much one tunes, and how good the hardware is. If
> > you'd then loose always a fraction of your overall IO, and be it
> > just
> > 5%, to defragging these types of files, one may actually want to
> > avoid
> > this at all, for which nodatacow seems *the* solution.
> nodatacow only works for that if the file is pre-allocated, if it
> isn't,=20
> then it still ends up fragmented.
Hmm is that "it may end up fragmented" or a "it will definitely?
Cause I'd have hoped, that if nothing else had been written in the
meantime, btrfs would perhaps try to write next to the already
allocated blocks.


> > > The problem is not entirely the lack of COW semantics, it's also
> > > the
> > > fact that it's impossible to implement an atomic write on a hard
> > > disk.
> > Sure... but that's just the same for the nodatacow writes of data.
> > (And the same, AFAIU, for CoW itself, just that we'd notice any
> > corruption in case of a crash due to the CoWed nature of the fs and
> > could go back to the last generation).
> Yes, but it's also the reason that using either COW or a log-
> structured=20
> filesystem (like NILFS2, LogFS, or I think F2FS) is important for=20
> consistency.
So then it's no reason why it shouldn't work.
The meta-data is CoWed, any incomplete writes of checksumdata in that
(be it for CoWed data or no-CoWed data, should the later be
implemented), would be protected at that level.

Currently, the no-CoWed data is, AFAIU completely at risk of being
corrupted (no checksums, no journal).

Checksums on no-CoWed data would just improve that.


> > What about VMs? At least a quick google search didn't give me any
> > results on whether there would be e.g. checksumming support for
> > qcow2.
> > For raw images there surely is not.
> I don't mean that the VMM does checksumming, I mean that the guest OS
> should be the one to handle the corruption.=C2=A0=C2=A0No sane OS doesn't=
 run
> at=20
> least some form of consistency checks when mounting a filesystem.
Well but we're not talking about having a filesystem that "looks clear"
here. For this alone we wouldn't need any checksumming at all.

We talk about data integrity protection, i.e. all files and their
contents. Nothing which a fsck inside a guest VM would ever notice (I
mean by a fsck), if there are just some bit flips or things like that.


> >=20
> > And even if DBs do some checksumming now, it may be just a
> > consequence
> > of that missing in the filesystems.
> > As I've written somewhere else in the previous mail: it's IMHO much
> > better if one system takes care on this, where the code is well
> > tested,
> > than each application doing it's own thing.
> That's really a subjective opinion.=C2=A0=C2=A0The application knows bett=
er
> than=20
> we do what type of data integrity it needs, and can almost certainly
> do=20
> a better job of providing it than we can.
Hmm I don't see that.
When we, at the filesystem level, provide data integrity, than all data
is guaranteed to be valid.
What more should an application be able to provide? At best they can do
the same thing faster, but even for that I see no immediate reason to
believe it.

And in practise it seems far more likely that if countless applications
should such task on their own, that it's more error prone (that's why
we have libraries for all kinds of code, trying to reuse code,
minimising the possibility of errors in countless home-brew solutions),
or not done at all.


> > > > =C2=A0=C2=A0=C2=A0=C2=A0- the data was written out correctly, but b=
efore the csum
> > > > was
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0written the system crashed, so =
the csum would now tell us
> > > > that
> > > > the
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0block is bad, while in reality =
it isn't.
> > > There is another case to consider, the data got written out, but
> > > the
> > > crash happened while writing the checksum (so the checksum was
> > > partially
> > > written, and is corrupt).=C2=A0=C2=A0This means we get a false positi=
ve on
> > > a
> > > disk
> > > error that isn't there, even when the data is correct, and that
> > > should
> > > be avoided if at all possible.
> > I've had that, and I've left it quoted above.
> > But as I've said before: That's one case out of many? How likely is
> > it
> > that the crash happens exactly after a large data block has been
> > written followed by a relatively tiny amount of checksum data.
> > I'd assume it's far more likely that the crash happens during
> > writing
> > the data.
> Except that the whole metadata block pointing to that data block gets
> rewritten, not just the checksum.
But that's the case anyway, isn't it? With or without checksums.



> > And regarding "reporting data to be in error, which is actually
> > correct"... isn't that what all journaling systems may do?
> No, most of them don't actually do that.=C2=A0=C2=A0The general design of=
 a=20
> journaling filesystem is that the journal is used as what's called a=20
> Write-Intent-Log (WIL), the purpose of which is to say 'Hey, I'm
> going=20
> to write this data here in a little while.' so that when your system=20
> dies while writing that data, you can then finish writing it
> correctly=20
> when the system gets booted up again.=C2=A0=C2=A0And in particular, the o=
nly=20
> journaling filesystem that I know of that even allows the option of=20
> journaling the file contents instead of just metadata is ext4.
Well but that's just what I say... the system crashes,... the journal
tells about anything that's not for sure cleanly on disk, even though
it may have actually made it it.

Nothing more than what would happen in our case.


> > And, AFAIU, isn't that also what can happen in btrfs? The data was
> > already CoWed, but the metadata wasn't written out... so it would
> > fall
> > back somehow - here's where the unicorn[0] does it's job - to an
> > older
> > generation?
> Kind of, there are some really rare cases where it's possible if you
> get=20
> _really_ unlucky on a multi-device filesystem that things get
> corrupted=20
> such that the filesystem thinks that data that is perfectly correct
> is=20
> invalid, and thinks that the other copy which is corrupted is valid.=20
> (I've actually had this happen before, it was not fun trying to
> recover=20
> from it).
Doesn't really speak against nodatacow checksumming, AFAICS.


> > Well it was clear to me, that data+csum isn't sequentially on disk
> > are
> > there any numbers from real studies how often it would happen that
> > data
> > is written correctly but not the metadata?
> > And even if such study would show that - crash isn't the only
> > problem
> > we want to protect here (silent block errors, bus errors, etc).
> > I don't want to say crashes never happen, but in my practical
> > experience they don't happen that often either,...
> >=20
> > Losing a few blocks of valid data in the rare case of crashes,
> > seems to
> > be a penalty worth, when one gains confidence in data integrity in
> > all
> > others.
> That _really_ depends on what the data is.=C2=A0=C2=A0If you made that ar=
gument
> to=20
> the IT department at a financial institution, they would probably
> fall=20
> over laughing at you.
Well but your point is completely moot, because for someone who cares
so much in data, they wouldn't use nodatacow when btrfs has no journal
and the data could end up in any state in case of crash.

And I'm quite certain that each financial institution rather clearly
gets an error message (i.e. because the checksums don't very), after
which they can get a backup, than having corrupt data taking for valid,
and the debts of their customers being zeroed.

It's kinda strange how you argue against better integrity protection
;-)


> > But that's nothing the fs could or should decide for the user.
> OK, good point about this being policy.=C2=A0=C2=A0And in some cases
> (executables,=20
> configuration for administrative software, similar things), it is
> better=20
> to just return an error, but in many cases, that's not what most
> desktop=20
> users would want.=C2=A0=C2=A0Think document files, where a single byte er=
ror
> could=20
> easily be corrected by the user, or configuration files for sanely=20
> written apps (It's a lot nicer (and less confusing for someone
> without a=20
> lot of low-level computer background) to say 'Hey, your configuration
> file is messed up, here's how to fix it', than it is to say 'Hey, I=20
> couldn't read your configuration file').=C2=A0=C2=A0And because BTRFS is
> supposed=20
> to be a general purpose filesystem, it has to account for the case of
> desktop users, and because server admins are supposed to be smart,
> the=20
> default should be for desktop usage.
Well but that's just the point I've made. The fs cannot decide what's
better or not.
Your document could be an important config file that allows/disallows
remote users access to resources. The single byte error could make a 0
to a 1, allowing world wide access.
It could be your thesis' data, or part of the document file, changing
some numbers, which you won't easily notice but which makes everything
bogus when examined.
I had brought the example with the video file, where it may not matter.

But in any case it's nothing what the fs can decide. The best it can do
is give an error on read, and the tools to give clearance to such files
(when they could not be auto-recovered by e.g. other copies).

All this is however only possible with checksumming.


> > a) Are checksums really stored per device (and not just once in the
> > metadata? At least from my naive understanding this would either
> > mean
> > that there's a waste of storage, or that the csums are made on data
> > that could vary from device to device (e.g. the same data split up
> > in
> > different extents, or compression on one device but not on the
> > other).
> > but..
> AFAIUI, checksums are stored per-instance for every block.=C2=A0=C2=A0Thi=
s is=20
> important in a multi-device filesystem in case you lose a device, so=20
> that you still have a checksum for the block.=C2=A0=C2=A0There should be =
no=20
> difference between extent layout and compression between devices
> however.
hmm but if that's the case, especially the later, that the extents are
the same on all devices,... then there's IMHO no need for data being
stored per-instance (I guess you mean per device instance?) for every
block.
The meta-data would have e.g. DUP anyway, so even if one device fails
metadata would hopefully be still there.
And if metadata is coompletely lost, the fs is lost anyway, and csums
don't matter anymore.


> > b) that problem (different data each with valid corresponding
> > csums)
> > should in principle exist for CoWed data as well, right? And there,
> > I
> > guess, it's solved by CoWing the metadata... (which would still be
> > the
> > case for no-dataCoWed files).
> Yes.
> > Don't know what btrfs does in the CoWed case when such incident
> > happens... how does it decide which of two such corresponding
> > blocks
> > would be the newer one? The generations?
> Usually, but like I mentioned above there are edge cases that can
> occur=20
> as a result of data corruption on disk or other really rare=20
> circumstances.=C2=A0=C2=A0In the particular case of multiple copies of a =
block=20
> with different data but valid checksums, I'm about 95% certain that
> it=20
> will non-deterministically return one block or the other on an
> arbitrary=20
> read when the read doesn't hit the VFS cache.
Hmm would be quite worrysome if that could happen, especially also in
the CoW case.

> =C2=A0=C2=A0This is a potential issue=20
> for COW as well, but much less likely because it can more easily
> detect=20
> the corruption and fix it.
But then again, there should be no difference to checksumming the
no-CoWed data - the checksums would be CoWed again, if btrfs can detect
it there, it should be fine.




> >=20
> > Anyway, since metadata would still be CoWed, I think I may have
> > gotten
> > once again out of the tight spot - at least until you explain me,
> > why
> > my naive understanding, as laid out just above, doesn't work out
> > O:-)
> Hmm, I had forgotten about the metadata being COW, that does avoid
> the=20
> situation above under the specified circumstances, but does not avoid
> it=20
> happening due to disk errors (although that's extremely unlikely,a s
> it=20
> would require direct correlation of the errors in a way that is=20
> statistically impossible).
Ah... here we go :-)

What exactly do you mean with disk errors here? IOW, what scenario do
you think of, in which checksumming no-CoWed data could lead to any
more corruptions than it can to without checksumming as well, or where
any inconsistencies could get into the filesystem's meta-data, that
couldn't already come in for checksummed+CoWed data and/or non-
checksummed+CoWed data?

> > Well, for PostgreSQL it's still fairly new (9.3, as I've said
> > above, ht
> > tps://wiki.postgresql.org/wiki/What%27s_new_in_PostgreSQL_9.3#Data_
> > Chec
> > ksums), but it's not done per default (http://www.postgresql.org/do
> > cs/c
> > urrent/static/app-initdb.html), and they warn about a noticable
> > performance benefit (though I have of course no data whether this
> > would
> > be better/similar/worse to what is implied by btrfs checksumming).
> >=20
> > I've tried to find something for MySQL/MariaDB, but the only thing
> > I
> > could find there was: CHECKSUM TABLE
> > But that seems to be a SQL command, i.e. not on-read checksumming
> > as
> > we're talking about, but rather something the application/admin
> > would
> > need to do manually.
> I actually had been referring to this, with the assumption that the=20
> application would use it to verify it's own data.=C2=A0=C2=A0I hadn't rea=
lized=20
> PostgreSQL had in-line support for it.
Well but the (fairly new) in-line support, is the only thing that we
can really count here.

What mysql does is that it requires the app to do it.
a) It's likely that there are many apps which don't use this (maybe
simply because they don't know it) and it's unlikely they'll all
change.
While what we can do at the btrfs level (or what postgresql would do)
works out of the box for everything.

b) I may simply not very well understand the CHECKSUM TABLE, but to me
it doesn't seem useful to provide data integrity in the sense we're
talking here about (i.e. silent block errors, bus errors, etc.)
Why?
First, it seems to checksum the whole data of the whole table, and
AFAICS, it uses only CRC32... given that such tables may be easily GiB
in size, CRC32 is IMHO simply not good enough.
Postgresql/btrfs in turn do the checksums on much smaller amounts of
data.
Second, verification seems to only take place when that command is
called. I'm not sure whether it implies locking the table in memory
then (didn't dig too deep), but I can't believe it would, which system
could keep a 100 GiB table in mem?
So it seems to be basically a one-shot verification, not covering any
corruptions that happen in between.
In fact, the documentation of the function even tells that this is for
backups/rollbacks/etc. only... so it's absolutely not that kind of data
=C2=A0integrity protection we're talking about (and even for that purpose,
CRC32 seems to be a poor choice).


> VDI is still widely used, because it's the default for Virtual Box
> when=20
> creating a VM.
Guess I just disbelieved that VirtualBox is still widely used O;-)


> =C2=A0=C2=A0VHD is way more widely used than it should be, solely=20
> because there are insane people out there using Windows as a=20
> virtualization host.=C2=A0=C2=A0You also forgot VMDK, which is what VMWar=
e uses
> almost exclusively, but I don't think it has built-in checksumming.
>=20
> As for Xen, the BCP are to avoid using image files like the plague,
> and=20
> use disks directly instead (or more commonly, use either LVM, or ZFS=20
> with zvols).
Anyway... what it comes down to: None of the VM image formats seem to
support checksumming.


> > So given all that, the picture looks a bit different again, I
> > think.
> > None of major FLOSS DBs doesn't do any checksumming per default,
> > MySQL
> > doesn't seem to support it, AFAICT. No VM image format seems to
> > even
> > support it.
> Again, most of my intent in referring to those was that the
> application=20
> or the Guest OS would do the verification itself.
I've answered that above already, IIRC (our mails get too lengthy O:-)
).
The guest OS doesn't verify more than what our typical host OS (Linux)
does.
And that (except when btrfs with CoWed data is used ;-) does filesystem
integrity verification - which is however not data integrity
verification.


btw: That makes me think about something interesting:
If btrfs will ever support checksumming on no-CoWed data... then the
documentation should describe, that depending on the actual scenario,
it may make sense that btrfs filesystems inside the guest run generally
with nodatasum.
The idea begin: Why verifying twice?

The constraints being, AFAICS, the following:
- If the VM image is ever to be moved off the host's btrfs image
(which=C2=A0
=C2=A0 would have checksumming enabled) to a fs without checksumming or if
=C2=A0 it would be ever copied remotely, than not having the "internal"
=C2=A0 checksumming (i.e. from the btrfs filesystems inside the gues),
would=C2=A0
=C2=A0 make one loose the integrity protection
- It further would only work, if the hypervisor itself, would properly
=C2=A0 pass on any IO errors when it reads from the image files in the
=C2=A0 host's btrfs, to block IO errors for the guest. If it wouldn't, then
=C2=A0 the guest (with disabled "internal" checksumming) wouldn't probably
=C2=A0 notice any data integrity errors, which he would, if the "internal"
=C2=A0 checksumming wasn't turned off.


> If the application doesn't have that type of thing built in, then
> that's=20
> not something the filesystem should be worrying about, that's the job
> of=20
> the application developers to deal with.
No.

If you see it like that, you could as well drop data checksumming in
btrfs completely.
You'd anyway argue that it would be the applications duty to do that.

The same way you could argue, that your MP4, JPG, ISO image or whatever
you downloaded via bittorrent needs to contain checksum data, and that
the actual application (which is not bittorrent, but e.g. mplayer,
imagemagick or wodim) need to verify these.
However this is not the case.
In fact, it's quite usual and proper to have the lower layer handle
stuff which the higher layer don't have any real direct interest in
(except for the case, that the lower layer doesn't do it).


> The point of a filesystem is=20
> to store data within the integrity guarantees provided by the
> hardware,=20
> possibly with some additional protection
If you're convinced by that, you should probably propose that btrfs
removes data checksumming altogether.
I guess you won't make much friends with that idea ;)



> In the case of stuff like torrents and such, all the good software
> for=20
> working with them has an option to verify the file after downloading.
Not sure what you mean with "and such", if it's again VMs, and DBs (the
IMHO actually more important use case than file sharing), I showed you
in the last mail, that non of these do any verification by default, and
=C2=A0half of the important ones don't even support it, with nothing on the
horizon that this would change (probably because they argue just the
other way round than you do: the fs should handle data integrity, and
ZFS and btrfs give them partially right ;-) ).
And I'm not sure with torrents, but I'd have suspected once the file's
downloaded completely, any checksumming data is no longer kept.
If my guess is correct, even the torrent software doesn't really do
overall data integrity protection, but just until the download is
finished; at least this used to be the case with the other P2P network
softwares.



Thanks for the discussion so far :)
It actually made me just more confident that no-CoWed data checksumming
should work and is actually needed ;)


Cheers,
Chris.
--=-JXiYhCsYPZvP46y574TM
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
ggFjMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTE1MTIxNzAyMDk1
OFowTwYJKoZIhvcNAQkEMUIEQJAjuh/BLlB6UvGu+xqCXzET5nJEnx5d9bnV0RE4YT2WvI8ryGaO
2Kq4ubrUfO5ClUPT2Z+LB2eTVgSiYrSgQGcwagYJKwYBBAGCNxAEMV0wWzBUMRQwEgYDVQQKEwtD
QWNlcnQgSW5jLjEeMBwGA1UECxMVaHR0cDovL3d3dy5DQWNlcnQub3JnMRwwGgYDVQQDExNDQWNl
cnQgQ2xhc3MgMyBSb290AgMCOakwbAYLKoZIhvcNAQkQAgsxXaBbMFQxFDASBgNVBAoTC0NBY2Vy
dCBJbmMuMR4wHAYDVQQLExVodHRwOi8vd3d3LkNBY2VydC5vcmcxHDAaBgNVBAMTE0NBY2VydCBD
bGFzcyAzIFJvb3QCAwI5qTANBgkqhkiG9w0BAQEFAASCAQDHJyfuv0W+PcLCEbLZC5TUprvzQh5s
AqSdcR/KQp3KNfVktFyxklWhMXJtDuU0oAJDXrtquK77pbWFEtDrmsuvJ7yzqKSV01e/lDyBIoHk
1wX6k3RD4aVEhXrMfcer4DRVeID8/pKFhFE88ZZDlLd5N7WN7vGzhilCIUtL0cJVw2QtkGmuW4aG
7eCEjUs4UofrwPueklQYkolko0zD2cs/O9tmRqE6KaVZH3u0trI/S2VO1lBRTPtNwkqI/85Nv7nO
agkcQN11QVF3KgMkEZ2s0TdW/1MhskefXtQTA15GGlWDOKyF+/+myzqjxMBl6pLEVoqGCiRVIO/v
eR6LvH/JAAAAAAAA


--=-JXiYhCsYPZvP46y574TM--

