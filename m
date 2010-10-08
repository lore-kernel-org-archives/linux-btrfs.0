From: Chris Mason <chris.mason@oracle.com>
Subject: Re: system crash at mounting of btrfs
Date: Fri, 8 Oct 2010 12:53:47 -0400
Message-ID: <20101008165347.GR4804@think>
References: <4CAEBD78.7000002@wpkg.org>
 <loom.20101008T182314-909@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Gerhard Kulzer <gerhard@kulzer.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <loom.20101008T182314-909@post.gmane.org>
List-ID: <linux-btrfs.vger.kernel.org>

So this is a completely different race from the first one.  Do you get
the same crashes every time you try to boot or are they different every
time?

We can definitely help get the data off.

-chris

On Fri, Oct 08, 2010 at 04:49:11PM +0000, Gerhard Kulzer wrote:
> Tomasz Chmielewski <mangoo <at> wpkg.org> writes:
> 
> > 
> > You could try:
> > 
> > http://kernel.ubuntu.com/~kernel-ppa/mainline/v2.6.36-rc7-maverick/
> > 
> 
> Alright I tried 2.6.36-rc7 to no avail, same crashing behaviour.
> 
> This is a kernel trace (from Intel-Atom netbook => 32bit) at which 
> the machine freezes after trying to mount the btrfs SSD drive:
> 
> ----trace---
> Pid: 1882, comm: mount Tainted: G D 2.6.36-020636rc7-generic
> EIP: 0060:[>f81039ef>] EFLAGS: 00010283 CPU:0
> EIP is at btrfs_test_super+0xf/0x30 [btrfs]
> EAX: 000000000 EBX: e2e6ca00 ECX: c0221090 EDX: f1689b80
> ESI: f81039e0 EDI: f816d318 EBP: d3001e78 ESP: d300115c
>  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 068
> Process mount (pid: 1882, ti=d3000000 task=ef54cc20 task.ti=d300000000)
> Stack:
>  c02221af c0221090 f816d300 00000000 fffffff3 00000000 f6eb7a00 d3001ee8
> <0> f8103e28 f1689b80 d3001ea8 d3001eb4 e62670c0 00000000 eee22b00 00000000
> <0> f816d300 00000000 000000d0 00000000 00000000 e0a18e00 f1689b80 00000004
> Call Trace:
>  [<c02221af>] ? sget+0x3f/0x1f0
>  [<c0221090>] ? set_anon_super+0x0/0xe0
>  [<f8103e28>] ? btrfs_get_sb+0x108/0x2c0 [btrfs]
>  [<c021671f>] ? __alloc_percpu+0xf/0x20
>  [<c0221f4e>] ? vfs_kern_mount+0x6e/0x1b0
>  [<c0235bb5>] ? get_fs_type+0x35/0xa0
>  [<c02220ee>] ? do_kern_mount+0x3e/0x80
>  [<c0238869>] ? do_new_mount+0x69/0xa0
>  [<c0238b48>] ? do_mount+0x188/0x1a0
>  [<c0238bcd>] ? sys_mount+0x6d/0xa0
>  [<c0102cdf>] ? sysenter_do_call+0x12/0x28
> Code: eb dc ba c0 02 00 00 b8 34 6d 16 f8 e8 1b ab 04 c8 eb d6 89 f6 
> 8d bc 27 00 00 00 00 55 89 e5 0f 1f 44 00 00 8b 80 7c 01 00 00 5d 
> <8b> 80 14 01 00 00 39 90 ec 1d 00 00 0f 94 c0 0f b6 c0 c3 8d b4
> EIP: [<f71039ef>] btrfs_test_super+0xf/0x30 [btrfs] SS:ESP 0068:d3001e5c
> CR2: 0000000000000114
> ---[ end trace ]---
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
