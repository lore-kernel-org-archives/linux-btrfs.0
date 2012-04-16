From: David Sterba <dave@jikos.cz>
Subject: Re: Errors in rebalancing RAID1 array after disk failure.
Date: Mon, 16 Apr 2012 15:46:43 +0200
Message-ID: <20120416134643.GA20982@twin.jikos.cz>
References: <CADy=jfVRz5UuKcFkDXC9hwZnP8Z=E9NuF9p3hE6b0ZC06k7DWg@mail.gmail.com>
 <CADy=jfWC1vJs_TWt-EmvAN2Ybqw8kjN2tFV_vgAb-OKeGMpotg@mail.gmail.com>
 <CADy=jfV9pKJurcormuMK7KW54-DKSvYns-Ow-T_FEELGmFQ18Q@mail.gmail.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: linux-btrfs@vger.kernel.org
To: "Marco L. Crociani" <marco.crociani@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CADy=jfV9pKJurcormuMK7KW54-DKSvYns-Ow-T_FEELGmFQ18Q@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Apr 14, 2012 at 06:39:12PM +0200, Marco L. Crociani wrote:
> Apr 14 18:07:52 evo kernel: [=A0 431.054709] btrfs: relocating block
> group 1401002393600 flags 17
> Apr 14 18:08:14 evo kernel: [=A0 453.506541] btrfs csum failed ino 36=
2
> off 910946304 csum 432355644 private 175165154

The failed checksums prevent balance to relocate the blockgroup, which
is a needed step during 'dev delete'. Unless the csum is fixable by
using another copy, I think the only option left is to delete the file
(not counting the unsafe way of resetting the block's cheksum).


david
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
