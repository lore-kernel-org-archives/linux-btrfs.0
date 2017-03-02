Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:64496 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750841AbdCBJuo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 2 Mar 2017 04:50:44 -0500
Received: from thetick.localnet ([93.181.44.247]) by mail.gmx.com (mrgmx101
 [212.227.17.168]) with ESMTPSA (Nemesis) id 0MAloF-1cbuLz1gAV-00Bs9p for
 <linux-btrfs@vger.kernel.org>; Thu, 02 Mar 2017 10:44:00 +0100
From: Marc Joliet <marcec@gmx.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: [4.7.2] btrfs_run_delayed_refs:2963: errno=-17 Object already exists
Date: Thu, 02 Mar 2017 10:43:52 +0100
Message-ID: <1714469.dJ89oe0hXx@thetick>
In-Reply-To: <185b5213-f036-04f8-cf8f-fbe5f3351139@cn.fujitsu.com>
References: <20160828152908.6e1325b5@jupiter.sol.kaishome.de> <11009787.rdtfuSitqF@thetick> <185b5213-f036-04f8-cf8f-fbe5f3351139@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2511671.9dK3eSEDM9"; micalg="pgp-sha256"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart2511671.9dK3eSEDM9
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

On Thursday 02 March 2017 08:43:53 Qu Wenruo wrote:
> At 02/02/2017 08:01 PM, Marc Joliet wrote:
> > On Sunday 28 August 2016 15:29:08 Kai Krakow wrote:
> >> Hello list!
> >=20
> > Hi list
>=20
> [kernel message snipped]
>=20
> >> Btrfs --repair refused to repair the filesystem telling me somethi=
ng
> >> about compressed extents and an unsupported case, wanting me to ta=
ke an
> >> image and send it to the devs. *sigh*
> >=20
> > I haven't tried a repair yet; it's a big file system, and btrfs-che=
ck is
> > still running:
> >=20
> > # btrfs check -p /dev/sdd2
> > Checking filesystem on /dev/sdd2
> > UUID: f97b3cda-15e8-418b-bb9b-235391ef2a38
> > parent transid verify failed on 3829276291072 wanted 224274 found 2=
83858
> > parent transid verify failed on 3829276291072 wanted 224274 found 2=
83858
> > parent transid verify failed on 3829276291072 wanted 224274 found 2=
83858
> > parent transid verify failed on 3829276291072 wanted 224274 found 2=
83858
>=20
> Normal transid error, can't say much about if it's harmless, but at
> least some thing went wrong.
>=20
> > Ignoring transid failure
> > leaf parent key incorrect 3829276291072
> > bad block 3829276291072
>=20
> That's some what a big problem for that tree block.
>=20
> If this tree block is extent tree block, no wonder why kernel output
> kernel warning and abort transaction.
>=20
> You could try "btrfs-debug-tree -b 3829276291072 <device>" to show th=
e
> content of the tree block.

# btrfs-debug-tree -b 3829276291072 /dev/sdb2=20
btrfs-progs v4.9
node 3829276291072 level 1 items 70 free 51 generation 292525 owner 2
fs uuid f97b3cda-15e8-418b-bb9b-235391ef2a38
chunk uuid 1cee580c-3442-4717-9300-8514dd8ff297
        key (3828594696192 METADATA_ITEM 0) block 3828933423104 (934798=
199)=20
gen 292523
        key (3828594925568 METADATA_ITEM 0) block 3829427818496 (934918=
901)=20
gen 292525
        key (3828595109888 METADATA_ITEM 0) block 3828895723520 (934788=
995)=20
gen 292523
        key (3828595232768 METADATA_ITEM 0) block 3829202751488 (934863=
953)=20
gen 292524
        key (3828595412992 METADATA_ITEM 0) block 3829097209856 (934838=
186)=20
gen 292523
        key (3828595572736 TREE_BLOCK_REF 33178) block 3829235073024=20=

(934871844) gen 292524
        key (3828595744768 METADATA_ITEM 0) block 3829128351744 (934845=
789)=20
gen 292524
        key (3828595982336 METADATA_ITEM 0) block 3829146484736 (934850=
216)=20
gen 292524
        key (3828596187136 METADATA_ITEM 1) block 3829097234432 (934838=
192)=20
gen 292523
        key (3828596387840 TREE_BLOCK_REF 33527) block 3829301653504=20=

