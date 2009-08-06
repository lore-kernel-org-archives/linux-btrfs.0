From: Tore Anderson <tore.anderson@redpill-linpro.com>
Subject: Re: Crash in __btrfs_reserve_extent
Date: Thu, 06 Aug 2009 20:14:05 +0200
Message-ID: <4A7B1D6D.6090402@redpill-linpro.com>
References: <4A7A7F9F.1080809@redpill-linpro.com> <4A7A9A04.5010006@redpill-linpro.com> <20090806135436.GD3655@dhcp231-156.rdu.redhat.com> <4A7AE579.1050403@redpill-linpro.com> <20090806142750.GE3655@dhcp231-156.rdu.redhat.com> <4A7B15DD.2010101@redpill-linpro.com> <20090806180432.GG3655@dhcp231-156.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org, Hugo Mills <hugo-lkml@carfax.org.uk>
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090806180432.GG3655@dhcp231-156.rdu.redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

* Josef Bacik

> What kernel are you running?  I need to get a look at what code you
> are on. Thanks for the image, I'm having some trouble getting it to
> work, but I will let you know what I come up with.

I was running 2.6.29.4-167.fc11.i686.PAE at the time of the crash, and
when I've been having problems.  I see that there's a new F11 kernel
out - I'll try to upgrade to that one and will let you know if there's
any change (I doubt it - there's no mention of btrfs-related changes).

Here's the output from btrfs-show, just figured out that I shouldn't
have supplied any arguments (thanks to Robert F=F6rster):

Label: none  uuid: 94762921-dbc0-4faf-a4e5-f5acdaf305a8
	Total devices 1 FS bytes used 15.82GB
	devid    1 size 227.53GB used 227.53GB path /dev/root

I just tried to make a new image with btrfs-image from
btrfs-progs-unstable (using "btrfs-image -c 9 /dev/vg_echo/lv_root
image2.Z").
Unlike when making the first image, the file system was mounted.  The
image is at <http://greed.fud.no/image2.Z> - is that any better?

Best regards,
--=20
Tore Anderson
Redpill Linpro AS - http://www.redpill-linpro.com/
Tel: +47 21 54 41 27
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
