Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailgw02.dd24.net ([193.46.215.43]:43606 "EHLO
	mailgw02.dd24.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705AbaHaEI6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 31 Aug 2014 00:08:58 -0400
Received: from localhost (amavis02.intern.homer.dd24.net [192.168.1.113])
	by mailgw02.dd24.net (Postfix) with ESMTP id E69426C0177
	for <linux-btrfs@vger.kernel.org>; Sun, 31 Aug 2014 04:02:09 +0000 (UTC)
Received: from mailgw02.dd24.net ([192.168.1.197])
	by localhost (amavis02.dd24.net [192.168.1.106]) (amavisd-new, port 10197)
	with ESMTP id nSEIKLh-Xzq5 for <linux-btrfs@vger.kernel.org>;
	Sun, 31 Aug 2014 04:02:06 +0000 (GMT)
Received: from [192.168.0.102] (ppp-93-104-2-228.dynamic.mnet-online.de [93.104.2.228])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by mailgw02.dd24.net (Postfix) with ESMTPSA
	for <linux-btrfs@vger.kernel.org>; Sun, 31 Aug 2014 04:02:06 +0000 (UTC)
Message-ID: <1409457725.4671.10.camel@scientia.net>
Subject: general thoughts and questions + general and RAID5/6 stability?
From: Christoph Anton Mitterer <calestyo@scientia.net>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Date: Sun, 31 Aug 2014 06:02:05 +0200
Content-Type: multipart/signed; micalg="sha-512";
	protocol="application/x-pkcs7-signature";
	boundary="=-mzrP2aNqGmZio2gvqVT8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--=-mzrP2aNqGmZio2gvqVT8
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hey.


For some time now I consider to use btrfs at a larger scale, basically
in two scenarios:

a) As the backend for data pools handled by dcache (dcache.org), where
we run a Tier-2 in the higher PiB range for the LHC Computing Grid...
For now that would be rather "boring" use of btrfs (i.e. not really
using any of its advanced features) and also RAID functionality would
still be provided by hardware (at least with the current hardware
generations we have in use).=20

b) Personally, for my NAS. Here the main goal is less performance but
rather data safety (i.e. I want something like RAID6 or better) and
security (i.e. it will be on top of dm-crypt/LUKS) and integrity.
Hardware wise I'll use and UPS as well as enterprise SATA disks, from
different vendors respectively different production lots.
(Of course I'm aware that btrfs is experimental, and I would have
regular backups)




1) Now I've followed linux-btrfs for a while and blogs like Marc's...
and I still read about a lot of stability problems, some which sound
quite serious.
Sure we have a fsck now, but even in the wiki one can read statements
like "the developers use it on their systems without major problems"...
but also "if you do this, it could help you... or break even more".

I mean I understand that there won't be a single point in time, where
Chris Mason says "now it's stable" and it would be rock solid form that
point on... but especially since new features (e.g. things like
subvolume quota groups, online/offline dedup, online/offline fsck) move
(or will) move in with every new version... one has (as an end-user)
basically no chance to determine what can be used safely and what
tickles the devil.

So one issue I have is to determine the general stability of the
different parts.




2) Documentation status...
I feel that some general and extensive documentation is missing. One
that basically handles (and teaches) all the things which are specific
to modern (especially CoW) filesystems.
- General design, features and problems of CoW and btrfs
- Special situations that arise from the CoW, e.g. that one may not be
able to remove files once the fs is full,... or that just reading files
could make the used space grow (via the atime)
- General guidelines when and how to use nodatacow... i.e. telling
people for which kinds of files this SHOULD usually be done (VM
images)... and what this means for those files (not checksumming) and
what the drawbacks are if it's not used (e.g. if people insist on having
the checksumming - what happens to the performance of VM images? what
about the wear with SSDs?)
- the implications of things like compression and hash algos... whether
and when this will have performance impacts (positive or negative) and
when not.
- the typical lifecycles and procedures when using stuff like multiple
devices (how to replace a faulty disk) or important hints like (don't
span a btrfs RAID over multiple partitions on the same disk)
- especially with the different (mount)options, I mean things that
change the way the fs works like no-hole or mixed data/meta block
groups... people need to have some general information when to choose
which and some real world examples of disadvantages / advantages. E.g.
what are the disadvantages of having mixed data/meta block groups? If
there'd be only advantages, why wouldn't it be the default?

Parts of this is already scattered over LWN articles, the wiki (however
the quality greatly "varies" there), blog posts or mailing list posts...
many of the information there is however outdated... and suggested
procedures (e.g. how to replace a faulty disk) differ from example to
example.
An admin that wants to use btrfs shouldn't be required to pick all this
together (which is basically impossible).. there should be a manpage
(which is kept up to date!) that describes all this.

