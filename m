From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: 3.2-rc4: scrubbing locks up the kernel, then hung tasks on boot
Date: Thu, 15 Mar 2012 18:39:56 +0100
Message-ID: <201203151839.56317.Martin@lichtvoll.de>
References: <201112171833.34720.Martin@lichtvoll.de> <4F48986D.4090703@gmx.net> <201203151832.19703.Martin@lichtvoll.de> (sfid-20120315_183454_374374_B9F41B06)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Cc: Arne Jansen <sensille@gmx.net>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201203151832.19703.Martin@lichtvoll.de>
List-ID: <linux-btrfs.vger.kernel.org>

Am Donnerstag, 15. M=C3=A4rz 2012 schrieb Martin Steigerwald:
> [20880.564225] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message. [20880.564234] btrfs           D
> 000012d2     0  3348      1 0x00000000 [20880.564251]  c0b72080
> 00000086 2cae1a17 000012d2 ec3ae5a0 00000000 000012d2 c14769c0
> [20880.564275]  c0b7222c c14769c0 00008050 e0b96ce0 ee000120 d1d5dae0
> d1d5db20 00000028 [20880.564298]  c105d451 00000092 c12b949b 00000092
> f0b7037c 00000246 eee6073c c105d451

Seems to be a thread of the btrfs scrub start process:

martin@deepdance:~/scrub-hang-2012-03-15#1> ps aux | grep "btrfs " | gr=
ep -v grep=20
root      3347  0.5  0.0  18520   112 pts/5    Sl   18:10   0:08 btrfs =
scrub start /
root      3429  0.0  0.0   2128   304 pts/5    D+   18:24   0:00 btrfs =
scrub cancel /

deepdance:/proc/3348> cat cmdline
btrfsscrubstart/#                                                      =
                                                             =20
deepdance:/proc/3348> cat sched =20
btrfs (3348, #threads: 3)
---------------------------------------------------------
se.exec_start                      :      20693902.056600
se.vruntime                        :       4558167.340245
se.sum_exec_runtime                :          8284.354850
nr_switches                        :               116554
nr_voluntary_switches              :               115784
nr_involuntary_switches            :                  770
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  563

Thanks,
--=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
