From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH] fs: make i_generation a u64
Date: Thu, 12 Apr 2012 09:20:52 -0400
Message-ID: <20120412132052.GB1924@localhost.localdomain>
References: <1334176968-8687-1-git-send-email-josef@redhat.com>
 <CANGUGtBHNHE0=GQg-Hv1YUaYNhpt9F5-9qt+_UQ6fkCL__gxaQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: Josef Bacik <josef@redhat.com>, linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, viro@zeniv.linux.org.uk
To: Marco Stornelli <marco.stornelli@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CANGUGtBHNHE0=GQg-Hv1YUaYNhpt9F5-9qt+_UQ6fkCL__gxaQ@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 12, 2012 at 08:46:14AM +0200, Marco Stornelli wrote:
> 2012/4/11 Josef Bacik <josef@redhat.com>:
> > Btrfs stores generation numbers as 64bit numbers, which means we ha=
ve to
> > carry around a u64 in our incore inode in addition to setting i_gen=
eration.
> > So convert to a u64 so btrfs can kill it's incore generation. =A0Th=
anks,
> >
> > Signed-off-by: Josef Bacik <josef@redhat.com>
> > ---
> > =A0include/linux/fs.h | =A0 =A02 +-
> > =A01 files changed, 1 insertions(+), 1 deletions(-)
> >
> > diff --git a/include/linux/fs.h b/include/linux/fs.h
> > index 9be896d..40564e0 100644
> > --- a/include/linux/fs.h
> > +++ b/include/linux/fs.h
> > @@ -831,7 +831,7 @@ struct inode {
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct cdev =A0 =A0 =A0 =A0 =A0 =A0 =
*i_cdev;
> > =A0 =A0 =A0 =A0};
> >
> > - =A0 =A0 =A0 __u32 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 i_generatio=
n;
> > + =A0 =A0 =A0 u64 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 i_generat=
ion;
> >
> > =A0#ifdef CONFIG_FSNOTIFY
> > =A0 =A0 =A0 =A0__u32 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 i_fsnotify=
_mask; /* all events this inode cares about */
> > --
> > 1.7.7.6
>=20
> This patch can have several impact on other fs. Only to do an example
> you can see the code in ioctl of ext4. I haven't got study the code
> but the ioctl returns a long, but on 32bit system, long means 4 bytes=
,
> so how we can return i_generation with ioctl?
>=20

Thanks for pointing this out, I will fix ext4 up and look to see if any=
body else
does something similar,

Josef
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