(934888099) gen 292525
        key (3828596617216 METADATA_ITEM 0) block 3828885737472 (934786=
557)=20
gen 292523
        key (3828596838400 METADATA_ITEM 0) block 3828885741568 (934786=
558)=20
gen 292523
        key (3828597047296 METADATA_ITEM 0) block 3829320552448 (934892=
713)=20
gen 292525
        key (3828597231616 METADATA_ITEM 0) block 3828945653760 (934801=
185)=20
gen 292523
        key (3828597383168 METADATA_ITEM 0) block 3829276299264 (934881=
909)=20
gen 292525
        key (3828597641216 METADATA_ITEM 1) block 3829349351424 (934899=
744)=20
gen 292525
        key (3828597866496 METADATA_ITEM 0) block 3829364776960 (934903=
510)=20
gen 292525
        key (3828598067200 METADATA_ITEM 0) block 3828598321152 (934716=
387)=20
gen 292522
        key (3828598259712 METADATA_ITEM 0) block 3829422968832 (934917=
717)=20
gen 292525
        key (3828598415360 TREE_BLOCK_REF 33252) block 3828885803008=20=

(934786573) gen 292523
        key (3828598665216 METADATA_ITEM 0) block 3828937863168 (934799=
283)=20
gen 292523
        key (3828598829056 METADATA_ITEM 0) block 3828885811200 (934786=
575)=20
gen 292523
        key (3828599054336 METADATA_ITEM 0) block 3829363744768 (934903=
258)=20
gen 292525
        key (3828599246848 METADATA_ITEM 0) block 3828915838976 (934793=
906)=20
gen 292523
        key (3828599504896 METADATA_ITEM 0) block 3829436194816 (934920=
946)=20
gen 292525
        key (3828599672832 METADATA_ITEM 0) block 3828905140224 (934791=
294)=20
gen 292523
        key (3828599771136 METADATA_ITEM 0) block 3829333323776 (934895=
831)=20
gen 292525
        key (3828599988224 METADATA_ITEM 0) block 3829087199232 (934835=
742)=20
gen 292523
        key (3828600135680 METADATA_ITEM 0) block 3828885827584 (934786=
579)=20
gen 292523
        key (3828600389632 METADATA_ITEM 0) block 3829436284928 (934920=
968)=20
gen 292525
        key (3828600528896 METADATA_ITEM 0) block 3829316214784 (934891=
654)=20
gen 292525
        key (3828600729600 METADATA_ITEM 0) block 3828885905408 (934786=
598)=20
gen 292523
        key (3828600934400 METADATA_ITEM 0) block 3829384486912 (934908=
322)=20
gen 292525
        key (3828601143296 METADATA_ITEM 0) block 3829423611904 (934917=
874)=20
gen 292525
        key (3828601356288 METADATA_ITEM 0) block 3829113688064 (934842=
209)=20
gen 292524
        key (3828601556992 METADATA_ITEM 0) block 3829134540800 (934847=
300)=20
gen 292524
        key (3828601696256 METADATA_ITEM 0) block 3829181837312 (934858=
847)=20
gen 292524
        key (3828601823232 METADATA_ITEM 0) block 3829157421056 (934852=
886)=20
gen 292524
        key (3828602015744 TREE_BLOCK_REF 32943) block 3829316218880=20=

(934891655) gen 292525
        key (3828602245120 METADATA_ITEM 0) block 3829207601152 (934865=
137)=20
gen 292524
        key (3828602384384 METADATA_ITEM 0) block 3828933246976 (934798=
156)=20
gen 292523
        key (3828602531840 METADATA_ITEM 0) block 3829346013184 (934898=
929)=20
gen 292525
        key (3828602740736 METADATA_ITEM 0) block 3828916629504 (934794=
099)=20
gen 292523
        key (3828602990592 METADATA_ITEM 0) block 3829160525824 (934853=
644)=20
gen 292524
        key (3828603097088 METADATA_ITEM 0) block 3828933267456 (934798=
161)=20
gen 292523
        key (3828603195392 METADATA_ITEM 0) block 4632523673600 (113098=
7225)=20
gen 292474
        key (3828603293696 TREE_BLOCK_REF 32827) block 3829160529920=20=

