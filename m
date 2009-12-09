From: "Yan, Zheng " <yanzheng@21cn.com>
Subject: Re: BtrFS does not respond after doing 'fstest' on both original and
	cloned file
Date: Wed, 9 Dec 2009 10:19:43 +0800
Message-ID: <3d0408630912081819r52dfb101uaa4644eada0671ae@mail.gmail.com>
References: <603eac2a0912081753j39528ca4id374aa835e5f701a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Jian Lin <mail@linjian.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <603eac2a0912081753j39528ca4id374aa835e5f701a@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 9, 2009 at 9:53 AM, Jian Lin <mail@linjian.org> wrote:
> Hi,
>
> I am using Linux 2.6.32 on X86_64 with BtrFS compiled in the kernel.
> For my experimental application, I want to evaluate reliability of CO=
W
> feature of BtrFS.
> I chose a small tool called fstest (http://code.google.com/p/fstest/)
> and modified it:
>
> [root@node34 fstest-0.1.3]# diff fstest.c fstest-mod.c
> 315c315
> < =A0 =A0 unlink(p->filename);
> ---
>> =A0 =A0 //unlink(p->filename);
> 317c317
> < =A0 =A0 *file=3Dopen(p->filename, O_RDWR|O_CREAT|O_EXCL, 0777);
> ---
>> =A0 =A0 *file=3Dopen(p->filename, O_RDWR|O_CREAT/*|O_EXCL*/, 0777);
> 360c360
> < =A0 =A0 unlink(p.filename);
> ---
>> =A0 =A0 //unlink(p.filename);
>
> So, fstest-mod will ramdomly write and read blocks in a specific file=
,
> and check whether it is consistent.
> Then I made a zero-filled file and a clone of it, ran fstest-mod
> respectively on the original and the cloned file:
>
> dd if=3D/dev/zero of=3Dtestbase bs=3D100 count=3D$((1024*1024))
> cp --reflink testbase testbase-ref
> [One Terminal] ./fstest-mod testbase $((100*1024*1024))
> [Another Terminal] ./fstest-mod testbase-ref $((100*1024*1024))
>
> When the test files were small (~100M), both fstest-mod programs retu=
rned OK.
> However, when I used bigger test files (2G), BtrFS did not respond
> after a period of time.
> It said:
>
> Message from syslogd@ at Wed Dec =A09 08:38:42 2009 ...
> node34 kernel: ------------[ cut here ]------------
> Message from syslogd@ at Wed Dec =A09 08:38:42 2009 ...
> node34 kernel: invalid opcode: 0000 [#1] SMP
> Message from syslogd@ at Wed Dec =A09 08:38:42 2009 ...
> node34 kernel: last sysfs file:
> /sys/devices/system/cpu/cpu3/cache/index1/shared_cpu_map
> Message from syslogd@ at Wed Dec =A09 08:38:42 2009 ...
> node34 kernel: Stack:
> Message from syslogd@ at Wed Dec =A09 08:38:42 2009 ...
> node34 kernel: Call Trace:
> Message from syslogd@ at Wed Dec =A09 08:38:42 2009 ...
> node34 kernel: Code: 24 10 4c 89 f6 e8 5a 16 fc ff 48 8b 7c 24 20 eb
> 29 48 8d 6b f0 48 8b 74 24 10 48 8b 7c 24 18 48 89 ea e8 00 4b fd ff
> 85 c0 74 04 <0f> 0b eb fe 48 89 df e8 c2 a9 05 00 48 89 ef e8 d2 93 f=
5
> ff 48
>

Please send full messages of this oops, you can find them in /var/log/m=
essages.

Regards
Yan Zheng
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
