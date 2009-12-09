From: Jian Lin <mail@linjian.org>
Subject: BtrFS does not respond after doing 'fstest' on both original and
	cloned file
Date: Wed, 9 Dec 2009 09:53:54 +0800
Message-ID: <603eac2a0912081753j39528ca4id374aa835e5f701a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I am using Linux 2.6.32 on X86_64 with BtrFS compiled in the kernel.
For my experimental application, I want to evaluate reliability of COW
feature of BtrFS.
I chose a small tool called fstest (http://code.google.com/p/fstest/)
and modified it:

[root@node34 fstest-0.1.3]# diff fstest.c fstest-mod.c
315c315
<     unlink(p->filename);
---
>     //unlink(p->filename);
317c317
<     *file=open(p->filename, O_RDWR|O_CREAT|O_EXCL, 0777);
---
>     *file=open(p->filename, O_RDWR|O_CREAT/*|O_EXCL*/, 0777);
360c360
<     unlink(p.filename);
---
>     //unlink(p.filename);

So, fstest-mod will ramdomly write and read blocks in a specific file,
and check whether it is consistent.
Then I made a zero-filled file and a clone of it, ran fstest-mod
respectively on the original and the cloned file:

dd if=/dev/zero of=testbase bs=100 count=$((1024*1024))
cp --reflink testbase testbase-ref
[One Terminal] ./fstest-mod testbase $((100*1024*1024))
[Another Terminal] ./fstest-mod testbase-ref $((100*1024*1024))

When the test files were small (~100M), both fstest-mod programs returned OK.
However, when I used bigger test files (2G), BtrFS did not respond
after a period of time.
It said:

Message from syslogd@ at Wed Dec  9 08:38:42 2009 ...
node34 kernel: ------------[ cut here ]------------
Message from syslogd@ at Wed Dec  9 08:38:42 2009 ...
node34 kernel: invalid opcode: 0000 [#1] SMP
Message from syslogd@ at Wed Dec  9 08:38:42 2009 ...
node34 kernel: last sysfs file:
/sys/devices/system/cpu/cpu3/cache/index1/shared_cpu_map
Message from syslogd@ at Wed Dec  9 08:38:42 2009 ...
node34 kernel: Stack:
Message from syslogd@ at Wed Dec  9 08:38:42 2009 ...
node34 kernel: Call Trace:
Message from syslogd@ at Wed Dec  9 08:38:42 2009 ...
node34 kernel: Code: 24 10 4c 89 f6 e8 5a 16 fc ff 48 8b 7c 24 20 eb
29 48 8d 6b f0 48 8b 74 24 10 48 8b 7c 24 18 48 89 ea e8 00 4b fd ff
85 c0 74 04 <0f> 0b eb fe 48 89 df e8 c2 a9 05 00 48 89 ef e8 d2 93 f5
ff 48

[root@node34 ~]# cat /sys/devices/system/cpu/cpu3/cache/index1/shared_cpu_map
00000000,00000000,00000000,00000000,00000000,00000000,00000000,0000000a
[root@node34 ~]# ps aux | grep fstest
root      7352  0.7  0.0   3792   456 pts/3    D+   08:24   3:55
./fstest-mod testbase 2147483648
root      8420  0.0  0.0  61192   740 pts/6    S+   16:44   0:00 grep fstest

When I tried to list files on BtrFS, ls process also hanged:

[root@node34 ~]# ps aux | grep ls
root      8290  0.0  0.0  73936   884 pts/1    D+   16:34   0:00 ls --color=tty
root      8327  0.0  0.0  73936   884 ?        D    16:35   0:00 ls --color=tty
root      8384  0.0  0.0  73936   884 pts/5    D+   16:42   0:00 ls
--color=tty /root/linjian/mnt_btrfs
root      8422  0.0  0.0  61192   736 pts/6    S+   16:44   0:00 grep ls

[root@node34 ~]# ps aux | grep btrfs
root      3967  0.0  0.0      0     0 ?        S    Dec08   0:00
[btrfs-genwork-0]
root      3968  0.0  0.0      0     0 ?        S    Dec08   0:39
[btrfs-submit-0]
root      3969  0.0  0.0      0     0 ?        S    Dec08   0:00
[btrfs-delalloc-]
root      3970  0.0  0.0      0     0 ?        S    Dec08   0:00 [btrfs-fixup-0]
root      3975  0.0  0.0      0     0 ?        S    Dec08   0:00
[btrfs-enospc-0]
root      3976  0.0  0.0      0     0 ?        S    Dec08   0:00 [btrfs-cleaner]
root      3977  0.0  0.0      0     0 ?        D    Dec08   0:04
[btrfs-transacti]
root      4301  0.2  0.0      0     0 ?        S    Dec08   3:11
[btrfs-endio-wri]
root      4461  0.7  0.0      0     0 ?        S    Dec08   8:55
[btrfs-worker-1]
root      4495  0.0  0.0      0     0 ?        S    Dec08   0:20
[btrfs-endio-met]
root      4601  0.0  0.0      0     0 ?        S    Dec08   0:34 [btrfs-endio-1]
root      4623  0.0  0.0      0     0 ?        S    Dec08   0:00
[btrfs-endio-met]
root      8384  0.0  0.0  73936   884 ?        D    16:42   0:00 ls
--color=tty /root/linjian/mnt_btrfs
root      8490  0.0  0.0      0     0 ?        S    17:10   0:00 [flush-btrfs-1]
root      8517  0.0  0.0  61192   736 pts/6    S+   17:14   0:00 grep btrfs

Maybe it's a bug of fstest. I will review it's code.
However, I don't think a bad user-space program will make file system
no-responding.

Would you please show me some suggestions on this problem.
Thanks!

-- 
Jian Lin
