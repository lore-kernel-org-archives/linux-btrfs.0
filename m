From: Josef Bacik <josef@redhat.com>
Subject: Re: Honest timeline for btrfsck
Date: Thu, 13 Oct 2011 09:02:27 -0400
Message-ID: <20111013130226.GB2310@localhost.localdomain>
References: <20111005061628.GA3702@shiny.elevennetworks.com>
 <CA+JuuGoG1rhQ9S+vfa17BKdekp-A1UeNHqeYEwxfg=Co3Ts_pQ@mail.gmail.com>
 <20111005145843.GA4770@shiny.elevennetworks.com>
 <CA+JuuGq8ODcFDh_KEy3YL_pVJ1=zKDX1SD_9Ou_tHpR4XGhwgQ@mail.gmail.com>
 <m239f550cp.fsf@firstfloor.org>
 <CAD6zcDxvXTZPOO-bXRfuMVWqOGbz8QdfHk=p0LT6Dequb9pmAg@mail.gmail.com>
 <4E8F119C.70006@redhat.com>
 <CAD6zcDyyQH0h34SO8724d07GXr+4=LqZga4NNDr8Zokk7eHNjA@mail.gmail.com>
 <20111012135323.GA2302@localhost.localdomain>
 <CAD6zcDwMPOg=T5mPLZhSC6us-c_YLne1TfJog=taCSzdMtzqsQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: Josef Bacik <josef@redhat.com>,
	Jeff Putney <jeffrey.putney@gmail.com>,
	Chris Mason <chris.mason@oracle.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Francesco Riosa <vivo75@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAD6zcDwMPOg=T5mPLZhSC6us-c_YLne1TfJog=taCSzdMtzqsQ@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 13, 2011 at 02:57:01PM +0200, Francesco Riosa wrote:
> 2011/10/12 Josef Bacik <josef@redhat.com>:
> > On Tue, Oct 11, 2011 at 11:21:45PM +0200, Francesco Riosa wrote:
> >> 2011/10/7 Josef Bacik <josef@redhat.com>:
> >> > On 10/06/2011 04:56 PM, Francesco Riosa wrote:
> >> >> 2011/10/6 Andi Kleen <andi@firstfloor.org>:
> >> >>> Jeff Putney <jeffrey.putney@gmail.com> writes:
> >> >>>>
> >> >>>> http://en.wikipedia.org/wiki/Release_early,_release_often
> >> >>>
> >> >>> Well the other principle in free software you're forgetting
> >> >>> is:
> >> >>>
> >> >>> "It will be released when it's ready"
> >> >>>
> >> >>> If you don't like Chris' ways to do releases you're free to wr=
ite
> >> >>> something on your own or pay someone to do so. Otherwise
> >> >>> you just have to deal with his time frames, as shifty
> >> >>> as they may be.
> >> >>
> >> >> I did a different thing, I've offered Chris money to help rescu=
e an
> >> >> hosed btrfs or to point to someone who could do, we ended in do=
ing
> >> >> some tests (for free) but nothing else materialized.
> >> >> While the time passed has diminished the value of the data to b=
e
> >> >> rescued I'm more on the "show us some code we can start from" t=
han "it
> >> >> will be released when ready" vagon.
> >> >>
> >> >
> >> > If you still need that data, clone this repo
> >> >
> >> > git://github.com/josefbacik/btrfs-progs.git
> >> >
> >> > run make, and then run
> >> >
> >> > ./restore /dev/whatever /some/dir
> >> >
> >> > and it will try and suck all of your data off the disk and dump =
it in
> >> > that directory. =A0If you have snapshots it will skip them by de=
fault, so
> >> > if you have snapshots that have useful data in them you'll want =
to use
> >> > the -s option. =A0If you run into random errors that you think a=
re
> >> > recoverable, or if you don't care about the file that's being re=
covered,
> >> > you can run with -i which will ignore errors and keep trying to =
recover
> >> > your files. =A0Thanks,
> >> >
> >> > Josef
> >> >
> >>
> >> I've tried, w/o luck
> >>
> >> explanation come from 2011-06-21 thread;
> >> http://thread.gmane.org/gmane.comp.file-systems.btrfs/11435
> >> the following refer to a copy of that system
> >>
> >> Label: space02 =A0uuid: f752def1-1abc-48c7-8ebb-47ba37b8ffa6
> >> =A0 =A0 =A0 =A0 Total devices 7 FS bytes used 173.12GB
> >> =A0 =A0 =A0 =A0 devid =A0 =A06 size 488.94GB used 60.25GB path /de=
v/sdd7
> >> =A0 =A0 =A0 =A0 devid =A0 =A02 size 487.65GB used 58.76GB path /de=
v/sdd8
> >> =A0 =A0 =A0 =A0 devid =A0 =A07 size 487.65GB used 0.00 path =A0 =A0=
/dev/sdf7
> >> =A0 =A0 =A0 =A0 devid =A0 =A03 size 487.65GB used 60.26GB path /de=
v/sdf8
> >> =A0 =A0 =A0 =A0 devid =A0 =A07 size 487.65GB used 1.50GB path =A0/=
dev/sdg7
> >> =A0 =A0 =A0 =A0 devid =A0 =A05 size 488.94GB used 58.75GB path /de=
v/sdb7
> >> =A0 =A0 =A0 =A0 devid =A0 =A04 size 487.65GB used 60.26GB path /de=
v/sdb8
> >>
> >> # ./restore /dev/sdd7 /tmp/restore
> >> failed to read /dev/sr0
> >> failed to read /dev/sr0
> >> restore: volumes.c:1367: btrfs_read_sys_array: Assertion `!(ret)' =
failed.
> >> Aborted
> >>
> >
> > So this is kind of a problem since you have multiple disks. =A0We m=
aybe could get
> > away with ignoring a failure, but the problem is if you have data o=
n a disk
> > where we couldn't read the chunk then the chances are we won't be a=
ble to map
> > that file and read the data off. =A0That being said, theres no harm=
 in trying ;).
> > Can you make btrfs_read_sys_array complain about failing, but not a=
ctually BUG?
> > See if that helps you. =A0Thanks,
> >
> > Josef
> >
>=20
> I've tried replacing the "BUG_ON(ret);" to printk("FAILED!!! %d\n", r=
et);
> the diff of the result is reported at the bottom.
>=20

Ok so this is a little trickier, your chunk tree is screwed up.  We nee=
d that to
be intact so we can translate the logical block addresses to physical a=
ddresses,
without that we're screwed because we have no way of knowing where anyt=
hing is.
I'm working on a tool to try and find root items, but currently it also=
 requires
having a working chunk tree.  Once I get finished making it work on a f=
ile
system with an intact chunk tree I'll try and figure out something for
rebuilding a chunk tree.  Thanks,

Josef
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
