From: Josef Bacik <josef@redhat.com>
Subject: Re: [RFC] make btrfs-image work
Date: Tue, 19 Jan 2010 21:37:36 -0500
Message-ID: <20100120023736.GB16384@localhost.localdomain>
References: <20100119160417.GA16384@localhost.localdomain> <3d0408631001191828v65fbb983w482f478b5ed92bbf@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org
To: "Yan, Zheng " <yanzheng@21cn.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <3d0408631001191828v65fbb983w482f478b5ed92bbf@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 20, 2010 at 10:28:01AM +0800, Yan, Zheng  wrote:
> On Wed, Jan 20, 2010 at 12:04 AM, Josef Bacik <josef@redhat.com> wrot=
e:
> > Hello,
> >
> > btrfs-image would be very helpful for debugging some users problems=
 that we
> > can't reproduce ourselves, but every image that i try and re-create=
 with
> > btrfs-image makes btrfs panic. =A0This is because we zero out the s=
uperblocks
> > chunk array and re-create our uuid. =A0This means that we end up no=
t being able to
> > read the chunk tree on mount, and then even if we could the uuid's =
of the
> > metadata we read back wouldn't match the uuid of the device. =A0The=
 way I've fixed
> > this is to just spit the metadata back onto the disk exactly the wa=
y we got it.
> > The caveat to this I think is that if we try to image a multi-devic=
e setup that
> > it won't work right unless we have a multi-device setup to restore =
the image
> > onto. =A0I'm not sure if thats the goal or not. =A0This patch makes=
 the single disk
> > case work fine for me. =A0Let me know what you think. =A0Thanks,
> >
>=20
> The goal of btrfs-image is create image that can be  examined by btrf=
sck and
> btrfs-debug-tree. btrfs-image creates metadata image for btrfs' logic=
al address
> space. So your patch only works for the uncommon case that btrfs' log=
ical
> address is mapped to offset of device.
>=20

Ok, but I think it would be helpful to be able to restore the fs onto a=
 device
and still be able to use it like a normal fs so we can debug other type=
s of
problems.  But I don't really care that much so if that wasn't the inte=
nded goal
I'll find something else to work on.  Thanks,

Josef
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