Other important things to document (which I couldn't fine so far in most
cases): What is actually guaranteed by btrfs respectively its design?
For example:
- If there'd be no bugs in the code,.. would the fs be guaranteed to be
always consistent by it's CoW design? Or are there circumstances where
it can still run into being inconsistent?
- Does this basically mean, that even without and fs journal,.. my
database is always consistent even if I have a power cut or system
crash?
- At which places does checksumming take place? Just data or also meta
data? And is the checksumming chained as with ZFS, so that every change
in blocks, triggers changes in the "upper" metadata blocks up to the
superblock(s)?
- When are these checksums verified? Only on fsck/scrub? Or really on
every read? All this is information needed by an admin to determine what
the system actually guarantees or how it behaves.
- How much data/metadata (in terms of bytes) is covered by one checksum
value? And if that varies, what's the maximum size? I mean if there
would be on CRC32 per file (which can be GiB large) which would be read
every time a single byte of that file is read... this would probably be
bad ;) ... so we should tell the user "no we do this block or extent
wise"... And since e.g. CRC32 is maybe not well suited for very big
chunks of data, the user may want to know how much data is "protected"
by one hash value... so that he can decide whether to switch to another
algorithm (if one should become available).
- Does stacking with block layers work in all cases (and in which does
it not)? E.g. btrfs on top of looback devices, dm-crypt, MD, lvm2? And
also the other way round: What of these can be put on top of btrfs?
There's the prominent case, that swap files don't work on btrfs. But
documentation in that area should also contain performance instructions,
i.e. that while it's possible to have swap on top of btrfs via loopback,
it's perhaps stupid with CoW... or e.g. with dmcrypt+MD there were quite
some heavy performance impacts depending on whether dmcrypt was below or
above MD. Now of course normally, dmcrypt will be below btrfs,... but
there are still performance questions e.g. how does this work with
multiple devices? Is there one IO thread per device or one for all?
Or questions like: Are there any stability issues when btrfs is stacked
below/above other block layer, e.g. in case of power losses...
especially since btrfs relies so heavy on barriers.
Or questions like: Is btrfs stable if lower block layers modify data?
e.g. if dmcrypt should ever support online re-encryption=20
- Many things about RAID (but more on that later).




3) What about some nice features which many people probably want to
see...
Especially other compression algos (xz/lzma or lz4[hc]) and hash alogs
(xxHash... some people may even be interested in things like SHA2 or
Keccak).
I know some of them are planned... but is there any real estimation on
when they come?




4) Are (or how) exiting btrfs filesystems kept up to date when btrfs
evolves over time?
What I mean here is... over time, more and more features are added to
btrfs... this is of course not always a change in the on disk format...
but I always wonder a bit: If I write the same that of my existing fs
into a freshly created one (with the same settings)... would it
basically look like the same (of course not exactly)?
In many of the mails here on the list respectively commit logs one can
read things which sound as this happens quite often... that things (that
affect how data is written on the disk) are now handled better.
Or what if defaults change? E.g. if something new like no-hole would
become the default for new filesystems?
An admin cannot track all these things and understand which of them
actually means that he should recreate the filesystem.

Of course there's the balance operation... but does this really affect
everything?

So the question is basically: As btrfs evolves... how to I keep my
existing filesystems up to date so that they are as if they were created
as new.




5) btrfs management [G]UIs are needed
Not sure whether this should be go into existing files managers (like
nemo or konqueror) or something separate... but I definitely think, that
the btrfs community will need to provide some kind of powerful
management [G]UI.
Such a manager is IMHO crucial for anything that behaves like a storage
management system.
What should it be able to do?
a) Searching for btrfs specific properties, e.g.
- files compressed with a given algo
- files for which the compression ratio is <,>,=3D n%
- files which are nodatacow
- files for which integrity data is stored with a given hash algo
- files with a given redundancy level (e.g. DUP or RAID1 or RAID6 or
DUPn if that should ever come)
- files which should have a given redundancy level, but whose actual
level is different (e.g. due to a degraded state, or for which more
block copies than desired are still available)
- files which are defragmented at n%

Of course all these conditions should be combinable, and one should have
further conditions like m/c/a-times or like the subvolumes/snapshots
that should be searched.

b) File lists in such a manager should display many details like
compression ratio, algos (compression, hash), number of fragments,
whether blocks of that file are referenced by other files, etc. pp.

c) Of course it should be easy to change all the properties from above
for a files (well at least if that's possible in btrfs).
Like when I want to have some files, or dirs/subdirs, recompressed with
another algo, or uncompressed.
Or triggering online defragmentation for all files of a given
fragmentation level.
Or maybe I want to set a higher redundancy level for files which I
consider extremely precious to myself (not sure if it's planned to have
different redundancy levels per file)

d) Such manager should perhaps also go through the logs and tell things
like:
- when was the last complete balance
- when was the last complete scrub
- for which files happened integrity check problems during read/scrub...
how many of these could be corrected via other block copies?

e) Maybe it could give even more low level information, like showing how
a file is distributed over the devices, e.g. how the blocks are located,
or showing the location block copies or involved block devices for the
redundancy levels.=20




