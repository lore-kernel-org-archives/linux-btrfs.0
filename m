From: Andi Kleen <andi@firstfloor.org>
Subject: Re: btrfs and swap files on SSD's ?
Date: Wed, 21 Jan 2009 07:15:20 +0100
Message-ID: <873afddw1z.fsf@basil.nowhere.org>
References: <200901171110.22803.chris@csamuel.org>
	<1232382162.6521.108.camel@think.oraclecorp.com>
	<4975AA6C.8@schleiser.de>
	<1232456536.15042.0.camel@think.oraclecorp.com>
	<3a7f57190901200551s7e9ee262mc3720b5b1452b8dc@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Mason <chris.mason@oracle.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Dmitri Nikulin <dnikulin@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <3a7f57190901200551s7e9ee262mc3720b5b1452b8dc@mail.gmail.com> (Dmitri Nikulin's message of "Wed, 21 Jan 2009 00:51:22 +1100")
List-ID: <linux-btrfs.vger.kernel.org>

Dmitri Nikulin <dnikulin@gmail.com> writes:

> On Wed, Jan 21, 2009 at 12:02 AM, Chris Mason <chris.mason@oracle.com> wrote:
>> There are patches to support swap over NFS that might make it safe to
>> use on btrfs. At any rate, it is a fixable problem.
>
> FreeBSD has been able to run swap over NFS for as long as I can
> remember, what is different in Linux that makes it especially
> difficult?

One big traditional difference is that FreeBSD uses fixed isolated
pools for their networking buffers (that is why you had to tune most
systems for higher network workloads), while Linux has fully
unified[1] memory management including the network stack.
Now I believe recent BSD also moved to more unified network
management and it wouldn't surprise me if they had trouble
with this now too.

[1] at least for now, there are unfortunately some tendencies to move
back to fixed pools too.

> I've read that swap over non-trivial filesystems is hazardous as it
> may lead to a situation in which memory allocation can fail in the
> swap/FS code that was meant to make allocation possible again.

A lot of this has been fixed in the 2.6 timeframe (e.g. there's
now a better enforced global dirty limit), but there are likely still
corner cases that could run into difficulties, so noone is 
really declaring it 100% safe yet.

> If btrfs is to take the role of a RAID and volume manager, it would
> certainly be very useful to be able to run swap on it, since that
> frees up other volumes from an administrative standpoint.

The fixed extent mapping of the swap files is really a different problem,
independent of the memory allocation issue.

In general the memory allocation problem on write out has to be solved
in any ways (even if you don't support swap files), because any dirty 
mmap'ed file effectively acts like a swap file.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
