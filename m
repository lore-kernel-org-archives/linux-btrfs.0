From: Ahmet Inan <ainan@mathematik.uni-freiburg.de>
Subject: Re: Boot speed/mount time regression with 3.4.0-rc2
Date: Thu, 12 Apr 2012 11:22:51 +0200
Message-ID: <CAFDW0jJZ16jPn766fdn3Hm=WWkR71n0kJapfPZzgHd3o71b1hQ@mail.gmail.com>
References: <1333986823.2928.6.camel@ayu>
	<1333991404.2817.6.camel@ayu>
	<20120409205429.GB6958@localhost.localdomain>
	<1334006446.2678.0.camel@ayu>
	<20120410151645.GC2296@localhost.localdomain>
	<CAFDW0j+=qe49pX3frjEoozOMz-gKKxqJ+jeeTgyXEskDL_9W8w@mail.gmail.com>
	<20120411170422.GA2506@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Calvin Walton <calvin.walton@kepstin.ca>,
	linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120411170422.GA2506@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 11, 2012 at 7:04 PM, Josef Bacik <josef@redhat.com> wrote:
> On Wed, Apr 11, 2012 at 05:26:29PM +0200, Ahmet Inan wrote:
>> On Tue, Apr 10, 2012 at 5:16 PM, Josef Bacik <josef@redhat.com> wrot=
e:
>> > On Mon, Apr 09, 2012 at 05:20:46PM -0400, Calvin Walton wrote:
>> >> On Mon, 2012-04-09 at 16:54 -0400, Josef Bacik wrote:
>> >> > On Mon, Apr 09, 2012 at 01:10:04PM -0400, Calvin Walton wrote:
>> >> > > On Mon, 2012-04-09 at 11:53 -0400, Calvin Walton wrote:
>> >> > > > Hi,
>> >> > > >
>> >> > > > I have a system that's using a dracut-generated initramfs t=
o mount a
>> >> > > > btrfs root. After upgrading to kernel 3.4.0-rc2 to test it =
out, I've
>> >> > > > noticed that the process of mounting the root filesystem ta=
kes much
>> >> > > > longer with 3.4.0-rc2 than it did with 3.3.1 - nearly 30 se=
conds slower!
>> >>
>> >> > > And the bisect results are in:
>> >> > > 285ff5af6ce358e73f53b55c9efadd4335f4c2ff is the first bad com=
mit
>> >> > > commit 285ff5af6ce358e73f53b55c9efadd4335f4c2ff
>> >> > > Author: Josef Bacik <josef@redhat.com>
>> >> > > Date: =C2=A0 Fri Jan 13 15:27:45 2012 -0500
>> >> > >
>> >> > > =C2=A0 =C2=A0 Btrfs: remove the ideal caching code>
>> >> >
>> >> > Ok can you give this a whirl? =C2=A0You are going to have to bo=
ot/reboot a few times
>> >> > to let the cache get re-generated again to make sure it's taken=
 effect, but
>> >> > hopefully this will help out. =C2=A0Thanks,
>> >>
>> >> Unfortunately, it doesn't seem to help. Even after 3 or 4 reboots=
 with
>> >> this patch applied I'm still seeing the same delay.
>> >>
>> >
>> > Ok drop that previous patch and give this one a whirl, it helped o=
n my laptop.
>> > This is only =C2=A0half of the problem AFAICS, but it's the easier=
 half to fix, in
>> > the meantime I need to lock down why we're not writing out cache f=
or a bunch of
>> > block groups, but thats trickier since the messages I need are spi=
t out while
>> > I'm shutting down, so I need to get creative. =C2=A0Let me know if=
/how much this
>> > helps. =C2=A0Thanks,
>>
>> i have tried your patch and my system still needs several minutes to=
 boot
>> until it can be used.
>> Also tried to reboot several times - it doesn't look like its gettin=
g better.
>> The last thing the system does when its shutting down is a read-only
>> remount of "/" so no umount.
>> Booting was much faster before i pulled for-linus a few weeks ago bu=
t
>> i couldn't find the time to bisect it yet ..
>>
>> please also look at the attached dmesg.txt.
>> this is an core i3 system with 2x2TB BTRFS RAID1 and lots of
>> home directories and snapshots.
>>
>> I'm going to test this patch on twenty more computers but with
>> smaller HDDs and less files and see if it helps to speed up their
>> boot times.
>>
>
> Ok looks like you are running into a different problem. =C2=A0Could y=
ou maybe run
> bootchart and upload the resulting png somewhere so I can look and se=
e what all
> is running while you boot? =C2=A0Thanks,

http://aam.mathematik.uni-freiburg.de/IAM/homepages/ainan/bootchart.png

i have tried your patch now on the twenty more computers i mentioned an=
d
still it takes a minute to remount rw "/" on those, even after several =
reboots.

Ahmet
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
