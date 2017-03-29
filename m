Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:48117 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753643AbdC2Hif (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 29 Mar 2017 03:38:35 -0400
Date: Wed, 29 Mar 2017 15:36:54 +0800
From: kernel test robot <xiaolong.ye@intel.com>
To: linux-btrfs@vger.kernel.org
Cc: lkp@01.org, "Huang, Ying" <ying.huang@intel.com>,
        Philip Li <philip.li@intel.com>
Subject: [LKP] [btrfs] "fio: pid=2214, got signal=7" error showed in fio test
 for btrfs
Message-ID: <20170329073654.GK17604@yexl-desktop>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="l06SQqiZYCi8rTKz"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--l06SQqiZYCi8rTKz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

We detected below error messages in fio pmem test for btrfs.

machine: Intel(R) Xeon(R) CPU E5-2695 v3 @ 2.30GHz with 256G memory
kernel: v4.10 
test parameters:

[global]
bs=2M
ioengine=mmap
iodepth=32
size=7669584457
direct=0
runtime=200
invalidate=1
fallocate=posix
group_reporting

time_based

[task_0]
rw=write
directory=/fs/pmem0
numjobs=14

[task_1]
rw=write
directory=/fs/pmem1
numjobs=14


==> /tmp/stderr <==
fio: pid=2214, got signal=7
fio: pid=2215, got signal=7
fio: pid=2217, got signal=7
fio: pid=2220, got signal=7
fio: pid=2222, got signal=7
fio: pid=2224, got signal=7
fio: pid=2225, got signal=7
fio: pid=2227, got signal=7
fio: pid=2216, got signal=7
fio: pid=2218, got signal=7
fio: pid=2219, got signal=7
fio: pid=2221, got signal=7
fio: pid=2223, got signal=7
fio: pid=2226, got signal=7
fio: pid=2200, got signal=7
fio: pid=2201, got signal=7
fio: pid=2203, got signal=7
fio: pid=2204, got signal=7
fio: pid=2205, got signal=7
fio: pid=2208, got signal=7
fio: pid=2209, got signal=7
fio: pid=2210, got signal=7
fio: pid=2211, got signal=7
fio: pid=2212, got signal=7
fio: pid=2213, got signal=7
fio: pid=2202, got signal=7
fio: pid=2206, got signal=7
fio: pid=2207, got signal=7
fio: file hash not empty on exit

while fio test is ok for ext4 with the same test parameters.
Attached reproduce.sh may help reproduce the problem.

Thanks,
Xiaolong

--l06SQqiZYCi8rTKz
Content-Type: application/x-sh
Content-Disposition: attachment; filename="reproduce.sh"
Content-Transfer-Encoding: quoted-printable

modprobe nd_e820=0Admsetup remove_all=0Awipefs -a --force /dev/pmem0=0Awipe=
fs -a --force /dev/pmem1=0Amkfs -t btrfs /dev/pmem1=0Amkfs -t btrfs /dev/pm=
em0=0Amkdir -p /fs/pmem0=0Amount -t btrfs /dev/pmem0 /fs/pmem0=0Amkdir -p /=
fs/pmem1=0Amount -t btrfs /dev/pmem1 /fs/pmem1=0A=0Afor file in /sys/device=
s/system/cpu/cpu*/cpufreq/scaling_governor=0Ado=0A	echo performance > $file=
=0Adone=0A=0Aecho '=0A[global]=0Abs=3D2M=0Aioengine=3Dmmap=0Aiodepth=3D32=
=0Asize=3D7669584457=0Adirect=3D0=0Aruntime=3D200=0Ainvalidate=3D1=0Afalloc=
ate=3Dposix=0Agroup_reporting=0A=0Atime_based=0A=0A[task_0]=0Arw=3Dwrite=0A=
directory=3D/fs/pmem0=0Anumjobs=3D14=0A=0A[task_1]=0Arw=3Dwrite=0Adirectory=
=3D/fs/pmem1=0Anumjobs=3D14' | fio --output-format=3Djson -=0A
--l06SQqiZYCi8rTKz--
