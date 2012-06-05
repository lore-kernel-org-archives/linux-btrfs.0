Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.21]:50862 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755053Ab2FERT2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Jun 2012 13:19:28 -0400
Received: by yhpp61 with SMTP id p61so3775518yhp.25
        for <linux-btrfs@vger.kernel.org>; Tue, 05 Jun 2012 10:19:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAN_LGv0RcA5y6Dyq25_poWxhwxoS7X6CGi71czrJji0E6NHzzg@mail.gmail.com>
References: <CAKyAS7vw6pPz56Y9DeyUQLVeuXq4G2WogEWm+5gANesC0ME35g@mail.gmail.com>
	<CABsxX9+uRN0rCY-Qo5gpRirvv6orWKdsVEKD=duuCGUj+xndXg@mail.gmail.com>
	<CAKyAS7uKKz_MsPeiLa7QorkjPqm16K0RmCy3eDcuTTxOkvBYuw@mail.gmail.com>
	<CABsxX9LQkytRk6xZfEkw7QM24ghiM75WY0wVwiAouh+WWPBT=Q@mail.gmail.com>
	<CAKyAS7stmJrYMHWf_eWX1htLOZRu3M7gmGMJ9ZMSzne+81yBpA@mail.gmail.com>
	<CAKyAS7sdL9qWLOCyj7y5HeJda=WhsWsQu_Pke22AOspT-ES1Tg@mail.gmail.com>
	<CABsxX9+Msqdjp_y1xWRQe=QJ9ALPBqx7H62ZosfN9QZc0f1hRg@mail.gmail.com>
	<CAKyAS7sy-923hm-uo1_SiP3XC4tbmqOaR_NgZk4S1rmJ+x8LBQ@mail.gmail.com>
	<CABsxX9JBsOX7sFYvmSjdq5N8pXPDrSv3V4DaRszKdpnBK_KxEA@mail.gmail.com>
	<CAN_LGv0RcA5y6Dyq25_poWxhwxoS7X6CGi71czrJji0E6NHzzg@mail.gmail.com>
Date: Tue, 5 Jun 2012 10:19:09 -0700
Message-ID: <CABsxX9LEL-pX=+BZgemURk_6OsbSja7S0m-eoL6=bsEQchM6Pg@mail.gmail.com>
Subject: Re: [systemd-devel] systemd-udevd: excessive I/O usage
From: "Kok, Auke-jan H" <auke-jan.h.kok@intel.com>
To: "Alexander E. Patrakov" <patrakov@gmail.com>
Cc: Peeters Simon <peeters.simon@gmail.com>,
        systemd-devel@lists.freedesktop.org, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 4, 2012 at 8:50 PM, Alexander E. Patrakov
<patrakov@gmail.com> wrote:
> 2012/6/5 Kok, Auke-jan H <auke-jan.h.kok@intel.com> wrote on systemd-devel list:
>> It seems your system is taking well into 15+ seconds before btrfs is
>> actually *ready* on your system, which seems to be the main hiccup
>> (note, speculation here). I've personally become a bit displeased with
>> btrfs performance recently myself, so, I'm wondering if you should try
>> ext4 for now.
>>
>> Other than that, after btrfs/udev finally pops to life, things seem to
>> start relatively quickly.
>
> I think btrfs is to blame here, because I think my system started to
> be affected by this problem after ext4 -> btrfs conversion.
>
> I recently changed my ext4-on-lvm gentoo system at home by
> defragmenting the LVM (http://bisqwit.iki.fi/source/lvm2defrag.html),
> converting the biggest (200 GB, 80% used, mostly video files, git
> trees and SVN checkouts of various projects) logical volume to btrfs,
> making the backup of metadata, deleting the LVM partition and creating
> ordinary partitions in places that were occupied by LVM volumes before
> according to the backup. It worked. Then I made a btrfs subvolume and
> transferred the contents of the former root partition there using tar.
> So now I have two copies of my root filesystem - one on ext4 and one
> on btrfs. I recreated an initramfs for each of them using dracut.
> Result: boot from ext4 takes less than 15 seconds, while boot from
> btrfs takes 9 minutes (or 5 minutes if I disable readahead - the data
> file is not valid anyway on btrfs).
>
> One problem is btrfsck in the dracut-created initramfs - it fires
> every time (with btrfs mounted read-only?). The other problem is the
> btrfs-cache-1 kernel thread - I was told on #btrfs that it is a
> one-time thing, but apparently it wants to do its caching every boot
> due to some breakage. During the boot, there are also warnings about
> hung tasks with some locks held.
>
> I am attaching a dmesg file illustrating all of the problems mentioned above.

I've had the same (bad) experiences since 3.3.

The "one time thing" is creating the free space cache. On my home
systems, with 3.4.x, it's still creating them *every* boot, which
certainly accounts for IO busy, which on a sluggish spinning rust is
disastrous, to say the least.

Hung tasks in btrfs have been present since it was merged. Remember
that they're only a warning - eventially almost always they will
unhang. But still ver frustrating.

I'm currently dropping btrfs from my home development system because
I've spent too much time in the last month trying to get my btrfs
volumes back up after a kernel upgrade. So, I feel your pain.

Auke

>
> --
> Alexander E. Patrakov
