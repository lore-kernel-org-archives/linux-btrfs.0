From: Andi Kleen <andi@firstfloor.org>
Subject: Re: BTRFS file clone support for cp
Date: Thu, 30 Jul 2009 11:26:46 +0200
Message-ID: <87ocr2frmx.fsf@basil.nowhere.org>
References: <87d47o3fip.fsf@master.homenet> <4A6CEA48.5050208@draigBrady.com>
	<8763defuvq.fsf@meyering.net> <87ws5tvrq8.fsf@master.homenet>
	<4A6E3ADE.6050008@draigBrady.com> <8763dcvagk.fsf@master.homenet>
	<20090729130106.GF13940@think> <4A705959.7010303@draigBrady.com>
	<20090729161014.GJ13940@think> <4A70918D.6020003@draigBrady.com>
	<20090730005702.GA32157@mail.oracle.com> <87fxcevcuy.fsf@meyering.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: =?iso-8859-1?Q?P=E1draig?= Brady <P@draigBrady.com>,
	linux-btrfs@vger.kernel.org, bug-coreutils@gnu.org,
	Giuseppe Scrivano <gscrivano@gnu.org>,
	Chris Mason <chris.mason@oracle.com>
To: Jim Meyering <jim@meyering.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <87fxcevcuy.fsf@meyering.net> (Jim Meyering's message of "Thu, 30 Jul 2009 09:39:17 +0200")
List-ID: <linux-btrfs.vger.kernel.org>

Jim Meyering <jim@meyering.net> writes:
>
> Thanks.  I haven't looked, but after reading about the reflink syscall
> [http://lwn.net/Articles/332802/] had come to the same conclusion:
> this feature belongs with ln rather than with cp.

cp already has -l so it would make sense to extend that too.

> Besides, putting the new behavior on a new option avoids
> the current semantic change we would otherwise induce in cp.

I don't see how semantics change in a user visible way.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
