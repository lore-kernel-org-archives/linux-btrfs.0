From: Ted Phelps <phelps@gnusto.com>
Subject: Re: btrfsck core dump
Date: Tue, 29 Dec 2009 19:17:27 +1000
Message-ID: <26236.1262078247@laika.gnusto.com>
References: <200912290426.nBT4QnfQ012260@laika.gnusto.com> <3d0408630912290046i6514f924j7e4ed4fb87ea0463@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: linux-btrfs@vger.kernel.org
To: "Yan\, Zheng " <yanzheng@21cn.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: Your message of Tue, 29 Dec 2009 16:46:09 +0800.
	<3d0408630912290046i6514f924j7e4ed4fb87ea0463@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Yan, Zheng writes:
> On Tue, Dec 29, 2009 at 12:26 PM, Ted Phelps <phelps@gnusto.com> wrot=
e:
> > My btrfs test partition started failing btrfsck (0.19) today, which=
 may
> > be of interest. =C2=A0What's probably more interesting is that git =
head
> > version of btrfsck reliably crashes when pointed at the filesystem.
> > What's more interesting still is that, after unmounting the filesys=
tem,
> > btrfsck (both 0.19 and git head) finds no errors. =C2=A0I have to a=
dmit that
> > I find this a bit confusing. =C2=A0Is this expected behavior?
>=20
> btrfsck doesn't support checking mounted fs.

Ok, that's reasonable.  I recognize that the tools are very new and tha=
t
there are many things to be done, but it would be nice if this
restriction were mentioned in the btrfsck man page so that the next
person to try this doesn't think that his filesystem is corrupt.

Of course, it would be nicer still if btrfsck refused to operate on a
mounted filesystem, and if it didn't crash when presented with a
"damaged" filesystem, though I can see that such bells and whistles
might not be your top priority at the moment.

Thanks,
-Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
