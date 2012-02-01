From: Mitch Harder <mitch.harder@sabayonlinux.org>
Subject: Re: btrfs bug
Date: Wed, 1 Feb 2012 12:07:27 -0600
Message-ID: <CAKcLGm_qgV_o61t3n9Wo7GsO7=BJcy6TBBzcJK=SzxctFYGEog@mail.gmail.com>
References: <4F282D3B.8050609@gmail.com>
	<CAKcLGm-z3pJZgr30WYs8D8_VnVFMcjErKtvG5_ys-FOo=dRPEw@mail.gmail.com>
	<4F286263.7010502@gmail.com>
	<4F28CB94.1040803@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Thomas Weber <thomas.weber.linux@googlemail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F28CB94.1040803@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 31, 2012 at 11:20 PM, Thomas Weber
<thomas.weber.linux@googlemail.com> wrote:
> Hello Mitch,
>
> I have good news for you. I looked through all log files and found in the
> everything.log the following:
>
> Regards,
> Thomas
>
>
> Jan 31 05:12:24 localhost kernel: [87276.968049] btrfs memmove bogus
> src_offset 1870 move len 687876531 len 4096
> Jan 31 05:12:24 localhost kernel: [87276.968136] ------------[ cut here
> ]------------
> Jan 31 05:12:24 localhost kernel: [87276.968222] kernel BUG at
> fs/btrfs/extent_io.c:4357!
> Jan 31 05:12:24 localhost kernel: [87276.968296] invalid opcode: 0000 [#1]
> PREEMPT SMP

[...snip...]

This is coming from a BUG_ON(1) in the memcpy_extent_buffer() function
in extent_io.c

	if (src_offset + len > dst->len) {
		printk(KERN_ERR "btrfs memmove bogus src_offset %lu move "
		       "len %lu dst len %lu\n", src_offset, len, dst->len);
		BUG_ON(1);
	}

So, since (1870 + 687876531) > 4096, the BUG_ON was triggered.

There are two calls to memcpy_extent_buffer() from
setup_items_for_insert (the next function back in the callback shown
from the BUG_ON), so that part makes sense, at least.

I don't know if anybody else has anything to say on this, but my best
guess is that this btrfs volume has picked up some corruptions that
are feeding in some bad values.
