From: Mitch Harder <mitch.harder@sabayonlinux.org>
Subject: Re: btrfs bug
Date: Tue, 31 Jan 2012 15:37:18 -0600
Message-ID: <CAKcLGm-z3pJZgr30WYs8D8_VnVFMcjErKtvG5_ys-FOo=dRPEw@mail.gmail.com>
References: <4F282D3B.8050609@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Thomas Weber <thomas.weber.linux@googlemail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F282D3B.8050609@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 31, 2012 at 12:04 PM, Thomas Weber
<thomas.weber.linux@googlemail.com> wrote:
> Hello,
>
> this morning my laptop with btrfs crashed. It is an ssd drive.
>
> It is a Linux aramis 3.2.2-1-ARCH #1 SMP PREEMPT Thu Jan 26 08:40:20 CET
> 2012 x86_64 Intel(R) Core(TM)2 Duo CPU T7250 @ 2.00GHz GenuineIntel
> GNU/Linux
>
> Regards,
> Thomas
>
>
> This two lines are from a photo, that i made.
>> kernel BUG at fs/btrfs/extent_io.c:4357!
>> invalid opcode: 0000 [#1] PREEMPT SMP
>
> The rest is from dmesg.
>

In your dmesg output, immediately prior to what you posted, there
should have been a message like: "btrfs memmove bogus src_offset %lu
move len %lu len %lu".

If you still have this output, could you post that line with its values?
