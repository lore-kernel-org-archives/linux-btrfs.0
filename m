Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:37693 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753065Ab3AXMlZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Jan 2013 07:41:25 -0500
Date: Thu, 24 Jan 2013 12:41:20 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Miao Xie <miaox@cn.fujitsu.com>
Cc: Alex Lyakas <alex.btrfs@zadarastorage.com>,
        Chen Yang <chenyang.fnst@cn.fujitsu.com>,
        Jan Schmidt <list.btrfs@jan-o-sch.net>,
        Alexander Block <ablock84@googlemail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs/send: sparse and pre-allocated file support for,
 btrfs-send mechanism
Message-ID: <20130124124119.GD19527@carfax.org.uk>
References: <50FF58BC.7090604@cn.fujitsu.com>
 <50FFC3C6.7040305@cn.fujitsu.com>
 <CAOcd+r0cNNaVFJdTVW_2f6u90u-km02mDtwk3H4Vt-YEcHNzzQ@mail.gmail.com>
 <51009455.7040005@cn.fujitsu.com>
 <CAOcd+r0hMRic8=fXNmUSbifAXwnQER8wCkj=mHSBGpQ7fM=LDA@mail.gmail.com>
 <51011D65.3070800@cn.fujitsu.com>
 <20130124115813.GC19527@carfax.org.uk>
 <5101256E.4060603@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jCrbxBqMcLqd4mOl"
In-Reply-To: <5101256E.4060603@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--jCrbxBqMcLqd4mOl
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 24, 2013 at 08:13:34PM +0800, Miao Xie wrote:
> On 	thu, 24 Jan 2013 11:58:13 +0000, Hugo Mills wrote:
> > On Thu, Jan 24, 2013 at 07:39:17PM +0800, Miao Xie wrote:
> >> On thu, 24 Jan 2013 10:53:17 +0200, Alex Lyakas wrote:
> >>> Hi Chen,
> >>> with all due respect, what do you mean by "I see" and "OK for users"?
> >>> The semantics of the fallocate API with/without the
> >>> FALLOC_FL_PUNCH_HOLE flag is not defined by me or you. As far as I
> >>> understand, the file system *must* adhere to the semantics of this
> >>> API, as defined elsewhere.
> >>> Looking, for example, here:
> >>> http://man7.org/linux/man-pages/man2/fallocate.2.html
> >>>
> >>> "Allocating disk space
> >>> The default operation (i.e., mode is zero) of fallocate() allocates
> >>> and initializes to zero the disk space within the range specified by
> >>> offset and len."
> >>>
> >>> "Deallocating file space
> >>> Specifying the FALLOC_FL_PUNCH_HOLE flag (available since Linux
> >>> 2.6.38) in mode deallocates space (i.e., creates a hole) in the byte
> >>> range starting at offset and continuing for len bytes.  Within the
> >>> specified range, partial file system blocks are zeroed, and whole file
> >>> system blocks are removed from the file."
> >>>
> >>> These are clearly two different modes of operation, and I don't think
> >>> you or me can decide otherwise, at this point.
> >>
> >> I think send/receive commands just need ensure the content of the file=
 is
> >> right, not the disk format. That is also the reason why the developers=
 just
> >> send out the zero data when they meet a hole or pre-allocated extent. =
=46rom
> >> this viewpoint, they are the same.
> >=20
> >    I disagree on the "content vs representation" comment above. I
> > would very much hope that the reference receive implementation can
> > turn a string of zeroes (or a hole) back into a sparse file. As a
> > user, I'd be quite irritated if, say, one of my sparse VM images ended
> > up 5 times the size when I backed it up with send/receive, simply
> > because it's gone from holey to a huge bunch of zeroes. That
> > particular issue can be dealt with at the receiver level, though.
>=20
> My explanation is not clear, sorry! What I want to say is send command ne=
edn't
> differentiate between a hole and a pre-allocated extent, because both of =
them
> are considered as zero. So just send out a hole even we meet a pre-alloca=
ted
> extent is OK, I think.

   Ah, gotcha. That sounds more sensible, and I agree with your point
