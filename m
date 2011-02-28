From: Mitch Harder <mitch.harder@sabayonlinux.org>
Subject: Re: [PATCH] btrfs file write debugging patch
Date: Mon, 28 Feb 2011 11:47:15 -0600
Message-ID: <AANLkTin_Hjr3StjWUGrwCHBzhk_kwj-G2WqxZM6=CqN2@mail.gmail.com>
References: <1298857223-sup-5612@think>
	<201102281114.00018.johannes.hirte@fem.tu-ilmenau.de>
	<20110228161056.GA2769@localhost.localdomain>
	<1298911556.11118.8.camel@mainframe>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=20cf3071cf3037348a049d5b4538
Cc: Josef Bacik <josef@redhat.com>,
	Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>,
	Chris Mason <chris.mason@oracle.com>,
	"Zhong, Xin" <xin.zhong@intel.com>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: =?ISO-8859-1?Q?Maria_Wikstr=F6m?= <maria@ponstudios.se>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1298911556.11118.8.camel@mainframe>
List-ID: <linux-btrfs.vger.kernel.org>

--20cf3071cf3037348a049d5b4538
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

2011/2/28 Maria Wikstr=F6m <maria@ponstudios.se>:
> m=E5n 2011-02-28 klockan 11:10 -0500 skrev Josef Bacik:
>> On Mon, Feb 28, 2011 at 11:13:59AM +0100, Johannes Hirte wrote:
>> > On Monday 28 February 2011 02:46:05 Chris Mason wrote:
>> > > Excerpts from Mitch Harder's message of 2011-02-25 13:43:37 -0500:
>> > > > Some clarification on my previous message...
>> > > >
>> > > > After looking at my ftrace log more closely, I can see where Btrfs=
 is
>> > > > trying to release the allocated pages. =A0However, the calculation=
 for
>> > > > the number of dirty_pages is equal to 1 when "copied =3D=3D 0".
>> > > >
>> > > > So I'm seeing at least two problems:
>> > > > (1) =A0It keeps looping when "copied =3D=3D 0".
>> > > > (2) =A0One dirty page is not being released on every loop even tho=
ugh
>> > > > "copied =3D=3D 0" (at least this problem keeps it from being an in=
finite
>> > > > loop by eventually exhausting reserveable space on the disk).
>> > >
>> > > Hi everyone,
>> > >
>> > > There are actually tow bugs here. =A0First the one that Mitch hit, a=
nd a
>> > > second one that still results in bad file_write results with my
>> > > debugging hunks (the first two hunks below) in place.
>> > >
>> > > My patch fixes Mitch's bug by checking for copied =3D=3D 0 after
>> > > btrfs_copy_from_user and going the correct delalloc accounting. =A0T=
his
>> > > one looks solved, but you'll notice the patch is bigger.
>> > >
>> > > First, I add some random failures to btrfs_copy_from_user() by faili=
ng
>> > > everyone once and a while. =A0This was much more reliable than tryin=
g to
>> > > use memory pressure than making copy_from_user fail.
>> > >
>> > > If copy_from_user fails and we partially update a page, we end up wi=
th a
>> > > page that may go away due to memory pressure. =A0But, btrfs_file_wri=
te
>> > > assumes that only the first and last page may have good data that ne=
eds
>> > > to be read off the disk.
>> > >
>> > > This patch ditches that code and puts it into prepare_pages instead.
>> > > But I'm still having some errors during long stress.sh runs. =A0Idea=
s are
>> > > more than welcome, hopefully some other timezones will kick in ideas
>> > > while I sleep.
>> >
>> > At least it doesn't fix the emerge-problem for me. The behavior is now=
 the same
>> > as with 2.6.38-rc3. It needs a 'emerge --oneshot dev-libs/libgcrypt' w=
ith no
>> > further interaction to get the emerge-process hang with a svn-process
>> > consuming 100% CPU. I can cancel the emerge-process with ctrl-c but th=
e
>> > spawned svn-process stays and it needs a reboot to get rid of it.
>>
>> Can you cat /proc/$pid/wchan a few times so we can get an idea of where =
it's
>> looping? =A0Thanks,
>>
>> Josef
>
> It behaves the same way here with btrfs-unstable.
> The output of "cat /proc/$pid/wchan" is 0.
>
> // Maria
>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" i=
n
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>>
>
>
>

I've applied the patch at the head of this thread (with the jiffies
debugging commented out) and I'm attaching a ftrace using the
function_graph tracer when I'm stuck in the loop.  I've just snipped
out a couple of the loops (the full trace file is quite large, and
mostly repititious).

I'm going to try to modify file.c with some trace_printk debugging to
show the values of several of the relevant variables at various
stages.

I'm going to try to exit the loop after 256 tries with an EFAULT so I
can stop the tracing at that point and capture a trace of the entry
into the problem (the ftrace ring buffer fills up too fast for me to
capture the entry point).

--20cf3071cf3037348a049d5b4538
Content-Type: application/x-gzip;
	name="ftrace-btrfs-file-write-debugging.gz"
Content-Disposition: attachment;
	filename="ftrace-btrfs-file-write-debugging.gz"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gkpojebi0

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
Q/GW275rkqkLUAXUcJHD/w+VvtCPKHkAAA==
--20cf3071cf3037348a049d5b4538--
