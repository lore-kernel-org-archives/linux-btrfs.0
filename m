From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: Re: BTRFS file clone support for cp
Date: Thu, 30 Jul 2009 12:21:28 +0200
Message-ID: <4A717428.9040906@wpkg.org>
References: <87d47o3fip.fsf@master.homenet> <4A6CEA48.5050208@draigBrady.com>	<8763defuvq.fsf@meyering.net> <87ws5tvrq8.fsf@master.homenet>	<4A6E3ADE.6050008@draigBrady.com> <8763dcvagk.fsf@master.homenet>	<20090729130106.GF13940@think> <4A705959.7010303@draigBrady.com>	<20090729161014.GJ13940@think> <4A70918D.6020003@draigBrady.com>	<20090730005702.GA32157@mail.oracle.com> <87fxcevcuy.fsf@meyering.net>	<87ocr2frmx.fsf@basil.nowhere.org> <87iqhatqzz.fsf@meyering.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: Andi Kleen <andi@firstfloor.org>,
	=?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigBrady.com>,
	linux-btrfs@vger.kernel.org, bug-coreutils@gnu.org,
	Giuseppe Scrivano <gscrivano@gnu.org>,
	Chris Mason <chris.mason@oracle.com>
To: Jim Meyering <jim@meyering.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <87iqhatqzz.fsf@meyering.net>
List-ID: <linux-btrfs.vger.kernel.org>

Jim Meyering wrote:

> With classic cp, if I copy a 1GB non-sparse file and there's less
> space than that available, cp fails with ENOSPC.
> With this new feature, it succeeds even if there are
> just a few blocks available.

Is it good or bad?


> Also, consider (buggy!) code that then depends on being able to modify
> that file in-place, and that "knows" it doesn't need to check for ENOSPC.
> Sure, they should always check for write failure, but still.  It is
> a change.

On a multiuser system, that (buggy) tool would fail anyway if something 
else adds enough new data to the filesystem in the meantime.

But sure, it's a change.


-- 
Tomasz Chmielewski
http://wpkg.org
