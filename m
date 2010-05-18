From: Sean Bartell <wingedtachikoma@gmail.com>
Subject: Re: [PATCH 2/4] btrfs-convert: Add extent iteration functions.
Date: Tue, 18 May 2010 11:37:23 -0400
Message-ID: <20100518153723.GA4380@flcl.lan>
References: <20100320042649.GA17106@flcl.lan>
 <AANLkTil0BsmO29G5Q-gkwXogwJPuL9fbL_kztOv9Us4O@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: linux-btrfs@vger.kernel.org
To: "Yan, Zheng " <yanzheng@21cn.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTil0BsmO29G5Q-gkwXogwJPuL9fbL_kztOv9Us4O@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 18, 2010 at 09:06:54PM +0800, Yan, Zheng  wrote:
> On Sat, Mar 20, 2010 at 12:26 PM, Sean Bartell
> <wingedtachikoma@gmail.com> wrote:
> > +int add_file_disk_extent(struct extent_iterate_data *priv, u64 fil=
e_off,
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0u64 disk_off, u64 =
size)
> > +{
> > + =A0 =A0 =A0 BUG_ON(file_off < priv->last_file_off);
> > + =A0 =A0 =A0 int ret;
> > + =A0 =A0 =A0 u64 sectorsize =3D priv->root->sectorsize;
> > + =A0 =A0 =A0 u64 mask =3D sectorsize - 1;
> > + =A0 =A0 =A0 if (size =3D=3D 0)
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
> > + =A0 =A0 =A0 if ((file_off & mask) !=3D (disk_off & mask)) {
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* It's unclear how to CoW this, so d=
on't. */
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 char *data =3D malloc(size);
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!data)
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENOMEM;
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D read_disk_extent(priv->root, =
disk_off, size, data);
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ret) {
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 free(data);
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return ret;
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D add_file_mem_extent(priv, fil=
e_off, size, data);
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 free(data);
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return ret;
> > + =A0 =A0 =A0 }
> > + =A0 =A0 =A0 if (priv->type =3D=3D EXTENT_ITERATE_TYPE_DISK
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 && priv->file_off + p=
riv->size =3D=3D file_off
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 && priv->disk_off + p=
riv->size =3D=3D disk_off) {
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* It's a continuation of the same di=
sk extent. */
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 priv->size +=3D size;
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
> > + =A0 =A0 =A0 }
> > + =A0 =A0 =A0 if (disk_off =3D=3D 0 || disk_off & mask) {
>=20
> why "disk_off =3D=3D 0" is needed here?

To btrfs, a disk offset of 0 represents a sparse extent. If the origina=
l
filesystem passes in an extent at 0, this chops off the first block to
prevent it from being mistakenly interpreted as a sparse extent.

> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* We need to have an aligned start, =
so give the first part to
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* add_file_mem_extent if necessary=
=2E */
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 u64 mem_size =3D min_t(u64, sectorsiz=
e - (disk_off & mask), size);
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 char *data =3D malloc(mem_size);
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!data)
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENOMEM;
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D read_disk_extent(priv->root, =
disk_off, mem_size, data);
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ret) {
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 free(data);
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return ret;
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D add_file_mem_extent(priv, fil=
e_off, mem_size, data);
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 free(data);
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ret)
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return ret;
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 file_off +=3D mem_size;
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 disk_off +=3D mem_size;
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 size -=3D mem_size;
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (size =3D=3D 0)
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
> > + =A0 =A0 =A0 }
> > + =A0 =A0 =A0 ret =3D commit_file_extents(priv);
> > + =A0 =A0 =A0 if (ret)
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return ret;
> > + =A0 =A0 =A0 priv->type =3D EXTENT_ITERATE_TYPE_DISK;
> > + =A0 =A0 =A0 priv->size =3D size;
> > + =A0 =A0 =A0 priv->file_off =3D file_off;
> > + =A0 =A0 =A0 priv->disk_off =3D disk_off;
> > + =A0 =A0 =A0 return 0;
> > +}
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
