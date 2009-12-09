From: Zhang Jingwang <yyalone@gmail.com>
Subject: Re: BtrFS does not respond after doing 'fstest' on both original and
	cloned file
Date: Wed, 9 Dec 2009 10:19:54 +0800
Message-ID: <4486336c0912081819x54c6718eha5b725b5059b9fbb@mail.gmail.com>
References: <603eac2a0912081753j39528ca4id374aa835e5f701a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Jian Lin <mail@linjian.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <603eac2a0912081753j39528ca4id374aa835e5f701a@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

More information is appreciated. btrfs-show's output, configuration
info, related dmesg output and so on..

2009/12/9 Jian Lin <mail@linjian.org>:
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
> [root@node34 ~]# cat /sys/devices/system/cpu/cpu3/cache/index1/shared=
_cpu_map
> 00000000,00000000,00000000,00000000,00000000,00000000,00000000,000000=
0a
> [root@node34 ~]# ps aux | grep fstest
> root =A0 =A0 =A07352 =A00.7 =A00.0 =A0 3792 =A0 456 pts/3 =A0 =A0D+ =A0=
 08:24 =A0 3:55
> ./fstest-mod testbase 2147483648
> root =A0 =A0 =A08420 =A00.0 =A00.0 =A061192 =A0 740 pts/6 =A0 =A0S+ =A0=
 16:44 =A0 0:00 grep fstest
>
> When I tried to list files on BtrFS, ls process also hanged:
>
> [root@node34 ~]# ps aux | grep ls
> root =A0 =A0 =A08290 =A00.0 =A00.0 =A073936 =A0 884 pts/1 =A0 =A0D+ =A0=
 16:34 =A0 0:00 ls --color=3Dtty
> root =A0 =A0 =A08327 =A00.0 =A00.0 =A073936 =A0 884 ? =A0 =A0 =A0 =A0=
D =A0 =A016:35 =A0 0:00 ls --color=3Dtty
> root =A0 =A0 =A08384 =A00.0 =A00.0 =A073936 =A0 884 pts/5 =A0 =A0D+ =A0=
 16:42 =A0 0:00 ls
> --color=3Dtty /root/linjian/mnt_btrfs
> root =A0 =A0 =A08422 =A00.0 =A00.0 =A061192 =A0 736 pts/6 =A0 =A0S+ =A0=
 16:44 =A0 0:00 grep ls
>
> [root@node34 ~]# ps aux | grep btrfs
> root =A0 =A0 =A03967 =A00.0 =A00.0 =A0 =A0 =A00 =A0 =A0 0 ? =A0 =A0 =A0=
 =A0S =A0 =A0Dec08 =A0 0:00
> [btrfs-genwork-0]
> root =A0 =A0 =A03968 =A00.0 =A00.0 =A0 =A0 =A00 =A0 =A0 0 ? =A0 =A0 =A0=
 =A0S =A0 =A0Dec08 =A0 0:39
> [btrfs-submit-0]
> root =A0 =A0 =A03969 =A00.0 =A00.0 =A0 =A0 =A00 =A0 =A0 0 ? =A0 =A0 =A0=
 =A0S =A0 =A0Dec08 =A0 0:00
> [btrfs-delalloc-]
> root =A0 =A0 =A03970 =A00.0 =A00.0 =A0 =A0 =A00 =A0 =A0 0 ? =A0 =A0 =A0=
 =A0S =A0 =A0Dec08 =A0 0:00 [btrfs-fixup-0]
> root =A0 =A0 =A03975 =A00.0 =A00.0 =A0 =A0 =A00 =A0 =A0 0 ? =A0 =A0 =A0=
 =A0S =A0 =A0Dec08 =A0 0:00
> [btrfs-enospc-0]
> root =A0 =A0 =A03976 =A00.0 =A00.0 =A0 =A0 =A00 =A0 =A0 0 ? =A0 =A0 =A0=
 =A0S =A0 =A0Dec08 =A0 0:00 [btrfs-cleaner]
> root =A0 =A0 =A03977 =A00.0 =A00.0 =A0 =A0 =A00 =A0 =A0 0 ? =A0 =A0 =A0=
 =A0D =A0 =A0Dec08 =A0 0:04
> [btrfs-transacti]
> root =A0 =A0 =A04301 =A00.2 =A00.0 =A0 =A0 =A00 =A0 =A0 0 ? =A0 =A0 =A0=
 =A0S =A0 =A0Dec08 =A0 3:11
> [btrfs-endio-wri]
> root =A0 =A0 =A04461 =A00.7 =A00.0 =A0 =A0 =A00 =A0 =A0 0 ? =A0 =A0 =A0=
 =A0S =A0 =A0Dec08 =A0 8:55
> [btrfs-worker-1]
> root =A0 =A0 =A04495 =A00.0 =A00.0 =A0 =A0 =A00 =A0 =A0 0 ? =A0 =A0 =A0=
 =A0S =A0 =A0Dec08 =A0 0:20
> [btrfs-endio-met]
> root =A0 =A0 =A04601 =A00.0 =A00.0 =A0 =A0 =A00 =A0 =A0 0 ? =A0 =A0 =A0=
 =A0S =A0 =A0Dec08 =A0 0:34 [btrfs-endio-1]
> root =A0 =A0 =A04623 =A00.0 =A00.0 =A0 =A0 =A00 =A0 =A0 0 ? =A0 =A0 =A0=
 =A0S =A0 =A0Dec08 =A0 0:00
> [btrfs-endio-met]
> root =A0 =A0 =A08384 =A00.0 =A00.0 =A073936 =A0 884 ? =A0 =A0 =A0 =A0=
D =A0 =A016:42 =A0 0:00 ls
> --color=3Dtty /root/linjian/mnt_btrfs
> root =A0 =A0 =A08490 =A00.0 =A00.0 =A0 =A0 =A00 =A0 =A0 0 ? =A0 =A0 =A0=
 =A0S =A0 =A017:10 =A0 0:00 [flush-btrfs-1]
> root =A0 =A0 =A08517 =A00.0 =A00.0 =A061192 =A0 736 pts/6 =A0 =A0S+ =A0=
 17:14 =A0 0:00 grep btrfs
>
> Maybe it's a bug of fstest. I will review it's code.
> However, I don't think a bad user-space program will make file system
> no-responding.
>
> Would you please show me some suggestions on this problem.
> Thanks!
>
> --
> Jian Lin
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Zhang Jingwang
National Research Centre for High Performance Computers
Institute of Computing Technology, Chinese Academy of Sciences
No. 6, South Kexueyuan Road, Haidian District
Beijing, China
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
