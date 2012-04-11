From: Josef Bacik <josef@redhat.com>
Subject: Re: Boot speed/mount time regression with 3.4.0-rc2
Date: Wed, 11 Apr 2012 13:04:22 -0400
Message-ID: <20120411170422.GA2506@localhost.localdomain>
References: <1333986823.2928.6.camel@ayu>
 <1333991404.2817.6.camel@ayu>
 <20120409205429.GB6958@localhost.localdomain>
 <1334006446.2678.0.camel@ayu>
 <20120410151645.GC2296@localhost.localdomain>
 <CAFDW0j+=qe49pX3frjEoozOMz-gKKxqJ+jeeTgyXEskDL_9W8w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: Josef Bacik <josef@redhat.com>,
	Calvin Walton <calvin.walton@kepstin.ca>,
	linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
To: Ahmet Inan <ainan@mathematik.uni-freiburg.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAFDW0j+=qe49pX3frjEoozOMz-gKKxqJ+jeeTgyXEskDL_9W8w@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 11, 2012 at 05:26:29PM +0200, Ahmet Inan wrote:
> On Tue, Apr 10, 2012 at 5:16 PM, Josef Bacik <josef@redhat.com> wrote=
:
> > On Mon, Apr 09, 2012 at 05:20:46PM -0400, Calvin Walton wrote:
> >> On Mon, 2012-04-09 at 16:54 -0400, Josef Bacik wrote:
> >> > On Mon, Apr 09, 2012 at 01:10:04PM -0400, Calvin Walton wrote:
> >> > > On Mon, 2012-04-09 at 11:53 -0400, Calvin Walton wrote:
> >> > > > Hi,
> >> > > >
> >> > > > I have a system that's using a dracut-generated initramfs to=
 mount a
> >> > > > btrfs root. After upgrading to kernel 3.4.0-rc2 to test it o=
ut, I've
> >> > > > noticed that the process of mounting the root filesystem tak=
es much
> >> > > > longer with 3.4.0-rc2 than it did with 3.3.1 - nearly 30 sec=
onds slower!
> >>
> >> > > And the bisect results are in:
> >> > > 285ff5af6ce358e73f53b55c9efadd4335f4c2ff is the first bad comm=
it
> >> > > commit 285ff5af6ce358e73f53b55c9efadd4335f4c2ff
> >> > > Author: Josef Bacik <josef@redhat.com>
> >> > > Date: =A0 Fri Jan 13 15:27:45 2012 -0500
> >> > >
> >> > > =A0 =A0 Btrfs: remove the ideal caching code>
> >> >
> >> > Ok can you give this a whirl? =A0You are going to have to boot/r=
eboot a few times
> >> > to let the cache get re-generated again to make sure it's taken =
effect, but
> >> > hopefully this will help out. =A0Thanks,
> >>
> >> Unfortunately, it doesn't seem to help. Even after 3 or 4 reboots =
with
> >> this patch applied I'm still seeing the same delay.
> >>
> >
> > Ok drop that previous patch and give this one a whirl, it helped on=
 my laptop.
> > This is only =A0half of the problem AFAICS, but it's the easier hal=
f to fix, in
> > the meantime I need to lock down why we're not writing out cache fo=
r a bunch of
> > block groups, but thats trickier since the messages I need are spit=
 out while
> > I'm shutting down, so I need to get creative. =A0Let me know if/how=
 much this
> > helps. =A0Thanks,
>=20
> i have tried your patch and my system still needs several minutes to =
boot
> until it can be used.
> Also tried to reboot several times - it doesn't look like its getting=
 better.
> The last thing the system does when its shutting down is a read-only
> remount of "/" so no umount.
> Booting was much faster before i pulled for-linus a few weeks ago but
> i couldn't find the time to bisect it yet ..
>=20
> please also look at the attached dmesg.txt.
> this is an core i3 system with 2x2TB BTRFS RAID1 and lots of
> home directories and snapshots.
>=20
> I'm going to test this patch on twenty more computers but with
> smaller HDDs and less files and see if it helps to speed up their
> boot times.
>=20

Ok looks like you are running into a different problem.  Could you mayb=
e run
bootchart and upload the resulting png somewhere so I can look and see =
what all
is running while you boot?  Thanks,

Josef
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