(for what little weight I carry -- I'm not as well-versed in the
behaviour of fallocate as I might be).

   Hugo.

> Thanks
> Miao=20
>=20
> >=20
> >    Hugo.
> >=20
> >>> However, I may be not knowledgeable enough to confirm this.
> >>> Jan/Alexander, can you perhaps comment on this?
> >>>
> >>> Thanks,
> >>> Alex.
> >>>
> >>>
> >>>
> >>>
> >>>
> >>>
> >>>
> >>> On Thu, Jan 24, 2013 at 3:54 AM, Chen Yang <chenyang.fnst@cn.fujitsu.=
com> wrote:
> >>>> =E4=BA=8E 2013-1-23 19:56, Alex Lyakas =E5=86=99=E9=81=93:
> >>>>> Hi,
> >>>>>
> >>>>> On Wed, Jan 23, 2013 at 1:04 PM, Chen Yang <chenyang.fnst@cn.fujits=
u.com> wrote:
> >>>>>> From: Chen Yang <chenyang.fnst@cn.fujitsu.com>
> >>>>>> Date: Wed, 23 Jan 2013 11:21:51 +0800
> >>>>>> Subject: [PATCH] Btrfs/send: sparse and pre-allocated file support=
 for
> >>>>>>  btrfs-send mechanism
> >>>>>>
> >>>>>> When sending a file with sparse or pre-allocated part,
> >>>>>> these parts will be sent as ZERO streams, and it's unnecessary.
> >>>>>>
> >>>>>> There are two ways to improve this, one is just skip the EMPTY par=
ts,
> >>>>>> and the other one is to add a punch command to send, when an EMPTY=
 parts
