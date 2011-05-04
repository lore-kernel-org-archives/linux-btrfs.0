From: cwillu <cwillu@cwillu.com>
Subject: Re: btrfs csum failed
Date: Wed, 4 May 2011 05:51:03 -0600
Message-ID: <BANLkTiniD_mztDPriodDWybTzt7Dqtherg@mail.gmail.com>
References: <4DC07A10.7070200@mur.at>
	<20110504002815.GA27861@dhcp231-156.rdu.redhat.com>
	<4DC0A153.3080806@mur.at>
	<BANLkTin1quUuSq4oKdt1SowTPv4dhGEM5g@mail.gmail.com>
	<4DC13B02.9030604@mur.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "Fajar A. Nugraha" <list@fajar.net>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Martin Schitter <ms@mur.at>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4DC13B02.9030604@mur.at>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 4, 2011 at 5:39 AM, Martin Schitter <ms@mur.at> wrote:
> Am 2011-05-04 04:18, schrieb Fajar A. Nugraha:
>>>
>>> could you give me some advice how to debug/report this specific
>>> problem more
>>>>
>>>> precise?
>>
>> If it's not reproducible then I'd suspect it'd be hard to do.
>
> the last working snapshot is from 2011-05-02-17:13. i can reproduce this
> file system corruption on one specific file in any hourly snapshot later.

That's not surprising, any later snapshots will be sharing the same
corrupted block.

> that looks very unplausible to me. there is an RAID1 layer beneath btrfs in
> our setup and i don't see any errors there.

That doesn't rule out the possibility of corruption when it was
written in the first place, or some similar problem that the raid1
faithfully reproduced on both mirrors.  That's not to say that it's
impossible that the problem is in btrfs, just that it's not the only
plausible possibility.

> and the 'nodatasum' option should also ignore csum issues.-- isn't it?

No, it only affects writing new checksums; any existing checksums are
still checked.
