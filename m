From: Daniel J Blueman <daniel.blueman@gmail.com>
Subject: Re: does btrfs have RAID I/O throughput (un)limiting sysctls, similar
	to md?
Date: Sat, 6 Feb 2010 13:10:56 +0000
Message-ID: <6278d2221002060510i947059bx12697ba0a4f5e4c@mail.gmail.com>
References: <c67eed301002051637p1288e120tb37c649ac44d40c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: 0bo0 <0.bugs.only.0@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <c67eed301002051637p1288e120tb37c649ac44d40c@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Feb 6, 2010 at 12:37 AM, 0bo0 <0.bugs.only.0@gmail.com> wrote:
> i've a 4 drive array connected via a PCIe SATA card.
>
> per OS (opensuse) default, md RAID I/O performance was being limited =
by,
>
> =A0cat /proc/sys/dev/raid/speed_limit_min
> =A0 =A01000
> =A0cat /proc/sys/dev/raid/speed_limit_max
> =A0 =A0200000
>
> changing,
>
> =A0echo "dev.raid.speed_limit_min=3D100000" >> /etc/sysctl.conf
> =A0echo "dev.raid.speed_limit_max=3D600000" >> /etc/sysctl.conf
>
> enabled full/best I/O throughput.

These proc entries affect just array reconstruction, not general I/O
performance/throughput, so affect just an edge-case of applications
requiring maximum latency/minimum throughout guarantees.
--=20
Daniel J Blueman
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