(934853645) gen 292524
        key (3828603453440 METADATA_ITEM 0) block 3828886011904 (934786=
624)=20
gen 292523
        key (3828603711488 METADATA_ITEM 0) block 3829299806208 (934887=
648)=20
gen 292525
        key (3828603940864 METADATA_ITEM 0) block 3829325082624 (934893=
819)=20
gen 292525
        key (3828604145664 METADATA_ITEM 0) block 3828886040576 (934786=
631)=20
gen 292523
        key (3828604321792 METADATA_ITEM 0) block 3829207818240 (934865=
190)=20
gen 292524
        key (3828604538880 METADATA_ITEM 0) block 3829347282944 (934899=
239)=20
gen 292525
        key (3828604796928 METADATA_ITEM 1) block 3829304320000 (934888=
750)=20
gen 292525
        key (3828605042688 METADATA_ITEM 0) block 3829159145472 (934853=
307)=20
gen 292524
        key (3828605239296 METADATA_ITEM 0) block 3829170442240 (934856=
065)=20
gen 292524
        key (3828605505536 METADATA_ITEM 0) block 3829360103424 (934902=
369)=20
gen 292525
        key (3828605698048 METADATA_ITEM 0) block 3829362032640 (934902=
840)=20
gen 292525
        key (3828605915136 METADATA_ITEM 0) block 3829336616960 (934896=
635)=20
gen 292525
        key (3828606103552 METADATA_ITEM 0) block 3829360107520 (934902=
370)=20
gen 292525
        key (3828606291968 METADATA_ITEM 0) block 3829210537984 (934865=
854)=20
gen 292524
        key (3828606504960 METADATA_ITEM 0) block 3829406662656 (934913=
736)=20
gen 292525
        key (3828606754816 METADATA_ITEM 0) block 3829345562624 (934898=
819)=20
gen 292525
        key (3828606943232 METADATA_ITEM 0) block 3829342674944 (934898=
114)=20
gen 292525
        key (3828607156224 METADATA_ITEM 0) block 3829444628480 (934923=
005)=20
gen 292525
        key (3828607324160 METADATA_ITEM 0) block 3829087207424 (934835=
744)=20
gen 292523
        key (3828607561728 METADATA_ITEM 0) block 3829313220608 (934890=
923)=20
gen 292525
        key (3828607680512 METADATA_ITEM 0) block 3829370867712 (934904=
997)=20
gen 292525
        key (3828607930368 METADATA_ITEM 0) block 3829411094528 (934914=
818)=20
gen 292525
        key (3828608180224 METADATA_ITEM 0) block 3829299822592 (934887=
652)=20
gen 292525

I wonder, though, whether that is still the same block or whether it ha=
s been=20
replaced during the past two weeks of FS usage.

> If it's an extent tree block, then I'm afraid that's the problem.
> Not sure if repair can repair such problem, but at least from what I =
see
> in btrfs-progs fsck self testcases, it doesn't handle extent tree err=
or
> well.

OK

> > ERROR: errors found in extent allocation tree or chunk allocation
> > block group 4722282987520 has wrong amount of free space
> > failed to load free space cache for block group 4722282987520
> > checking free space cache [O]
> > root 32018 inode 95066 errors 100, file extent discount
> >=20
> > Found file extent holes:
> >         start: 413696, len: 4096
> >=20
> > root 32089 inode 95066 errors 100, file extent discount
> >=20
> > Found file extent holes:
> >         start: 413696, len: 4096
> >=20
> > root 32091 inode 95066 errors 100, file extent discount
> >=20
> > Found file extent holes:
> >         start: 413696, len: 4096
> >=20
> > root 32092 inode 95066 errors 100, file extent discount
> >=20
> > Found file extent holes:
> >         start: 413696, len: 4096
> >=20
> > root 32107 inode 95066 errors 100, file extent discount
> >=20
> > Found file extent holes:
> >         start: 413696, len: 4096
> >=20
> > root 32189 inode 95066 errors 100, file extent discount
> >=20
> > Found file extent holes:
> >         start: 413696, len: 4096
> >=20
> > root 32190 inode 95066 errors 100, file extent discount
> >=20
> > Found file extent holes:
> >         start: 413696, len: 4096
> >=20
> > root 32191 inode 95066 errors 100, file extent discount
> >=20
> > Found file extent holes:
> >         start: 413696, len: 4096
> >=20
> > root 32265 inode 95066 errors 100, file extent discount
> >=20
> > Found file extent holes:
> >         start: 413696, len: 4096
> >=20
> > root 32266 inode 95066 errors 100, file extent discount
> >=20
> > Found file extent holes:
> >         start: 413696, len: 4096
> >=20
> > root 32409 inode 95066 errors 100, file extent discount
> >=20
> > Found file extent holes:
> >         start: 413696, len: 4096
> >=20
> > root 32410 inode 95066 errors 100, file extent discount
> >=20
> > Found file extent holes:
> >         start: 413696, len: 4096
> >=20
> > root 32411 inode 95066 errors 100, file extent discount
> >=20
> > Found file extent holes:
> >         start: 413696, len: 4096
> >=20
> > root 32412 inode 95066 errors 100, file extent discount
> >=20
> > Found file extent holes:
> >         start: 413696, len: 4096
> >=20
> > root 32413 inode 95066 errors 100, file extent discount
> >=20
> > Found file extent holes:
> >         start: 413696, len: 4096
> >=20
> > root 32631 inode 95066 errors 100, file extent discount
> >=20
> > Found file extent holes:
> >         start: 413696, len: 4096
> >=20
> > root 32632 inode 95066 errors 100, file extent discount
> >=20
> > Found file extent holes:
> >         start: 413696, len: 4096
> >=20
> > root 32633 inode 95066 errors 100, file extent discount
> >=20
> > Found file extent holes:
> >         start: 413696, len: 4096
> >=20
> > root 32634 inode 95066 errors 100, file extent discount
> >=20
> > Found file extent holes:
> >         start: 413696, len: 4096
> >=20
> > root 32635 inode 95066 errors 100, file extent discount
> >=20
> > Found file extent holes:
> >         start: 413696, len: 4096
> >=20
> > root 32636 inode 95066 errors 100, file extent discount
> >=20
> > Found file extent holes:
> >         start: 413696, len: 4096
> >=20
> > root 32718 inode 95066 errors 100, file extent discount
> >=20
> > Found file extent holes:
> >         start: 413696, len: 4096
> >=20
> > root 32732 inode 95066 errors 100, file extent discount
> >=20
> > Found file extent holes:
> >         start: 413696, len: 4096
>=20
> File extent holes are completely fine, one of the few problems we can=