> >>>>>> was detected. But considering a case of incremental sends, if we c=
hoose
> >>>>>> the first one, when a hole got punched into the file after the ini=
tial
> >>>>>> send, the data will be unchanged on the receiving side when receiv=
ed
> >>>>>> incrementally. So the second choice is right.
> >>>>>>
> >>>>>> Signed-off-by: Cheng Yang <chenyang.fnst@cn.fujitsu.com>
> >>>>>> ---
> >>>>>>  fs/btrfs/send.c |   60 ++++++++++++++++++++++++++++++++++++++++++=
++++++++++++-
> >>>>>>  fs/btrfs/send.h |    3 +-
> >>>>>>  2 files changed, 61 insertions(+), 2 deletions(-)
> >>>>>>
> >>>>>> diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
> >>>>>> index 5445454..31e9aef 100644
> >>>>>> --- a/fs/btrfs/send.c
> >>>>>> +++ b/fs/btrfs/send.c
> >>>>>> @@ -3585,6 +3585,52 @@ out:
> >>>>>>         return ret;
> >>>>>>  }
> >>>>>>
> >>>>>> +static int send_punch(struct send_ctx *sctx, u64 offset, u32 len)
> >>>>>> +{
> >>>>>> +       int ret =3D 0;
> >>>>>> +       struct fs_path *p;
> >>>>>> +       mm_segment_t old_fs;
> >>>>>> +
> >>>>>> +       p =3D fs_path_alloc(sctx);
> >>>>>> +       if (!p)
> >>>>>> +               return -ENOMEM;
> >>>>>> +
> >>>>>> +       /*
> >>>>>> +        * vfs normally only accepts user space buffers for securi=
ty reasons.
> >>>>>> +        * we only read from the file and also only provide the re=
ad_buf buffer
> >>>>>> +        * to vfs. As this buffer does not come from a user space =
call, it's
> >>>>>> +        * ok to temporary allow kernel space buffers.
> >>>>>> +        */
> >>>>>> +       old_fs =3D get_fs();
> >>>>>> +       set_fs(KERNEL_DS);
> >>>>>> +
> >>>>>> +verbose_printk("btrfs: send_fallocate offset=3D%llu, len=3D%d\n",=
 offset, len);
> >>>>>> +
> >>>>>> +       ret =3D open_cur_inode_file(sctx);
> >>>>>> +       if (ret < 0)
> >>>>>> +               goto out;
> >>>>>> +
> >>>>>> +       ret =3D begin_cmd(sctx, BTRFS_SEND_C_PUNCH);
> >>>>>> +       if (ret < 0)
> >>>>>> +               goto out;
> >>>>>> +
> >>>>>> +       ret =3D get_cur_path(sctx, sctx->cur_ino, sctx->cur_inode_=
gen, p);
> >>>>>> +       if (ret < 0)
> >>>>>> +               goto out;
> >>>>>> +
> >>>>>> +       TLV_PUT_PATH(sctx, BTRFS_SEND_A_PATH, p);
> >>>>>> +       TLV_PUT_U64(sctx, BTRFS_SEND_A_FILE_OFFSET, offset);
> >>>>>> +       TLV_PUT_U64(sctx, BTRFS_SEND_A_SIZE, len);
> >>>>>> +
> >>>>>> +       ret =3D send_cmd(sctx);
> >>>>>> +
> >>>>>> +tlv_put_failure:
> >>>>>> +out:
> >>>>>> +       fs_path_free(sctx, p);
> >>>>>> +       set_fs(old_fs);
> >>>>>> +       return ret;
> >>>>>> +}
> >>>>>> +
> >>>>>>  /*
> >>>>>>   * Read some bytes from the current inode/file and send a write c=
ommand to
> >>>>>>   * user space.
> >>>>>> @@ -3718,6 +3764,7 @@ static int send_write_or_clone(struct send_c=
tx *sctx,
> >>>>>>         u64 pos =3D 0;
> >>>>>>         u64 len;
> >>>>>>         u32 l;
> >>>>>> +       u64 bytenr;
> >>>>>>         u8 type;
> >>>>>>
> >>>>>>         ei =3D btrfs_item_ptr(path->nodes[0], path->slots[0],
> >>>>>> @@ -3731,8 +3778,19 @@ static int send_write_or_clone(struct send_=
ctx *sctx,
> >>>>>>                  * sure to send the whole thing
> >>>>>>                  */
> >>>>>>                 len =3D PAGE_CACHE_ALIGN(len);
> >>>>>> -       } else {
> >>>>>> +       } else if (type =3D=3D BTRFS_FILE_EXTENT_REG) {
> >>>>>>                 len =3D btrfs_file_extent_num_bytes(path->nodes[0]=
, ei);
> >>>>>> +               bytenr =3D btrfs_file_extent_disk_bytenr(path->nod=
es[0], ei);
> >>>>>> +               if (bytenr =3D=3D 0) {
> >>>>>> +                       ret =3D send_punch(sctx, offset, len);
> >>>>>> +                       goto out;
> >>>>>> +               }
> >>>>>> +       } else if (type =3D=3D BTRFS_FILE_EXTENT_PREALLOC) {
> >>>>>> +               len =3D btrfs_file_extent_num_bytes(path->nodes[0]=
, ei);
> >>>>>> +               ret =3D send_punch(sctx, offset, len);
> >>>>>> +               goto out;
> >>>>>> +       } else {
> >>>>>> +               BUG();
> >>>>>>         }
> >>>>>
> >>>>> Are these two cases really the same? In the bytenr =3D=3D 0 we want=
 to
