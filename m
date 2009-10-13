From: "Yan, Zheng " <yanzheng@21cn.com>
Subject: Re: ENOSPC at 94% full -- and causing BUGs elsewhere?
Date: Wed, 14 Oct 2009 07:19:27 +0800
Message-ID: <3d0408630910131619v62e0959aj917951b652885a8b@mail.gmail.com>
References: <20091003122109.GB3116@selene>
	 <20091003215531.GG4350@dhcp231-156.rdu.redhat.com>
	 <20091004120630.GA19916@think>
	 <20091012140935.GA8550@vlad.carfax.org.uk>
	 <20091013103145.GC8830@think>
	 <20091013145007.GA5393@vlad.carfax.org.uk>
	 <3d0408630910130758h7963d85fx5343c531632fa79@mail.gmail.com>
	 <20091013160909.GB5393@vlad.carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Hugo Mills <hugo-lkml@carfax.org.uk>,
	"Yan, Zheng" <yanzheng@21cn.com>,
	Chris Mason <chris.mason@oracle.com>,
	Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20091013160909.GB5393@vlad.carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 14, 2009 at 12:09 AM, Hugo Mills <hugo-lkml@carfax.org.uk> =
wrote:
> On Tue, Oct 13, 2009 at 10:58:12PM +0800, Yan, Zheng =A0wrote:
>> On Tue, Oct 13, 2009 at 10:50 PM, Hugo Mills <hugo-lkml@carfax.org.u=
k> wrote:
>> > On Tue, Oct 13, 2009 at 06:31:45AM -0400, Chris Mason wrote:
>> >> On Mon, Oct 12, 2009 at 03:09:35PM +0100, Hugo Mills wrote:
>> >> > On Sun, Oct 04, 2009 at 08:06:30AM -0400, Chris Mason wrote:
>> >> > > On Sat, Oct 03, 2009 at 05:55:32PM -0400, Josef Bacik wrote:
>> >> > > > On Sat, Oct 03, 2009 at 01:21:09PM +0100, Hugo Mills wrote:
>> >> > > > > =A0 =A0I've just had the following on my home server. I b=
elieve that it's
>> >> > > > > btrfs that's responsible, as the machine wasn't doing muc=
h other than
>> >> > > > > reading/writing on a btrfs filesystem. The process that w=
as doing so
>> >> > > > > is now stuck in D+ state, and can't be killed. The timing=
 of the oops
>> >> > > > > at the end is also suggestive of being involved in the sa=
me incident.
>> >> > > > > This is the only btrfs filesystem on the machine.
>> >> > > >
>> >> > > > Patches have gone to Linus to fix the enospc problems. =A0Y=
ou can try running the
>> >> > > > enospc branch of Chris's git tree and it should behave bett=
er for you. =A0Thanks,
>> >> > >
>> >> > > The right tree for this is the master branch of btrfs-unstabl=
e for
>> >> > > 2.6.31.
>> >> >
>> >> > =A0 =A0Thanks, Josef and Chris. I've now found the time to chec=
k out and
>> >> > build the btrfs-unstable tree, and it is indeed handling the EN=
OSPC
>> >> > condition much more cleanly.
>> >> >
>> >> > =A0 =A0However, it seems to have got into a position where I ha=
ve lots of
>> >> > free space reported by df (over 10% of the size of the volume -=
- 185
>> >> > GiB free of 1474 GiB total), but still refuses to write anythin=
g to
>> >> > the filesystem. Do you have any suggestions for what I could tr=
y?
>> >>
>> >> You've probably got most of that 10GB free allocated as metadata.=
 =A0You
>> >> could try btrfs-vol -b.
>> >
>> > =A0 I moved some 13 GiB of data off the filesystem, and ran
>> > btrfs-vol -b. As I reported on IRC, I then got this in my syslog:
>> >
>> > Oct 13 13:16:19 vlad kernel: btrfs: relocating block group 1401224=
691712 flags 1
>> > Oct 13 13:17:02 vlad kernel: btrfs: found 123 extents
>> > Oct 13 13:17:10 vlad kernel: btrfs: found 123 extents
>> > Oct 13 13:17:11 vlad kernel: btrfs: found 28 extents
>> > Oct 13 13:17:21 vlad kernel: btrfs: found 28 extents
>> > Oct 13 13:17:25 vlad kernel: btrfs: found 28 extents
>> > Oct 13 13:17:26 vlad kernel: btrfs: found 27 extents
>> > Oct 13 13:17:36 vlad kernel: btrfs: found 27 extents
>> > Oct 13 13:17:39 vlad kernel: btrfs: found 27 extents
>> > Oct 13 13:17:48 vlad kernel: btrfs: found 27 extents
>> > ... repeat forever (or at least for 50 minutes or so).
>> >
>> > =A0 The btrfs-vol -b process didn't respond to ^C, so on advice of
>> > yanzheng on IRC I rebooted the machine. I'm currently running a
>> > btrfsck on the filesystem, and will try btrfs-vol -b again when th=
at's
>> > done.
>> >
>> don't do that, It will run into infinite loop again.
> =A0 I got this from the btrfsck:
> hrm@vlad:~ $ sudo btrfsck /dev/media/scratch
> root 5 inode 3949 errors 2000
> found 1366552736241 bytes used err is 1
> total csum bytes: 1336783032
> total tree bytes: 1944158208
> total fs tree bytes: 20267008
> btree space waste bytes: 462357950
> file data blocks allocated: 1368865824768
> =A0referenced 1368851816448
> Btrfs Btrfs v0.19
> =A0 I guess that means that there were errors found -- is the btrfs-v=
ol
> -b still going to cause an infinite loop, or is it worth trying that
> again?
> =A0 Hugo.

Yes, there is an error. One inode's link count is wrong. It's unlikely
the error is caused by "btrfs-vol -b", but I'm not sure.

Don't run btrfs-vol -b, it will enter infinite loop again.

Yan, Zheng
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
