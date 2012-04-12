From: Josef Bacik <josef@redhat.com>
Subject: Re: Boot speed/mount time regression with 3.4.0-rc2
Date: Thu, 12 Apr 2012 10:23:50 -0400
Message-ID: <20120412142349.GI1924@localhost.localdomain>
References: <1333986823.2928.6.camel@ayu>
 <1333991404.2817.6.camel@ayu>
 <20120409205429.GB6958@localhost.localdomain>
 <1334006446.2678.0.camel@ayu>
 <20120410151645.GC2296@localhost.localdomain>
 <CAFDW0j+=qe49pX3frjEoozOMz-gKKxqJ+jeeTgyXEskDL_9W8w@mail.gmail.com>
 <20120411170422.GA2506@localhost.localdomain>
 <CAFDW0jJZ16jPn766fdn3Hm=WWkR71n0kJapfPZzgHd3o71b1hQ@mail.gmail.com>
 <20120412133747.GE1924@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: Ahmet Inan <ainan@mathematik.uni-freiburg.de>,
	Calvin Walton <calvin.walton@kepstin.ca>,
	linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120412133747.GE1924@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 12, 2012 at 09:37:48AM -0400, Josef Bacik wrote:
> On Thu, Apr 12, 2012 at 11:22:51AM +0200, Ahmet Inan wrote:
> > On Wed, Apr 11, 2012 at 7:04 PM, Josef Bacik <josef@redhat.com> wro=
te:
> > > On Wed, Apr 11, 2012 at 05:26:29PM +0200, Ahmet Inan wrote:
> > >> On Tue, Apr 10, 2012 at 5:16 PM, Josef Bacik <josef@redhat.com> =
wrote:
> > >> > On Mon, Apr 09, 2012 at 05:20:46PM -0400, Calvin Walton wrote:
> > >> >> On Mon, 2012-04-09 at 16:54 -0400, Josef Bacik wrote:
> > >> >> > On Mon, Apr 09, 2012 at 01:10:04PM -0400, Calvin Walton wro=
te:
> > >> >> > > On Mon, 2012-04-09 at 11:53 -0400, Calvin Walton wrote:
> > >> >> > > > Hi,
> > >> >> > > >
> > >> >> > > > I have a system that's using a dracut-generated initram=
fs to mount a
> > >> >> > > > btrfs root. After upgrading to kernel 3.4.0-rc2 to test=
 it out, I've
> > >> >> > > > noticed that the process of mounting the root filesyste=
m takes much
> > >> >> > > > longer with 3.4.0-rc2 than it did with 3.3.1 - nearly 3=
0 seconds slower!
> > >> >>
> > >> >> > > And the bisect results are in:
> > >> >> > > 285ff5af6ce358e73f53b55c9efadd4335f4c2ff is the first bad=
 commit
> > >> >> > > commit 285ff5af6ce358e73f53b55c9efadd4335f4c2ff
> > >> >> > > Author: Josef Bacik <josef@redhat.com>
> > >> >> > > Date: =A0 Fri Jan 13 15:27:45 2012 -0500
> > >> >> > >
> > >> >> > > =A0 =A0 Btrfs: remove the ideal caching code>
> > >> >> >
> > >> >> > Ok can you give this a whirl? =A0You are going to have to b=
oot/reboot a few times
> > >> >> > to let the cache get re-generated again to make sure it's t=
aken effect, but
> > >> >> > hopefully this will help out. =A0Thanks,
> > >> >>
> > >> >> Unfortunately, it doesn't seem to help. Even after 3 or 4 reb=
oots with
> > >> >> this patch applied I'm still seeing the same delay.
> > >> >>
> > >> >
> > >> > Ok drop that previous patch and give this one a whirl, it help=
ed on my laptop.
> > >> > This is only =A0half of the problem AFAICS, but it's the easie=
r half to fix, in
> > >> > the meantime I need to lock down why we're not writing out cac=
he for a bunch of
> > >> > block groups, but thats trickier since the messages I need are=
 spit out while
> > >> > I'm shutting down, so I need to get creative. =A0Let me know i=
f/how much this
> > >> > helps. =A0Thanks,
> > >>
> > >> i have tried your patch and my system still needs several minute=
s to boot
> > >> until it can be used.
> > >> Also tried to reboot several times - it doesn't look like its ge=
tting better.
> > >> The last thing the system does when its shutting down is a read-=
only
> > >> remount of "/" so no umount.
> > >> Booting was much faster before i pulled for-linus a few weeks ag=
o but
> > >> i couldn't find the time to bisect it yet ..
> > >>
> > >> please also look at the attached dmesg.txt.
> > >> this is an core i3 system with 2x2TB BTRFS RAID1 and lots of
> > >> home directories and snapshots.
> > >>
> > >> I'm going to test this patch on twenty more computers but with
> > >> smaller HDDs and less files and see if it helps to speed up thei=
r
> > >> boot times.
> > >>
> > >
> > > Ok looks like you are running into a different problem. =A0Could =
you maybe run
> > > bootchart and upload the resulting png somewhere so I can look an=
d see what all
> > > is running while you boot? =A0Thanks,
> >=20
> > http://aam.mathematik.uni-freiburg.de/IAM/homepages/ainan/bootchart=
=2Epng
> >=20
> > i have tried your patch now on the twenty more computers i mentione=
d and
> > still it takes a minute to remount rw "/" on those, even after seve=
ral reboots.
> >=20
>=20
> Oops responding to the whole list this time..
>=20
> Um ouch your system appears to not be doing anything for like 300 sec=
onds but
> sitting there.  Can you hook up a console and capture sysrq+w while t=
hats going
> on?  Also you are mounting with -o space_cache right?  Can I see your=
 dmesg to
> make sure it's doing what it's supposed to?  Thanks,
>=20

Ok you don't actually have space_cache enabled it looks like, make sure=
 to add
space_cache to your fstab so it gets enabled, and then reboot a few tim=
es to
make sure everything gets cached right and then it should help.  Thanks=
,

Josef
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