> >>>>> deallocate the range. While in the prealloc case, we want to ensure
> >>>>> disk space allocation. Or am I mistaken?
> >>>>> Looking at the receive side, you use the same command for both:
> >>>>> ret =3D fallocate(r->write_fd,
> >>>>>                FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE,
> >>>>>                offset, len);
> >>>>>
> >>>>> Looking at btrfs_fallocate code, in that case it will always punch =
the hole:
> >>>>> static long btrfs_fallocate(struct file *file, int mode,
> >>>>>                           loff_t offset, loff_t len)
> >>>>> ...
> >>>>>       if (mode & FALLOC_FL_PUNCH_HOLE)
> >>>>>               return btrfs_punch_hole(inode, offset, len);
> >>>>>
> >>>>> So maybe you should have two different commands, or add a flag to
> >>>>> distinguish between the two cases?
> >>>>>
> >>>>> Thanks,
> >>>>> Alex.
> >>>>>
> >>>>
> >>>> I see sparse and pre-allocated parts both as EMPTY hole,
> >>>> and although different for a file, it's OK for users.
> >>>>
> >>>> Thanks
> >>>>
> >>>>>
> >>>>>
> >>>>>>
> >>>>>>         if (offset + len > sctx->cur_inode_size)
> >>>>>> diff --git a/fs/btrfs/send.h b/fs/btrfs/send.h
> >>>>>> index 1bf4f32..659ac8f 100644
> >>>>>> --- a/fs/btrfs/send.h
> >>>>>> +++ b/fs/btrfs/send.h
> >>>>>> @@ -20,7 +20,7 @@
> >>>>>>  #include "ctree.h"
> >>>>>>
> >>>>>>  #define BTRFS_SEND_STREAM_MAGIC "btrfs-stream"
> >>>>>> -#define BTRFS_SEND_STREAM_VERSION 1
> >>>>>> +#define BTRFS_SEND_STREAM_VERSION 2
> >>>>>>
> >>>>>>  #define BTRFS_SEND_BUF_SIZE (1024 * 64)
> >>>>>>  #define BTRFS_SEND_READ_SIZE (1024 * 48)
> >>>>>> @@ -80,6 +80,7 @@ enum btrfs_send_cmd {
> >>>>>>         BTRFS_SEND_C_WRITE,
> >>>>>>         BTRFS_SEND_C_CLONE,
> >>>>>>
> >>>>>> +       BTRFS_SEND_C_PUNCH,
> >>>>>>         BTRFS_SEND_C_TRUNCATE,
> >>>>>>         BTRFS_SEND_C_CHMOD,
> >>>>>>         BTRFS_SEND_C_CHOWN,
> >=20
>=20

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
      --- UNIX: British manufacturer of modular shelving units. ---     =20

--jCrbxBqMcLqd4mOl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUQEr779z9OVl50rAAQJwgBAAozPRB8n2GyFmUG2+NhNb6Cwy7UVHqdZP
gfH+Emot2XDp6PviqDEThibTUTVVRnldtKG2Y0PsI38i7Wm1g4lCXoQOywFAT9Px
hjUC2jRDimicyLZs7hWp1gG3s9cdYWOuBSrMwI65ylZ4EMYYYRAcLa3fXeFdifDR
HP25P0C5uLF8/noZ9xS2ERoSg40kugg91//E3uMaYSO5Qe7wnwymynQ5EU9lNWUa
ff0bEZOAyKdSOuIZxMMTKrKY/HDDMzh+G1MnExxTi32BcyOT8LNgLbSNEdM/wz5Z
I7zmg+WL6LvfT9csfcv8vpjGLIHF/at11hrtwWFj267Nr4MSxAUKfemc/524CbPH
Ls+HYEW0zcxEdA0v6PooPC6dKfWRazMxD0Yw7lqEei/jcUCUCYzSZtBaphJw9Jd1
pwxpW3vXO34dRu8uyk3v1i21K+dGvnlMTCeKPRAZMQXD9zmFM69TJaiGS8eqGY4k
/SRLLI+zIi13XgkG/RmL97tKZ0FsA9QpWK07/IOxB/YW04mHVwhJI1IJ15PHldof
EVFLQLRvsSSinkXeTDC0FE7D5k1JwWz8DqSyFHUM+9K9sozfNEk1eYIq3V9izI8w
J3wHzL2K/186/KEwMIsUP+GR7PZlao1raucx4eD1FuC80BZwmqgfozrTyf03bZLx
KiTFGdSPvBs=
=F2Y1
-----END PGP SIGNATURE-----

--jCrbxBqMcLqd4mOl--
