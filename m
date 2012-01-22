From: Swapnil Pimpale <swapnil.pict@gmail.com>
Subject: Re: Problem with 3.3.0-rc1+: Target filesystem cannot find /sbin/init
Date: Sun, 22 Jan 2012 18:54:27 +0530
Message-ID: <CAGZys+QghV8xBygpy--kJytt-ZK6Mt_3SO7zNw4n-EN68EB95Q@mail.gmail.com>
References: <CAGZys+Q_A0H36+e45f6jTr7VQB=bn3pq1+pCvt=MHumiQP-=QQ@mail.gmail.com>
	<CAG1y0sfVYTyhvmqe8XmC13zi8qZgOeBsFjqHjc1ox8Y81LvKXg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: kernel-janitors@vger.kernel.org, linux-btrfs@vger.kernel.org
To: "Fajar A. Nugraha" <list@fajar.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAG1y0sfVYTyhvmqe8XmC13zi8qZgOeBsFjqHjc1ox8Y81LvKXg@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

The problem is solved.
Turns out btrfs is disabled by default.

On Sun, Jan 22, 2012 at 5:59 PM, Fajar A. Nugraha <list@fajar.net> wrot=
e:
> On Sun, Jan 22, 2012 at 7:21 PM, Swapnil Pimpale <swapnil.pict@gmail.=
com> wrote:
>> I can successfully boot into Ubuntu 11.10 (3.0.0-14-generic-pae) wit=
h
>> a btrfs root filesystem and an ext2 /boot partition.
>> But when I installed the latest vanilla (3.3.0-rc1+) and booted into
>
> where did you get the kernel from? kernel.org snapshot? git? third
> party package?
>
>> it, the first time the system froze.
>> Next time onwards, I get the following error every time:
>>
>> [ =A0 0.427443] [drm:i915_init] =A0*ERROR* drm/i915 cannot work with=
out
>> intel_agp module!
>> mount: mounting udev on /dev failed: No such device
>> W: devtmpfs not available, falling back to tmpfs for /dev
>> mount: mounting /dev/disk/by-uuid/f43fdd7a-8ad7-4e96-ab1c-14ba82a432=
4d
>> on /root failed: No such device
>
> Do you know how to use your own costom kernel? That error is common
> when a driver is missing (i.e. not built-in, and not included in
> initrd). The easiest way to test that is to look at what's in
> /proc/partitions and /dev/disk/by-id during normal system boot (I
> assume you still have the old, working Ubuntu kernel?) and during
> failed boot when you're dropped to busybox. If your root device
> (sda8?) is not on /proc/partitions, then it's definitely block device
> driver problem.
>
> --
> Fajar

--Swapnil
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
