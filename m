From: Chris Mason <chris.mason@oracle.com>
Subject: Re: 2.6.37: Multi-second I/O latency while untarring
Date: Mon, 14 Feb 2011 10:22:55 -0500
Message-ID: <1297696565-sup-8163@think>
References: <AANLkTin4628kHMRogoAarDWyGGb8-6-BiixihJmy_AUj@mail.gmail.com> <1297438671-sup-21@think> <AANLkTimLeCMFO++RYnCXOPSMeNzxf2SAovEZ-q-q5TzF@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>
To: Andrew Lutomirski <andy@luto.us>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <AANLkTimLeCMFO++RYnCXOPSMeNzxf2SAovEZ-q-q5TzF@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Andrew Lutomirski's message of 2011-02-11 19:35:02 -0500:
> On Fri, Feb 11, 2011 at 10:44 AM, Chris Mason <chris.mason@oracle.com=
> wrote:
> > Excerpts from Andrew Lutomirski's message of 2011-02-11 10:08:52 -0=
500:
> >> As I type this, I have an ssh process running that's dumping data =
into
> >> a fifo at high speed (maybe 500Mbps) and a tar process that's
> >> untarring from the same fifo onto btrfs. =C2=A0The btrfs fs is mou=
nted -o
> >> space_cache,compress. =C2=A0This machine has 8GB ram, 8 logical co=
res, and
> >> a fast (i7-2600) CPU, so it's not an issue with the machine strugg=
ling
> >> under load.
> >>
> >> Every few tens of seconds, my system stalls for several seconds.
> >> These stalls cause keyboard input to be lost, firefox to hang, etc=
=2E
> >>
> >> Setting tar's ionice priority to best effort / 7 or to idle makes =
no difference.
> >>
> >> ionice idle and queue_depth =3D 1 on the disk (a slow 2TB WD) also=
 makes
> >> no difference.
> >>
> >> max_sectors_kb =3D 64 in addition to the above doesn't help either=
=2E
> >>
> >> latencytop shows regular instances of 2-7 *second* latency, variou=
sly
> >> in sync_page, start_transaction, btrfs_start_ordered_extent, and
> >> do_get_write_access (from jbd2 on my ext4 root partition).
> >>
> >> echo 3 >drop_caches gave me 7 GB free RAM. =C2=A0I still had stall=
s when
> >> 4-5 GB were still free (so it shouldn't be a problem with importan=
t
> >> pages being evicted).
> >>
> >> In case it matters, all of my partitions are on LVM on dm-crypt, b=
ut
> >> this machine has AES-NI so the overhead from that should be minima=
l.
> >> In fact, overall CPU usage is only about 10%.
> >>
> >> What gives? =C2=A0I thought this stuff was supposed to be better o=
n modern kernels.
> >
> > We can tell more if you post the full traces from latencytop. =C2=A0=
I have a
> > patch here for latencytop that adds a -c mode, which dumps the trac=
es
> > out to a text files.
> >
> > http://oss.oracle.com/~mason/latencytop.patch
> >
> > Based on what you have here, I think it's probably a latency proble=
m
> > between btrfs and the dm-crypt stuff. =C2=A0How easily can setup a =
test
> > partition without dm-crypt?
>=20
> Done, on the same physical disk as before.  The latency is just as
> bad.  On this test, I wrote a total of 3.1G, which is under half of m=
y
> RAM.  That should rule out lots of VM issues.  latencytop trace below=
=2E

Just to confirm, you say on a physical disk you mean without dm-crypt?

>=20
> The impression I get (from watching the disk activity light) is that
> the disk is mostly idle but every now and then writes out a ton of
> data.  While it's writing, the system often becomes unusable.

Could you please btrfs fi df /mnt (where /mnt is your test filesystem)

>=20
> P.S.  How bad is this?  I got it on both disks.
> btrfs: free space inode generation (0) did not match free space cache
> generation (11070) for block group 1103101952

We got rid of these in later kernels, they are fine.

The latencytop data shows us basically waiting for the disk.  We're
either waiting for synchronous reads or writes, and we're heavily
waiting for supers to be sent down to the disk as part of committing
transactions.

There are a few things I'd like you to try:

1) Try deadline instead of cfq, unless you're using deadline in which
case you could try cfq.

2) Try increasing the number of io requests we allow in flight:

echo 2048 > /sys/block/xxx/queue/nr_requests

Here xxx is your physical disk (like sda)

3) Try without firefox running.  Firefox is generating a lot of
synchronous IO here.  The btrfs log tries really hard to manage this
without making the box stall, but somehow we might not be doing well.

One place we don't do well is if your disk was freshly formatted and
you're still growing chunks to cover new writes.  In this case the
fsyncs done by firefox will lead to more expensive transaction commits.

-chris
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
