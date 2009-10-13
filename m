From: "Yan, Zheng " <yanzheng@21cn.com>
Subject: Re: ENOSPC at 94% full -- and causing BUGs elsewhere?
Date: Tue, 13 Oct 2009 22:58:12 +0800
Message-ID: <3d0408630910130758h7963d85fx5343c531632fa79@mail.gmail.com>
References: <20091003122109.GB3116@selene>
	 <20091003215531.GG4350@dhcp231-156.rdu.redhat.com>
	 <20091004120630.GA19916@think>
	 <20091012140935.GA8550@vlad.carfax.org.uk>
	 <20091013103145.GC8830@think>
	 <20091013145007.GA5393@vlad.carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Hugo Mills <hugo-lkml@carfax.org.uk>,
	Chris Mason <chris.mason@oracle.com>,
	Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20091013145007.GA5393@vlad.carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 13, 2009 at 10:50 PM, Hugo Mills <hugo-lkml@carfax.org.uk> =
wrote:
> On Tue, Oct 13, 2009 at 06:31:45AM -0400, Chris Mason wrote:
>> On Mon, Oct 12, 2009 at 03:09:35PM +0100, Hugo Mills wrote:
>> > On Sun, Oct 04, 2009 at 08:06:30AM -0400, Chris Mason wrote:
>> > > On Sat, Oct 03, 2009 at 05:55:32PM -0400, Josef Bacik wrote:
>> > > > On Sat, Oct 03, 2009 at 01:21:09PM +0100, Hugo Mills wrote:
>> > > > > =A0 =A0I've just had the following on my home server. I beli=
eve that it's
>> > > > > btrfs that's responsible, as the machine wasn't doing much o=
ther than
>> > > > > reading/writing on a btrfs filesystem. The process that was =
doing so
>> > > > > is now stuck in D+ state, and can't be killed. The timing of=
 the oops
>> > > > > at the end is also suggestive of being involved in the same =
incident.
>> > > > > This is the only btrfs filesystem on the machine.
>> > > >
>> > > > Patches have gone to Linus to fix the enospc problems. =A0You =
can try running the
>> > > > enospc branch of Chris's git tree and it should behave better =
for you. =A0Thanks,
>> > >
>> > > The right tree for this is the master branch of btrfs-unstable f=
or
>> > > 2.6.31.
>> >
>> > =A0 =A0Thanks, Josef and Chris. I've now found the time to check o=
ut and
>> > build the btrfs-unstable tree, and it is indeed handling the ENOSP=
C
>> > condition much more cleanly.
>> >
>> > =A0 =A0However, it seems to have got into a position where I have =
lots of
>> > free space reported by df (over 10% of the size of the volume -- 1=
85
>> > GiB free of 1474 GiB total), but still refuses to write anything t=
o
>> > the filesystem. Do you have any suggestions for what I could try?
>>
>> You've probably got most of that 10GB free allocated as metadata. =A0=
You
>> could try btrfs-vol -b.
>
> =A0 I moved some 13 GiB of data off the filesystem, and ran
> btrfs-vol -b. As I reported on IRC, I then got this in my syslog:
>
> Oct 13 13:16:19 vlad kernel: btrfs: relocating block group 1401224691=
712 flags 1
> Oct 13 13:17:02 vlad kernel: btrfs: found 123 extents
> Oct 13 13:17:10 vlad kernel: btrfs: found 123 extents
> Oct 13 13:17:11 vlad kernel: btrfs: found 28 extents
> Oct 13 13:17:21 vlad kernel: btrfs: found 28 extents
> Oct 13 13:17:25 vlad kernel: btrfs: found 28 extents
> Oct 13 13:17:26 vlad kernel: btrfs: found 27 extents
> Oct 13 13:17:36 vlad kernel: btrfs: found 27 extents
> Oct 13 13:17:39 vlad kernel: btrfs: found 27 extents
> Oct 13 13:17:48 vlad kernel: btrfs: found 27 extents
> ... repeat forever (or at least for 50 minutes or so).
>
> =A0 The btrfs-vol -b process didn't respond to ^C, so on advice of
> yanzheng on IRC I rebooted the machine. I'm currently running a
> btrfsck on the filesystem, and will try btrfs-vol -b again when that'=
s
> done.
>
don't do that, It will run into infinite loop again.

Yan, Zheng
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
