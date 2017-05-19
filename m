Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:57329 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750806AbdESGa3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 19 May 2017 02:30:29 -0400
Date: Fri, 19 May 2017 14:28:14 +0800
From: Ye Xiaolong <xiaolong.ye@intel.com>
To: linux-btrfs@vger.kernel.org
Cc: lkp@01.org
Subject: Re: [LKP] [btrfs] "fio: pid=2214, got signal=7" error showed in fio
 test for btrfs
Message-ID: <20170519062814.GC1795@yexl-desktop>
References: <20170329073654.GK17604@yexl-desktop>
 <20170329075048.GA300@yexl-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170329075048.GA300@yexl-desktop>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 03/29, Ye Xiaolong wrote:
>Attach kmsg and reproduce script.
>
>Note: kernel cmdline contained "memmap=104G!4G memmap=104G!132G"

Hi,

Any feedback about this issue?

Thanks,
Xiaolong

>
>Thanks,
>Xiaolong
>
>On 03/29, kernel test robot wrote:
>>Hi,
>>
>>We detected below error messages in fio pmem test for btrfs.
>>
>>machine: Intel(R) Xeon(R) CPU E5-2695 v3 @ 2.30GHz with 256G memory
>>kernel: v4.10 
>>test parameters:
>>
>>[global]
>>bs=2M
>>ioengine=mmap
>>iodepth=32
>>size=7669584457
>>direct=0
>>runtime=200
>>invalidate=1
>>fallocate=posix
>>group_reporting
>>
>>time_based
>>
>>[task_0]
>>rw=write
>>directory=/fs/pmem0
>>numjobs=14
>>
>>[task_1]
>>rw=write
>>directory=/fs/pmem1
>>numjobs=14
>>
>>
>>==> /tmp/stderr <==
>>fio: pid=2214, got signal=7
>>fio: pid=2215, got signal=7
>>fio: pid=2217, got signal=7
>>fio: pid=2220, got signal=7
>>fio: pid=2222, got signal=7
>>fio: pid=2224, got signal=7
>>fio: pid=2225, got signal=7
>>fio: pid=2227, got signal=7
>>fio: pid=2216, got signal=7
>>fio: pid=2218, got signal=7
>>fio: pid=2219, got signal=7
>>fio: pid=2221, got signal=7
>>fio: pid=2223, got signal=7
>>fio: pid=2226, got signal=7
>>fio: pid=2200, got signal=7
>>fio: pid=2201, got signal=7
>>fio: pid=2203, got signal=7
>>fio: pid=2204, got signal=7
>>fio: pid=2205, got signal=7
>>fio: pid=2208, got signal=7
>>fio: pid=2209, got signal=7
>>fio: pid=2210, got signal=7
>>fio: pid=2211, got signal=7
>>fio: pid=2212, got signal=7
>>fio: pid=2213, got signal=7
>>fio: pid=2202, got signal=7
>>fio: pid=2206, got signal=7
>>fio: pid=2207, got signal=7
>>fio: file hash not empty on exit
>>
>>while fio test is ok for ext4 with the same test parameters.
>>Attached reproduce.sh may help reproduce the problem.
>>
>>Thanks,
>>Xiaolong
>
>


>modprobe nd_e820
>dmsetup remove_all
>wipefs -a --force /dev/pmem0
>wipefs -a --force /dev/pmem1
>mkfs -t btrfs /dev/pmem1
>mkfs -t btrfs /dev/pmem0
>mkdir -p /fs/pmem0
>mount -t btrfs /dev/pmem0 /fs/pmem0
>mkdir -p /fs/pmem1
>mount -t btrfs /dev/pmem1 /fs/pmem1
>
>for file in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
>do
>	echo performance > $file
>done
>
>echo '
>[global]
>bs=2M
>ioengine=mmap
>iodepth=32
>size=7669584457
>direct=0
>runtime=200
>invalidate=1
>fallocate=posix
>group_reporting
>
>time_based
>
>[task_0]
>rw=write
>directory=/fs/pmem0
>numjobs=14
>
>[task_1]
>rw=write
>directory=/fs/pmem1
>numjobs=14' | fio --output-format=json -

>_______________________________________________
>LKP mailing list
>LKP@lists.01.org
>https://lists.01.org/mailman/listinfo/lkp

