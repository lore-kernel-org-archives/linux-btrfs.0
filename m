From: Josef Bacik <josef@redhat.com>
Subject: Re: Crash in __btrfs_reserve_extent
Date: Thu, 6 Aug 2009 14:37:13 -0400
Message-ID: <20090806183712.GH3655@dhcp231-156.rdu.redhat.com>
References: <4A7A7F9F.1080809@redpill-linpro.com> <4A7A9A04.5010006@redpill-linpro.com> <20090806135436.GD3655@dhcp231-156.rdu.redhat.com> <4A7AE579.1050403@redpill-linpro.com> <20090806142750.GE3655@dhcp231-156.rdu.redhat.com> <4A7B15DD.2010101@redpill-linpro.com> <20090806180432.GG3655@dhcp231-156.rdu.redhat.com> <4A7B1D6D.6090402@redpill-linpro.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org,
	Hugo Mills <hugo-lkml@carfax.org.uk>
To: Tore Anderson <tore.anderson@redpill-linpro.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4A7B1D6D.6090402@redpill-linpro.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 06, 2009 at 08:14:05PM +0200, Tore Anderson wrote:
> * Josef Bacik
>=20
> > What kernel are you running?  I need to get a look at what code you
> > are on. Thanks for the image, I'm having some trouble getting it to
> > work, but I will let you know what I come up with.
>=20
> I was running 2.6.29.4-167.fc11.i686.PAE at the time of the crash, an=
d
> when I've been having problems.  I see that there's a new F11 kernel
> out - I'll try to upgrade to that one and will let you know if there'=
s
> any change (I doubt it - there's no mention of btrfs-related changes)=
=2E
>=20
> Here's the output from btrfs-show, just figured out that I shouldn't
> have supplied any arguments (thanks to Robert F=F6rster):
>=20
> Label: none  uuid: 94762921-dbc0-4faf-a4e5-f5acdaf305a8
> 	Total devices 1 FS bytes used 15.82GB
> 	devid    1 size 227.53GB used 227.53GB path /dev/root
>=20
> I just tried to make a new image with btrfs-image from
> btrfs-progs-unstable (using "btrfs-image -c 9 /dev/vg_echo/lv_root
> image2.Z").
> Unlike when making the first image, the file system was mounted.  The
> image is at <http://greed.fud.no/image2.Z> - is that any better?
>=20

Ok good news is, btrfs-vol -b will fix your problem.  Somehow most of y=
our disk has
been allocated to use metadata.  So did you have a whole bunch of stuff=
 on this
disk and then delete it all?  Because that would put you in that situat=
ion.  If
you have not then there is likely a bug in the metadata ratio stuff tha=
t needs
to be fixed.  Thankfully btrfs-vol -b will move everything around so yo=
u are
good to go, so if it is a bug that will keep you going until I can find=
 and fix
the problem.  btrfs-vol -b will take a while to run, so don't worry if =
it sits
there forever, you can run dmesg to watch its progress.  Let me know if=
 you had
a bunch of stuff on this disk that you deleted, cause if there was good=
 reason
for it to allocate all this metadata space then thats fine, but if not =
I need to
start looking at a root cause.  Thanks,

Josef
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
