Return-Path: <SRS0=xnYl=RX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77A08C43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 20 Mar 2019 15:40:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 445D72146E
	for <linux-btrfs@archiver.kernel.org>; Wed, 20 Mar 2019 15:40:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726795AbfCTPkw (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 20 Mar 2019 11:40:52 -0400
Received: from james.kirk.hungrycats.org ([174.142.39.145]:38046 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725988AbfCTPkw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Mar 2019 11:40:52 -0400
Received: by james.kirk.hungrycats.org (Postfix, from userid 1002)
        id 9BA8326F7A3; Wed, 20 Mar 2019 11:40:49 -0400 (EDT)
Date:   Wed, 20 Mar 2019 11:40:48 -0400
From:   Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH RFC] btrfs: fix read corrpution from disks of different
 generation
Message-ID: <20190320154048.GD16651@hungrycats.org>
References: <1552995330-28927-1-git-send-email-anand.jain@oracle.com>
 <b458f22f-9833-27bd-dd06-ba2862aa59c4@gmx.com>
 <055cad22-76be-1547-c7f7-4de54dd1049c@oracle.com>
 <36d9d5d6-323c-ebe6-5170-3b2555130bfd@gmx.com>
 <7cbf618b-5a09-16a5-f9e8-483ab3e7bbf3@oracle.com>
 <2efdd0a5-cc4b-28a8-226b-a0ad060b10b8@gmx.com>
 <503ae9ba-a78b-5b52-4d8f-babf42a6bc11@oracle.com>
 <0a922843-9223-5771-c6d6-16d1c2ddcc98@gmx.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="eqp4TxRxnD4KrmFZ"
Content-Disposition: inline
In-Reply-To: <0a922843-9223-5771-c6d6-16d1c2ddcc98@gmx.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


--eqp4TxRxnD4KrmFZ
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 20, 2019 at 10:40:07PM +0800, Qu Wenruo wrote:
>=20
>=20
> On 2019/3/20 =E4=B8=8B=E5=8D=8810:00, Anand Jain wrote:
> >=20
> >>> =C2=A0=C2=A0Also any idea why the generation number for the extent da=
ta is not
> >>> =C2=A0=C2=A0incremented [2] when -o nodatacow and notrunc option is u=
sed, is it
> >>> =C2=A0=C2=A0a bug? the dump-tree is taken with the script as below [1]
> >>> =C2=A0=C2=A0(this corruption is seen with or without generation numbe=
r is
> >>> =C2=A0=C2=A0being incremented, but as another way to fix for the corr=
uption we can
> >>> =C2=A0=C2=A0verify the inode EXTENT_DATA generation from the same dis=
k from which
> >>> =C2=A0=C2=A0the data is read).
> >>
> >> For the generation part, it's the generation when data is written to
> >> disk.
> >>
> >> Truncation/nocow overwrite shouldn't really change the generation of
> >> existing file extents.
> >>
> >> So I'm afraid you can't use that generation to do the check.
> >=20
> > =C2=A0Any idea why it shouldn't change? Albeit there isn't new allocati=
on
> > =C2=A0due to nodatacow and notrunc overwrite, but sure data is overwrit=
ten.

The references to the extent in the subvol trees hold a copy of the
extent's generation, so if the extent's generation is modified, all the
references to the extent in all the subvol trees have to be modified too,
or they fail transid verification later on.  Compared to pure datacow
(nodatasum, compress=3Dnone), this would be the same number of iops, only
fragmentation can be saved because of block overwrites (and even that
isn't saved all the time).

> > =C2=A0If that's the case then I would guess there will be bug in send r=
eceive
> > =C2=A0as well.

Send requires a read-only snapshot, and the snapshot's reference to
the nodatacow extents automatically turns on datacow for those extents.
Thus, send behaves correctly because nodatacow is disabled.

The nodatacow flag is advisory.  It doesn't prevent btrfs from relocating
data when needed.

> I'm not sure about the send part.
>=20
> On the other hand, if btrfs is going to update the generation of
> nodatacow file extent overwrite, it should cause pretty big performance
> degradation.
>=20
> The idea of nodatacow is to skip all the expensive csum, extent
> allocation (maybe not that expensive) and the race of subvol tree.

nodatacow also skips RAID data integrity checks.  Generally, applications
and admins should plan for any data put in a nodatacow file to be silently
corrupted at any time, i.e. the same situation as an ext4-on-mdadm setup.
This is the price for minimizing the overhead for a write to a nodatacow
extent.

> If we're going to update file extents for such case, we're re-introduce
> performance impact to users who don't want that impact at all.
> I don't believe it's worthy at all.
>=20
> Thanks,
> Qu
>=20
> >=20
> > Thanks, Anand
> >=20
> >> Thanks,
> >> Qu
> >>
> >>>
> >>> [1]
> >>> =C2=A0=C2=A0umount /btrfs; mkfs.btrfs -fq -dsingle -msingle /dev/sdb =
&& \
> >>> =C2=A0=C2=A0mount -o notreelog,max_inline=3D0,nodatasum /dev/sdb /btr=
fs && \
> >>> =C2=A0=C2=A0echo 1st write: && \
> >>> =C2=A0=C2=A0dd status=3Dnone if=3D/dev/urandom of=3D/btrfs/anand bs=
=3D4096 count=3D1
> >>> conv=3Dfsync,notrunc && sync && \
> >>> =C2=A0=C2=A0btrfs in dump-tree /dev/sdb | egrep -A7 "257 INODE_ITEM 0=
\) item" && \
> >>> =C2=A0=C2=A0echo --- && \
> >>> =C2=A0=C2=A0btrfs in dump-tree /dev/sdb=C2=A0 | grep -A4 "257 EXTENT_=
DATA" && \
> >>> =C2=A0=C2=A0echo 2nd write: && \
> >>> =C2=A0=C2=A0dd status=3Dnone if=3D/dev/urandom of=3D/btrfs/anand bs=
=3D4096 count=3D1
> >>> conv=3Dfsync,notrunc && sync && \
> >>> =C2=A0=C2=A0btrfs in dump-tree /dev/sdb | egrep -A7 "257 INODE_ITEM 0=
\) item" && \
> >>> =C2=A0=C2=A0echo --- && \
> >>> =C2=A0=C2=A0btrfs in dump-tree /dev/sdb=C2=A0 | grep -A4 "257 EXTENT_=
DATA"
> >>>
> >>>
> >>> 1st write:
> >>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0item 4 key (257 INODE_ITEM 0) itemoff 1=
5881 itemsize 160
> >>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 generation 6 transid=
 6 size 4096 nbytes 4096
