Return-Path: <SRS0=xnYl=RX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF0B0C43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 20 Mar 2019 15:53:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 860AB2183E
	for <linux-btrfs@archiver.kernel.org>; Wed, 20 Mar 2019 15:53:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726828AbfCTPxM (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 20 Mar 2019 11:53:12 -0400
Received: from james.kirk.hungrycats.org ([174.142.39.145]:40154 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726169AbfCTPxM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Mar 2019 11:53:12 -0400
X-Greylist: delayed 420 seconds by postgrey-1.27 at vger.kernel.org; Wed, 20 Mar 2019 11:53:12 EDT
Received: by james.kirk.hungrycats.org (Postfix, from userid 1002)
        id 43E8926F81E; Wed, 20 Mar 2019 11:53:01 -0400 (EDT)
Date:   Wed, 20 Mar 2019 11:46:10 -0400
From:   Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH RFC] btrfs: fix read corrpution from disks of different
 generation
Message-ID: <20190320154609.GE16651@hungrycats.org>
References: <1552995330-28927-1-git-send-email-anand.jain@oracle.com>
 <b458f22f-9833-27bd-dd06-ba2862aa59c4@gmx.com>
 <055cad22-76be-1547-c7f7-4de54dd1049c@oracle.com>
 <36d9d5d6-323c-ebe6-5170-3b2555130bfd@gmx.com>
 <7cbf618b-5a09-16a5-f9e8-483ab3e7bbf3@oracle.com>
 <541e2efd-ae4f-bc06-1d08-46f55208a095@gmx.com>
 <ce5be72e-5fae-932b-4ba7-85e0b3d8b825@oracle.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="N1GIdlSm9i+YlY4t"
Content-Disposition: inline
In-Reply-To: <ce5be72e-5fae-932b-4ba7-85e0b3d8b825@oracle.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


--N1GIdlSm9i+YlY4t
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 20, 2019 at 09:54:16PM +0800, Anand Jain wrote:
>=20
>=20
> On 3/20/19 2:27 PM, Qu Wenruo wrote:
> >=20
> >=20
> > On 2019/3/20 =E4=B8=8B=E5=8D=881:47, Anand Jain wrote:
> > >=20
> > >=20
> > > > > > > A tree based integrity verification
> > > > > > >  =C2=A0=C2=A0 is important for all data, which is missing.
> > > > > > >  =C2=A0=C2=A0 =C2=A0 Fix:
> > > > > > >  =C2=A0=C2=A0=C2=A0=C2=A0 In this RFC patch it proposes to us=
e same disk from with the
> > > > > > > metadata
> > > > > > >  =C2=A0=C2=A0 is read to read the data.
> > > > > >=20
> > > > > > The obvious problem I found is, the idea only works for RAID1/1=
0.
> > > > > >=20
> > > > > > For striped profile it makes no sense, or even have a worse cha=
nce to
> > > > > > get stale data.
> > > > > >=20
> > > > > >=20
> > > > > > To me, the idea of using possible better mirror makes some sens=
e, but
> > > > > > very profile limited.
> > > > >=20
> > > > >  =C2=A0=C2=A0Yep. This problem and fix is only for the mirror bas=
ed profiles
> > > > >  =C2=A0=C2=A0such as raid1/raid10.
> > > >=20
> > > > Then current implementation lacks such check.
> > > >=20
> > > > Further more, data and metadata can lie in different chunks and have
> > > > different chunk types.
> > >=20
> > >  =C2=A0Right. Current tests for this RFC were only for raid1.
> > >=20
> > >  =C2=A0But the final patch can fix that.
> > >=20
> > >  =C2=A0In fact current patch works for all the cases except for the c=
ase of
> > >  =C2=A0replace is running and mix of metadata:raid1 and data:raid56
> > >=20
> > >  =C2=A0We need some cleanups in mirror_num, basically we need to brin=
g it
> > >  =C2=A0under #define. and handle it accordingly in __btrfs_map_block()
> >=20
> >=20
> > Wait for a minute.
> >=20
> > There is a hidden pitfall from the very beginning.
> >=20
> > Consider such chunk layout:
> > Chunk A Type DATA|RAID1
> > Stripe 1: Dev 1
> > Stripe 2: Dev 2
> >=20
> > Chunk B Type METADATA|RAID1
> > Stripe 1: Dev 2
> > Stripe 2: Dev 1
>=20
>  Right this fix can't solve this case.
>  So one down. The other choice I had is to

I think it's more than one down.  I think *only* a handful of scenarios
can work.

What happens if there are 4 disks?

Chunk A Type DATA|RAID1
Stripe 1: Dev 1
Stripe 2: Dev 2

Chunk B Type METADATA|RAID1
Stripe 1: Dev 3
Stripe 2: Dev 4

How do you know if dev 2 lost some data writes, but came back in time
to update the superblock?  Which disk do you plan to read data from if
Dev 3 fails a generation check?

>  Quarantine whole disk by comparing dev1 and dev2 generation # in the
> superblock during mount. or
>  Quarantine whole chunk(s) by comparing dev1 and dev2 generation # in the
> chunk tree during mount. or
>  Always read eb from both dev1 and dev2, if fails then fail its
> corresponding data block as well if any. or
>  During mount compare dev1 and dev2 generation #, record the range of
> generation number missing on the disk. But this need ondisk format change=
s.
> (But nodatacow, notrunc reg data extent write must change gen#). or
>  Similar to btree eb read pages, nest the extent data read as well.
>  (But nodatacow, notrunc reg data extent write must change gen#).

> Thanks, Anand
>=20
>=20
> > Then when we found stale metadata in chunk B mirror 1, caused by dev 2,
> > then your patch consider device 2 stale, and try to use mirror num 2 to
> > read from data chunk.
> >=20
> > However in data chunk, mirror num 2 means it's still from device 2, and
> > we get stale data.
> >=20
> > So the eb->mirror_num can still map to bad/stale device, due to the
> > flexibility provided by btrfs per-chunk mapping.
> >=20
> > Thanks,
> > Qu
> >=20
> > >=20
> > > > > > Another idea I get inspired from the idea is, make it more gene=
ric so
> > > > > > that bad/stale device get a lower priority.
> > > > >=20
> > > > >  =C2=A0=C2=A0When it comes to reading junk data, its not about th=
e priority its
> > > > >  =C2=A0=C2=A0about the eliminating. When the problem is only few =
blocks, I am
> > > > >  =C2=A0=C2=A0against making the whole disk as bad.
> > > > >=20
> > > > > > Although it suffers the same problem as I described.
> > > > > >=20
> > > > > > To make the point short, the use case looks very limited.
> > > > >=20
> > > > >  =C2=A0=C2=A0It applies to raid1/raid10 with nodatacow (which imp=
lies nodatasum).
> > > > >  =C2=A0=C2=A0In my understanding that's not rare.
> > > > >=20
> > > > >  =C2=A0=C2=A0Any comments on the fix offered here?
> > > >=20
> > > > The implementation part is, is eb->read_mirror reliable?
> > > >=20
> > > > E.g. if the data and the eb are in different chunks, and the stale
> > > > happens in the chunk of eb but not in the data chunk?
> > >=20
> > >=20
> > >  =C2=A0eb and regular data are indeed in different chunks always. But=
 eb
> > >  =C2=A0can never be stale as there is parent transid which is verifie=
d against
> > >  =C2=A0the read eb. However we do not have such a check for the data =
(this is
> > >  =C2=A0the core of the issue here) and so we return the junk data sil=
ently.
> > >=20
> > >  =C2=A0Also any idea why the generation number for the extent data is=
 not
> > >  =C2=A0incremented [2] when -o nodatacow and notrunc option is used, =
is it
> > >  =C2=A0a bug? the dump-tree is taken with the script as below [1]
> > >  =C2=A0(this corruption is seen with or without generation number is
> > >  =C2=A0being incremented, but as another way to fix for the corruptio=
n we can
> > >  =C2=A0verify the inode EXTENT_DATA generation from the same disk fro=
m which
> > >  =C2=A0the data is read).
> > >=20
> > > [1]
> > >  =C2=A0umount /btrfs; mkfs.btrfs -fq -dsingle -msingle /dev/sdb && \
> > >  =C2=A0mount -o notreelog,max_inline=3D0,nodatasum /dev/sdb /btrfs &&=
 \
> > >  =C2=A0echo 1st write: && \
> > >  =C2=A0dd status=3Dnone if=3D/dev/urandom of=3D/btrfs/anand bs=3D4096=
 count=3D1
> > > conv=3Dfsync,notrunc && sync && \
> > >  =C2=A0btrfs in dump-tree /dev/sdb | egrep -A7 "257 INODE_ITEM 0\) it=
em" && \
> > >  =C2=A0echo --- && \
> > >  =C2=A0btrfs in dump-tree /dev/sdb=C2=A0 | grep -A4 "257 EXTENT_DATA"=
 && \
> > >  =C2=A0echo 2nd write: && \
> > >  =C2=A0dd status=3Dnone if=3D/dev/urandom of=3D/btrfs/anand bs=3D4096=
 count=3D1
> > > conv=3Dfsync,notrunc && sync && \
> > >  =C2=A0btrfs in dump-tree /dev/sdb | egrep -A7 "257 INODE_ITEM 0\) it=
em" && \
> > >  =C2=A0echo --- && \
> > >  =C2=A0btrfs in dump-tree /dev/sdb=C2=A0 | grep -A4 "257 EXTENT_DATA"
> > >=20
> > >=20
> > > 1st write:
> > >  =C2=A0=C2=A0=C2=A0=C2=A0item 4 key (257 INODE_ITEM 0) itemoff 15881 =
itemsize 160
> > >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 generation 6 transid 6 si=
ze 4096 nbytes 4096
> > >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 block group 0 mode 100644=
 links 1 uid 0 gid 0 rdev 0
> > >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 sequence 1 flags 0x3(NODA=
TASUM|NODATACOW)
> > >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 atime 1553058460.16398545=
2 (2019-03-20 13:07:40)
> > >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ctime 1553058460.16398545=
2 (2019-03-20 13:07:40)
> > >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mtime 1553058460.16398545=
2 (2019-03-20 13:07:40)
> > >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 otime 1553058460.16398545=
2 (2019-03-20 13:07:40)
> > > ---
> > >  =C2=A0=C2=A0=C2=A0=C2=A0item 6 key (257 EXTENT_DATA 0) itemoff 15813=
 itemsize 53
> > >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 generation 6 type 1 (regu=
lar)
> > >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 extent data disk byte 136=
31488 nr 4096
> > >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 extent data offset 0 nr 4=
096 ram 4096
> > >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 extent compression 0 (non=
e)
> > > 2nd write:
> > >  =C2=A0=C2=A0=C2=A0=C2=A0item 4 key (257 INODE_ITEM 0) itemoff 15881 =
itemsize 160
> > >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 generation 6 transid 7 si=
ze 4096 nbytes 4096
> > >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 block group 0 mode 100644=
 links 1 uid 0 gid 0 rdev 0
> > >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 sequence 2 flags 0x3(NODA=
TASUM|NODATACOW)
> > >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 atime 1553058460.16398545=
2 (2019-03-20 13:07:40)
> > >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ctime 1553058460.18998545=
0 (2019-03-20 13:07:40)
> > >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mtime 1553058460.18998545=
0 (2019-03-20 13:07:40)
> > >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 otime 1553058460.16398545=
2 (2019-03-20 13:07:40)
> > > ---
> > >  =C2=A0=C2=A0=C2=A0=C2=A0item 6 key (257 EXTENT_DATA 0) itemoff 15813=
 itemsize 53
> > >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 generation 6 type 1 (regu=
lar)=C2=A0=C2=A0 <----- [2]
> > >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 extent data disk byte 136=
31488 nr 4096
> > >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 extent data offset 0 nr 4=
096 ram 4096
> > >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 extent compression 0 (non=
e)
> > >=20
> > >=20
> > > Thanks, Anand
> >=20

--N1GIdlSm9i+YlY4t
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSnOVjcfGcC/+em7H2B+YsaVrMbnAUCXJJgQQAKCRCB+YsaVrMb
nMR1AKDoBvdECHoCvNJawjtcto5+6Da7IACgnue2Yh+ayBXjJ6gxy84xsD8W8v0=
=Kml/
-----END PGP SIGNATURE-----

--N1GIdlSm9i+YlY4t--