> fix safely in btrfs-check.

Yeah, I found that out myself by searching my btrfs ML archive.

> But previous extent tree one is not.

OK

> If lowmem mode also reports the same problems only (file extent disco=
unt
> + extent tree error), then there is a chance that --init-extent-tree =
may
> help.
>=20
> But it will be super time consuming though.

Alright, in that case, I'll just reformat the partition and start my ba=
ckups=20
over from scratch once btrfs-check is done running (I'll post the curre=
nt=20
output in another Email).

FWIW, as per my later messages, after mounting with clear_cache and let=
ting=20
btrfs-cleaner finish, btrfs-check did *not* print out those errors afte=
r=20
running again.  It's now about two weeks later that the file system is =
showing=20
problems again.

Oh, and just in case it's relevant, the file system was created with bt=
rfs-
convert (a long time, maybe 1.5 years ago, though; it was originally ex=
t4).

[...]

Greetings
=2D-=20
Marc Joliet
=2D-
"People who think they know everything really annoy those of us who kno=
w we
don't" - Bjarne Stroustrup

--nextPart2511671.9dK3eSEDM9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJYt+lZAAoJEL/Q5oYsiHj0KO4P/2t0oLB0KnH2mK9FlUDc7o3P
MzCc8N2qRymUqXnuzMIoMHcc05Ll457Xs1UxmYhe6D3HWJOQ6YfpQv0pKeO3KRr8
RIhaEfZSVIlmn/Sor4KZG7n+I5UAUpUEtSLSWd1KV8sQ5bMFHx/xhmT8jfH3YOUO
hhC0trT1nF2YFZ4uqgyrBR62Y/7O4B1CpUUTozNTePEk0+Pjm+6V3XP1kMNMCHD7
krAjq19nfdiJMUCMdDfxmX8Ftl6H67Huyx81JOYe1qAkvgwNp9okpW300dX7josr
+EJbbtS8GMhLb0HZ2m2XiPiY3SdX1gYshQ7kRaErH1xAIuTLXNGjnzZLPtiOarLH
NMDF6+3oSKSGfLWutDrVclrmDbPrQORB/2J7uKIj+pQCd+GugbnJYdlY3ehexLw9
IakE9Eg1clzmXoVmNwQux+orbBghfY46zP2kcJqLZ3MZ0c6fDEkjQNIId3tET8Ev
tXkSkm7D6VtW5//eyaRbaesmydjmun0KDue9WYsCJLKLanr7w2bH4Z27Bi3nzO0q
erzSvMG370/k4J6aZEcROO6wQQc/uAntWzJ7VEXQ8IRXs5CEjEmtF6T7xeckopBR
uaM9DQ2gN3aPEvskC7glFDKwDMCAxtdZi5rZbSctxkLtvFEcnz0qaVlnLnHR75r1
X2AOfJOjxDZ/cnl/jNO0
=4bRK
-----END PGP SIGNATURE-----

--nextPart2511671.9dK3eSEDM9--

