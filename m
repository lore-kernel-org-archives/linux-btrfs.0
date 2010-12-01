From: C Anthony Risinger <anthony@extof.me>
Subject: Re: What to do about subvolumes?
Date: Wed, 1 Dec 2010 08:51:55 -0600
Message-ID: <AANLkTin_xq7u1Xf9FVOskbKed5WDw1AAvDh8mhConCLX@mail.gmail.com>
References: <20101201142136.GD427@dhcp231-156.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	chris.mason@oracle.com, hch@lst.de, ssorce@redhat.com
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101201142136.GD427@dhcp231-156.rdu.redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 1, 2010 at 8:21 AM, Josef Bacik <josef@redhat.com> wrote:
>
> =3D=3D=3D How do we want subvolumes to work from a user perspective? =
=3D=3D=3D
>
> 1) Users need to be able to create their own subvolumes. =A0The permi=
ssion
> semantics will be absolutely the same as creating directories, so I d=
on't think
> this is too tricky. =A0We want this because you can only take snapsho=
ts of
> subvolumes, and so it is important that users be able to create their=
 own
> discrete snapshottable targets.
>
> 2) Users need to be able to snapshot their subvolumes. =A0This is bas=
ically the
> same as #1, but it bears repeating.

could it be possible to convert a directory into a volume?  or at
least base a snapshot off it?

C Anthony
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
