From: "Yan, Zheng " <yanzheng@21cn.com>
Subject: Re: [RFC] make btrfs-image work
Date: Wed, 20 Jan 2010 10:28:01 +0800
Message-ID: <3d0408631001191828v65fbb983w482f478b5ed92bbf@mail.gmail.com>
References: <20100119160417.GA16384@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100119160417.GA16384@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 20, 2010 at 12:04 AM, Josef Bacik <josef@redhat.com> wrote:
> Hello,
>
> btrfs-image would be very helpful for debugging some users problems t=
hat we
> can't reproduce ourselves, but every image that i try and re-create w=
ith
> btrfs-image makes btrfs panic. =A0This is because we zero out the sup=
erblocks
> chunk array and re-create our uuid. =A0This means that we end up not =
being able to
> read the chunk tree on mount, and then even if we could the uuid's of=
 the
> metadata we read back wouldn't match the uuid of the device. =A0The w=
ay I've fixed
> this is to just spit the metadata back onto the disk exactly the way =
we got it.
> The caveat to this I think is that if we try to image a multi-device =
setup that
> it won't work right unless we have a multi-device setup to restore th=
e image
> onto. =A0I'm not sure if thats the goal or not. =A0This patch makes t=
he single disk
> case work fine for me. =A0Let me know what you think. =A0Thanks,
>

The goal of btrfs-image is create image that can be  examined by btrfsc=
k and
btrfs-debug-tree. btrfs-image creates metadata image for btrfs' logical=
 address
space. So your patch only works for the uncommon case that btrfs' logic=
al
address is mapped to offset of device.

Yan, Zheng
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