> >>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 block group 0 mode 1=
00644 links 1 uid 0 gid 0 rdev 0
> >>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 sequence 1 flags 0x3=
(NODATASUM|NODATACOW)
> >>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 atime 1553058460.163=
985452 (2019-03-20 13:07:40)
> >>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ctime 1553058460.163=
985452 (2019-03-20 13:07:40)
> >>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mtime 1553058460.163=
985452 (2019-03-20 13:07:40)
> >>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 otime 1553058460.163=
985452 (2019-03-20 13:07:40)
> >>> ---
> >>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0item 6 key (257 EXTENT_DATA 0) itemoff =
15813 itemsize 53
> >>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 generation 6 type 1 =
(regular)
> >>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 extent data disk byt=
e 13631488 nr 4096
> >>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 extent data offset 0=
 nr 4096 ram 4096
> >>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 extent compression 0=
 (none)
> >>> 2nd write:
> >>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0item 4 key (257 INODE_ITEM 0) itemoff 1=
5881 itemsize 160
> >>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 generation 6 transid=
 7 size 4096 nbytes 4096
> >>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 block group 0 mode 1=
00644 links 1 uid 0 gid 0 rdev 0
> >>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 sequence 2 flags 0x3=
(NODATASUM|NODATACOW)
> >>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 atime 1553058460.163=
985452 (2019-03-20 13:07:40)
> >>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ctime 1553058460.189=
985450 (2019-03-20 13:07:40)
> >>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mtime 1553058460.189=
985450 (2019-03-20 13:07:40)
> >>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 otime 1553058460.163=
985452 (2019-03-20 13:07:40)
> >>> ---
> >>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0item 6 key (257 EXTENT_DATA 0) itemoff =
15813 itemsize 53
> >>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 generation 6 type 1 =
(regular)=C2=A0=C2=A0 <----- [2]
> >>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 extent data disk byt=
e 13631488 nr 4096
> >>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 extent data offset 0=
 nr 4096 ram 4096
> >>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 extent compression 0=
 (none)
> >>>
> >>>
> >>> Thanks, Anand
> >>
>=20




--eqp4TxRxnD4KrmFZ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSnOVjcfGcC/+em7H2B+YsaVrMbnAUCXJJe/QAKCRCB+YsaVrMb
nLUmAJ4lVHOFCjdL8itFWQHoTLwAPe/MzwCdHMN6rciwmr/4Krpe8Sm5cqTEREQ=
=MvIk
-----END PGP SIGNATURE-----

--eqp4TxRxnD4KrmFZ--
