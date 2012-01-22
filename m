From: "Fajar A. Nugraha" <list@fajar.net>
Subject: Re: Problem with 3.3.0-rc1+: Target filesystem cannot find /sbin/init
Date: Sun, 22 Jan 2012 19:29:42 +0700
Message-ID: <CAG1y0sfVYTyhvmqe8XmC13zi8qZgOeBsFjqHjc1ox8Y81LvKXg@mail.gmail.com>
References: <CAGZys+Q_A0H36+e45f6jTr7VQB=bn3pq1+pCvt=MHumiQP-=QQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: kernel-janitors@vger.kernel.org, linux-btrfs@vger.kernel.org
To: Swapnil Pimpale <swapnil.pict@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAGZys+Q_A0H36+e45f6jTr7VQB=bn3pq1+pCvt=MHumiQP-=QQ@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jan 22, 2012 at 7:21 PM, Swapnil Pimpale <swapnil.pict@gmail.co=
m> wrote:
> I can successfully boot into Ubuntu 11.10 (3.0.0-14-generic-pae) with
> a btrfs root filesystem and an ext2 /boot partition.
> But when I installed the latest vanilla (3.3.0-rc1+) and booted into

where did you get the kernel from? kernel.org snapshot? git? third
party package?

> it, the first time the system froze.
> Next time onwards, I get the following error every time:
>
> [ =A0 0.427443] [drm:i915_init] =A0*ERROR* drm/i915 cannot work witho=
ut
> intel_agp module!
> mount: mounting udev on /dev failed: No such device
> W: devtmpfs not available, falling back to tmpfs for /dev
> mount: mounting /dev/disk/by-uuid/f43fdd7a-8ad7-4e96-ab1c-14ba82a4324=
d
> on /root failed: No such device

Do you know how to use your own costom kernel? That error is common
when a driver is missing (i.e. not built-in, and not included in
initrd). The easiest way to test that is to look at what's in
/proc/partitions and /dev/disk/by-id during normal system boot (I
assume you still have the old, working Ubuntu kernel?) and during
failed boot when you're dropped to busybox. If your root device
(sda8?) is not on /proc/partitions, then it's definitely block device
driver problem.

--=20
=46ajar
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
