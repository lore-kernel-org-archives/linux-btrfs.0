Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from hapkido.dreamhost.com ([66.33.216.122]:51741 "EHLO
	hapkido.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985AbaBHSfG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 8 Feb 2014 13:35:06 -0500
Received: from homiemail-a43.g.dreamhost.com (caibbdcaacei.dreamhost.com [208.113.200.248])
	by hapkido.dreamhost.com (Postfix) with ESMTP id 1B49C78156
	for <linux-btrfs@vger.kernel.org>; Sat,  8 Feb 2014 10:35:05 -0800 (PST)
Received: from homiemail-a43.g.dreamhost.com (localhost [127.0.0.1])
	by homiemail-a43.g.dreamhost.com (Postfix) with ESMTP id 4EBD08C058
	for <linux-btrfs@vger.kernel.org>; Sat,  8 Feb 2014 10:34:56 -0800 (PST)
Received: from [192.168.1.9] (unknown [50.46.251.200])
	(using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	(Authenticated sender: john@navitsky.org)
	by homiemail-a43.g.dreamhost.com (Postfix) with ESMTPSA id 26ED28C056
	for <linux-btrfs@vger.kernel.org>; Sat,  8 Feb 2014 10:34:56 -0800 (PST)
Message-ID: <52F67926.7060209@navitsky.org>
Date: Sat, 08 Feb 2014 10:36:22 -0800
From: John Navitsky <john@navitsky.org>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: system stuck with flush-btrfs-4 at 100% after filesystem resize
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I have a large file system that has been growing.  We've resized it a 
couple of times with the following approach:

   lvextend -L +800G /dev/raid/virtual_machines
   btrfs filesystem resize +800G /vms

I think the FS started out at 200G, we increased it by 200GB a time or 
two, then by 800GB and everything worked fine.

The filesystem hosts a number of virtual machines so the file system is 
in use, although the VMs individually tend not to be overly active.

VMs tend to be in subvolumes, and some of those subvolumes have snapshots.

This time, I increased it by another 800GB, and it it has hung for many 
hours (over night) with flush-btrfs-4 near 100% cpu all that time.

I'm not clear at this point that it will finish or where to go from here.

Any pointers would be much appreciated.

Thanks,

-john (newbie to BTRFS)


-------- procedure log ----------

romulus:/home/users/johnn # lvextend -L +800G /dev/raid/virtual_machines
romulus:/home/users/johnn #  btrfs filesystem resize +800G /vms
Resize '/vms' of '+800G'
[hangs]


top - 12:21:53 up 136 days,  2:45, 13 users,  load average: 30.39, 
30.37, 30.37
Tasks:   1 total,   1 running,   0 sleeping,   0 stopped,   0 zombie
%Cpu(s):  2.4 us,  2.3 sy,  0.0 ni, 95.1 id,  0.1 wa,  0.0 hi,  0.0 si, 
  0.0 st
MiB Mem:    129147 total,   127427 used,     1720 free,      264 buffers
MiB Swap:   262143 total,      661 used,   261482 free,    93666 cached

    PID USER      PR  NI  VIRT  RES  SHR S  %CPU %MEM     TIME+ COMMAND 

  48809 root      20   0     0    0    0 R  99.3  0.0   1449:14 
flush-btrfs-4

------- misc info -----------

romulus:/home/users/johnn # cat /etc/SuSE-release
openSUSE 12.3 (x86_64)
VERSION = 12.3
CODENAME = Dartmouth
romulus:/home/users/johnn # uname -a
Linux romulus.us.redacted.com 3.7.10-1.16-desktop #1 SMP PREEMPT Fri May 
31 20:21:23 UTC 2013 (97c14ba) x86_64 x86_64 x86_64 GNU/Linux
romulus:/home/users/johnn #


romulus:/home/users/johnn # vgdisplay
   --- Volume group ---
   VG Name               raid
   System ID
   Format                lvm2
   Metadata Areas        1
   Metadata Sequence No  19
   VG Access             read/write
   VG Status             resizable
   MAX LV                0
   Cur LV                7
   Open LV               7
   Max PV                0
   Cur PV                1
   Act PV                1
   VG Size               10.91 TiB
   PE Size               4.00 MiB
   Total PE              2859333
   Alloc PE / Size       1371136 / 5.23 TiB
   Free  PE / Size       1488197 / 5.68 TiB
   VG UUID               npyvGj-7vxF-IoI8-Z4tF-ygpP-Q2Ja-vV8sLA
[...]


romulus:/home/users/johnn # lvdisplay
[...]
   --- Logical volume ---
   LV Path                /dev/raid/virtual_machines
   LV Name                virtual_machines
   VG Name                raid
   LV UUID                qtzNBG-vuLV-EsgO-FDIf-sO7A-GKmd-EVjGjp
   LV Write Access        read/write
   LV Creation host, time romulus.redacted.com, 2013-09-25 11:05:54 -0500
   LV Status              available
   # open                 1
   LV Size                2.54 TiB
   Current LE             665600
   Segments               2
   Allocation             inherit
   Read ahead sectors     auto
   - currently set to     256
   Block device           253:4
[...]


johnn@romulus:~> df -h /vms
Filesystem      Size  Used Avail Use% Mounted on
/dev/dm-4       1.8T  1.8T  6.0G 100% /vms
johnn@romulus:~>


romulus:/home/users/johnn # btrfs filesystem show
[...]
Label: none  uuid: f08c5602-f53a-43c9-b498-fa788b01e679
         Total devices 1 FS bytes used 1.74TB
         devid    1 size 1.76TB used 1.76TB path /dev/dm-4
[...]
Btrfs v0.19+
romulus:/home/users/johnn #


romulus:/home/users/johnn # btrfs subvolume list /vms
ID 324 top level 5 path johnn-centos64
ID 325 top level 5 path johnn-ubuntu1304
ID 326 top level 5 path johnn-opensuse1203
ID 327 top level 5 path johnn-sles11sp3
ID 328 top level 5 path johnn-sles11sp2
ID 329 top level 5 path johnn-fedora19
ID 330 top level 5 path johnn-sles11sp1
ID 394 top level 5 path redacted-glance
ID 396 top level 5 path redacted_test
ID 397 top level 5 path glance
ID 403 top level 5 path test_redacted
ID 414 top level 5 path johnn-disktest
ID 460 top level 5 path redacted-opensuse-01
ID 472 top level 5 path redacted
ID 473 top level 5 path redacted2
ID 496 top level 5 path redacted_test
ID 524 top level 5 path redacted-moab
ID 525 top level 5 path redacted_redacted-1
ID 531 top level 5 path 
.snapshots/johnn-sles11sp2/2013.10.11-14:25.18/johnn-sles11sp2
ID 533 top level 5 path 
.snapshots/johnn-centos64/2013.10.11-15:32.16/johnn-centos64
ID 534 top level 5 path 
.snapshots/johnn-ubuntu1304/2013.10.11-15:33.20/johnn-ubuntu1304
ID 535 top level 5 path 
.snapshots/johnn-opensuse1203/2013.10.11-15:36.19/johnn-opensuse1203
ID 536 top level 5 path 
.snapshots/johnn-sles11sp3/2013.10.11-15:39.51/johnn-sles11sp3
ID 537 top level 5 path 
.snapshots/johnn-fedora19/2013.10.11-15:41.08/johnn-fedora19
ID 538 top level 5 path 
.snapshots/johnn-sles11sp2/2013.10.11-16:48.02/johnn-sles11sp2
ID 539 top level 5 path 
.snapshots/johnn-sles11sp1/2013.10.11-17:17.17/johnn-sles11sp1
ID 540 top level 5 path redacted-master
ID 547 top level 5 path redacted-client
ID 583 top level 5 path redacted-sles11sp3
ID 584 top level 5 path .snapshots/2013.11.07-12:52.01/vms
ID 586 top level 5 path rur_vm
ID 599 top level 5 path redacted-redactedsp3
ID 727 top level 5 path redacted-redactedsp3-test2
ID 771 top level 5 path redacted-sp3-standalone
ID 787 top level 5 path .trash/redacted-redactedsp3-Dec10
ID 806 top level 5 path 
.snapshots/redacted-redactedsp3-Dec10/2013.12.10-12:24.17/redacted-redactedsp3-Dec10
ID 826 top level 5 path redacted-sp3-standalone2
ID 894 top level 5 path redacted-redactedsp3-update01
ID 941 top level 5 path redacted-redacted-testvm
ID 1194 top level 5 path redacted-redactedsp3-jan3
ID 1210 top level 5 path redacted-sle11sp3-01
ID 1298 top level 5 path 
redacted_redacted_standalone_SLES11SP3-redacted_20140117+0928
ID 1324 top level 5 path redacted_redacted_SLES11SP3-redacted_20140117+0928
ID 1356 top level 5 path redacted_redacted_SP3
ID 1383 top level 5 path redacted_redacted-redacted-redacted11SP3-20140204
ID 1964 top level 5 path redacted-redacted-base
ID 1971 top level 5 path .trash/redacted-redacted-redacted
ID 1972 top level 5 path .trash/redacted-redacted-redacted2
ID 1988 top level 5 path .trash/redacted-redacted-redacted3
ID 1989 top level 5 path .trash/redacted-redacted-redacted4
ID 2002 top level 5 path redacted-feature-branch_71
ID 2003 top level 5 path 
.snapshots/johnn-sles11sp3/2014.02.07-10:51.57/johnn-sles11sp3
romulus:/home/users/johnn #


romulus:/home/users/johnn # lsof | grep vms | wc -l
1127
romulus:/home/users/johnn #


romulus:/home/users/johnn # ps -ef | grep VBoxHeadless | wc -l
18
romulus:/home/users/johnn #

