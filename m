From: Jim Meyering <jim@meyering.net>
Subject: Re: BTRFS file clone support for cp
Date: Thu, 30 Jul 2009 12:16:48 +0200
Message-ID: <87iqhatqzz.fsf@meyering.net>
References: <87d47o3fip.fsf@master.homenet> <4A6CEA48.5050208@draigBrady.com>
	<8763defuvq.fsf@meyering.net> <87ws5tvrq8.fsf@master.homenet>
	<4A6E3ADE.6050008@draigBrady.com> <8763dcvagk.fsf@master.homenet>
	<20090729130106.GF13940@think> <4A705959.7010303@draigBrady.com>
	<20090729161014.GJ13940@think> <4A70918D.6020003@draigBrady.com>
	<20090730005702.GA32157@mail.oracle.com> <87fxcevcuy.fsf@meyering.net>
	<87ocr2frmx.fsf@basil.nowhere.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: =?utf-8?Q?P=C3=A1draig?= Brady <P@draigBrady.com>,
	linux-btrfs@vger.kernel.org, bug-coreutils@gnu.org,
	Giuseppe Scrivano <gscrivano@gnu.org>,
	Chris Mason <chris.mason@oracle.com>
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <87ocr2frmx.fsf@basil.nowhere.org> (Andi Kleen's message of "Thu,
	30 Jul 2009 11:26:46 +0200")
List-ID: <linux-btrfs.vger.kernel.org>

Andi Kleen wrote:

> Jim Meyering <jim@meyering.net> writes:
>>
>> Thanks.  I haven't looked, but after reading about the reflink syscall
>> [http://lwn.net/Articles/332802/] had come to the same conclusion:
>> this feature belongs with ln rather than with cp.
>
> cp already has -l so it would make sense to extend that too.

Good point.

>> Besides, putting the new behavior on a new option avoids
>> the current semantic change we would otherwise induce in cp.
>
> I don't see how semantics change in a user visible way.

With classic cp, if I copy a 1GB non-sparse file and there's less
space than that available, cp fails with ENOSPC.
With this new feature, it succeeds even if there are
just a few blocks available.

Also, consider (buggy!) code that then depends on being able to modify
that file in-place, and that "knows" it doesn't need to check for ENOSPC.
Sure, they should always check for write failure, but still.  It is
a change.