6) RAID / Redundancy Levels
a) Just some remark, I think it's a bad idea to call these RAID in the
btrfs terminology... since what we do is not necessarily exactly the
same like classic RAID... this becomes most obvious with RAID1, which
behaves not as RAID1 should (i.e. one copy per disk)... at least the
used names should comply with MD.=20

b) In other words... I think there should be RAID1, which equals to 1
copy per underlying device.
And it would be great to have a redundancy level DUPx, which is x copies
for each block spread over the underlying devices. So if x is 6 and one
has 3 underlying devices, each of them should have 2 copies of each
block.
I think the DUPx level is quite interesting to protect against single
block failures, especially also on computers where one usually simply
doesn't have more than one disk drive (e.g. notebooks).=20

c) As I've noted before, I think it would be quite nice if it would be
supported to have different redundancy levels for different files...
e.g. less previous stuff like OS data could have DUP ... more valuable
data could have RAID6... and my most precious data could have DUP5 (i.e.
5 copies of each block).
If that would ever come, one would probably need to make that property
inheritable by directories to be really useful.

d) What's the status of the multi-parity RAID (i.e. more than tow parity
blocks)? Weren't some patches for that posted a while ago?

e) Most important:
What's the status on RAID5/6? Is it still completely experimental or
already well tested?
Does rebuilding work? Does scrubbing work?
I mean as far as I know, there are still important parts that miss so
that it works at all, right?
When can one expect work on that to be completed?

f) Again, it detailed documentation should be added how the different
redundancy levels actually work, e.g.
- Is there a chunk size, can it be configured and how does it affect
reads/writes (as with MD)
- How do parallel reads happen if multiple blocks are available? What
e.g. if there are multiple block copies per device? Is simply always the
first tried to be read? Or the one with the best seek times? Or is this
optimised with other reads?

g) When a block is read (and the checksum is always verified), does that
already work, that if verification fails, the other blocks are tried,
respectively the block is tried to be recalculated using the parity?
What if all that fails, will it give a read error, or will it simply
deliver a corrupted block, as with traditional RAID?

h) We also need some RAID and integrity monitoring tool.
Doesn't matter whether this is a completely new tool or whether it can
be integrated in something existing.
But we need tools, which inform the admin via different ways when a disk
failed an a rebuild is necessary.
And the same should happen when checksum verification errors happen that
could be corrected (perhaps with a configurable threshold)...so that
admins have the chance to notice signs of a disk that is about to fail.=20

Of course such information is already printed to the kernel logs - well
I guess so),... but I don't think it's enough to let 3rd parties and
admins write scripts/daemons which do these checks and alerting... there
should be something which is "official" and guaranteed to catch all
cases and simply works(TM).=20



Cheers,
Chris.

--=-mzrP2aNqGmZio2gvqVT8
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
ggFjMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTE0MDgzMTA0MDIw
NVowTwYJKoZIhvcNAQkEMUIEQEt9VNx4pgl6MUjHLB1RmrZg2hPa7gpLI7J+ytRw4UQnH6mDcOZy
EZdOXJaUneUWYkLKSE8PyNEOAI9pFz9zoqowagYJKwYBBAGCNxAEMV0wWzBUMRQwEgYDVQQKEwtD
QWNlcnQgSW5jLjEeMBwGA1UECxMVaHR0cDovL3d3dy5DQWNlcnQub3JnMRwwGgYDVQQDExNDQWNl
cnQgQ2xhc3MgMyBSb290AgMCOakwbAYLKoZIhvcNAQkQAgsxXaBbMFQxFDASBgNVBAoTC0NBY2Vy
dCBJbmMuMR4wHAYDVQQLExVodHRwOi8vd3d3LkNBY2VydC5vcmcxHDAaBgNVBAMTE0NBY2VydCBD
bGFzcyAzIFJvb3QCAwI5qTANBgkqhkiG9w0BAQEFAASCAQDO98XGkwRsq1+kVJ8Jqs5deOPVCznU
0dV0nL7wp0gHABo8TeQFwL6VbkjpCL/Bfspuv2cbq1aDf1mvjR6Oew1c8/GKw+Frf0mhdSfjMWx6
v1xOCpdo6sv9zkZyQYpv3oW1+ruDJpMrDhm7tQB+AfwyHnpFc2kS3ZtzcrF/tZFEALG1Hh4xJ106
ZPmZEamuT321JCw+28tnH7lDP2jLLVuZUI2V5gTFTojKJHFCNpKXcxFo/EwK3JoG57IK2LXGLM90
RdwOjzxljGPp7BAtspHvp/fuTNfSQEBISGJ2yF9Sk6cFNkOyj519m5gCt1oj/9oi/fBPHGZuu7Rm
XwZJW60QAAAAAAAA


--=-mzrP2aNqGmZio2gvqVT8--

