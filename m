From: Jim Meyering <jim@meyering.net>
Subject: Re: BTRFS file clone support for cp
Date: Thu, 30 Jul 2009 09:39:17 +0200
Message-ID: <87fxcevcuy.fsf@meyering.net>
References: <87d47o3fip.fsf@master.homenet> <4A6CEA48.5050208@draigBrady.com>
	<8763defuvq.fsf@meyering.net> <87ws5tvrq8.fsf@master.homenet>
	<4A6E3ADE.6050008@draigBrady.com> <8763dcvagk.fsf@master.homenet>
	<20090729130106.GF13940@think> <4A705959.7010303@draigBrady.com>
	<20090729161014.GJ13940@think> <4A70918D.6020003@draigBrady.com>
	<20090730005702.GA32157@mail.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: linux-btrfs@vger.kernel.org, bug-coreutils@gnu.org,
	Giuseppe Scrivano <gscrivano@gnu.org>, Chris Mason <chris.mason@oracle.com>
To: =?utf-8?Q?P=C3=A1draig?= Brady <P@draigBrady.com>
Return-path: <bug-coreutils-bounces+gcgcb-bug-coreutils-616=gmane.org@gnu.org>
In-Reply-To: <20090730005702.GA32157@mail.oracle.com> (Joel Becker's message
	of "Wed, 29 Jul 2009 17:57:03 -0700")
List-Unsubscribe: <http://lists.gnu.org/mailman/listinfo/bug-coreutils>,
	<mailto:bug-coreutils-request@gnu.org?subject=unsubscribe>
List-Archive: <http://lists.gnu.org/pipermail/bug-coreutils>
List-Post: <mailto:bug-coreutils@gnu.org>
List-Help: <mailto:bug-coreutils-request@gnu.org?subject=help>
List-Subscribe: <http://lists.gnu.org/mailman/listinfo/bug-coreutils>,
	<mailto:bug-coreutils-request@gnu.org?subject=subscribe>
Errors-To: bug-coreutils-bounces+gcgcb-bug-coreutils-616=gmane.org@gnu.org
List-ID: <linux-btrfs.vger.kernel.org>

Joel Becker wrote:

> On Wed, Jul 29, 2009 at 07:14:37PM +0100, P=C3=A1draig Brady wrote:
>> Chris Mason wrote:
>> > On Wed, Jul 29, 2009 at 03:14:49PM +0100, P=C3=A1draig Brady wrote:
>> >>
>> >> We may need to play around with fallocate()
>> >> if we want to get back to the original
>> >> cp semantics of actually allocating space
>> >> on the file system for the new file.
>> >
>> > Well, best to just use the original cp code.  I was talking with
>> > Giuseppe about this as well, I think we should the option to do regular
>> > cp via a flag.
>>
>> Right. Well we can turn off this cloning by doing --sparse=3D{never,alwa=
ys}
>> but that has side effects. If we need an option then maybe we should have
>> it turn on cloning rather than restore default cp behaviour?
>> The side effects I thought of earlier, of COW without corresponding allo=
cation
>> were possible fragmentation on write or unexpected/mishandled ENOSPC.
>> Also for endangered mechanical disks, subsequent processing could
>> be slowed as the head seeks between the old and new data to be copied.
>> Perhaps these are a small price to pay, especially considering that
>> solid state disks will only be affected by the write()=3DENOSPC issue.
>>
>> At the moment we have these linking options:
>>
>> cp -l, --link #for hardlinks
>> cp -s, --symbolic-link #for symlinks
>>
>> So perhaps we should support:
>>
>> cp --link=3D{soft,hard,cow}
>> for symlink(), link() and reflink() respectively?
>> I.E. link to the name, inode or extents respectively.
>
> 	I've cooked up 'ln -r' for reflinks, which works for ln(1) but
> not for cp(1).

Thanks.  I haven't looked, but after reading about the reflink syscall
[http://lwn.net/Articles/332802/] had come to the same conclusion:
this feature belongs with ln rather than with cp.

Besides, putting the new behavior on a new option avoids
the current semantic change we would otherwise induce in cp.
