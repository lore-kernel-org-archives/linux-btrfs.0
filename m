Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailex.mailcore.me ([94.136.40.62]:53259 "EHLO
	mailex.mailcore.me" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751455AbcADMLH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Jan 2016 07:11:07 -0500
Subject: Re: Filesystem hang on kernel 4.2.0 with copy reflink
To: Jack Wang <jack.wang.usish@gmail.com>
References: <568A2EDF.6090909@markandruth.co.uk>
 <CA+res+SW+8-R7kOxZdxXdmRyDdDQ8G=CUkVnYK=O=YzHHmCDqg@mail.gmail.com>
Cc: linux-btrfs@vger.kernel.org
From: Mark Zealey <mark@markandruth.co.uk>
Message-ID: <568A6154.1060101@markandruth.co.uk>
Date: Mon, 4 Jan 2016 14:11:00 +0200
MIME-Version: 1.0
In-Reply-To: <CA+res+SW+8-R7kOxZdxXdmRyDdDQ8G=CUkVnYK=O=YzHHmCDqg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It overflowed the dmesg buffer but hopefully contains enough cores - 
https://mark.zealey.org/download/btrfs_crash.txt

Some other output:

# mount
/dev/sdb1 on / type btrfs (rw,noatime,skip_balance,subvol=@)
proc on /proc type proc (rw,noexec,nosuid,nodev)
sysfs on /sys type sysfs (rw,noexec,nosuid,nodev)
none on /sys/fs/cgroup type tmpfs (rw)
none on /sys/fs/fuse/connections type fusectl (rw)
none on /sys/kernel/debug type debugfs (rw)
none on /sys/kernel/security type securityfs (rw)
none on /sys/firmware/efi/efivars type efivarfs (rw)
udev on /dev type devtmpfs (rw,mode=0755)
devpts on /dev/pts type devpts (rw,noexec,nosuid,gid=5,mode=0620)
tmpfs on /run type tmpfs (rw,noexec,nosuid,size=10%,mode=0755)
none on /run/lock type tmpfs (rw,noexec,nosuid,nodev,size=5242880)
none on /run/shm type tmpfs (rw,nosuid,nodev)
none on /run/user type tmpfs 
(rw,noexec,nosuid,nodev,size=104857600,mode=0755)
none on /sys/fs/pstore type pstore (rw)
cgroup on /sys/fs/cgroup/cpuset type cgroup (rw,relatime,cpuset)
cgroup on /sys/fs/cgroup/cpu type cgroup (rw,relatime,cpu)
cgroup on /sys/fs/cgroup/cpuacct type cgroup (rw,relatime,cpuacct)
cgroup on /sys/fs/cgroup/blkio type cgroup (rw,relatime,blkio)
cgroup on /sys/fs/cgroup/memory type cgroup (rw,relatime,memory)
cgroup on /sys/fs/cgroup/devices type cgroup (rw,relatime,devices)
cgroup on /sys/fs/cgroup/freezer type cgroup 
(rw,relatime,freezer,release_agent=/run/cgmanager/agents/cgm-release-agent.freezer)
cgroup on /sys/fs/cgroup/net_cls type cgroup 
(rw,relatime,net_cls,release_agent=/run/cgmanager/agents/cgm-release-agent.net_cls)
/dev/sdb1 on /home type btrfs (rw,noatime,skip_balance,subvol=@home)
/dev/sdb3 on /boot/efi type vfat (rw)
binfmt_misc on /proc/sys/fs/binfmt_misc type binfmt_misc 
(rw,noexec,nosuid,nodev)
rpc_pipefs on /run/rpc_pipefs type rpc_pipefs (rw)
systemd on /sys/fs/cgroup/systemd type cgroup 
(rw,noexec,nosuid,nodev,none,name=systemd)

  ps auwx|grep ' D'
root       275  0.0  0.0      0     0 ?        D    Jan02   2:29 
[btrfs-transacti]
root       361  0.0  0.0      0     0 ?        D    13:30   0:00 
[kworker/u16:5]
root       404  0.0  0.0      0     0 ?        D    13:31   0:00 
[kworker/u16:7]
root      1127  0.0  0.0      0     0 ?        D    13:54   0:00 
[kworker/u16:0]
root      1137  0.0  0.0      0     0 ?        D    13:54   0:00 
[kworker/u16:2]
root      1189  2.3  0.0  25932  2216 pts/7    D+   13:55   0:02 cp -vax 
--reflink=always /.snapshots/psql/var/lib/postgresql/ .
root      1191  0.0  0.0      0     0 ?        D    13:55   0:00 
[kworker/u16:3]
root      1197  0.0  0.0      0     0 ?        D    13:55   0:00 
[kworker/u16:4]
root      1200  0.0  0.0      0     0 ?        D    13:55   0:00 
[kworker/u16:8]
root      1201  0.0  0.0      0     0 ?        D    13:55   0:00 
[kworker/u16:10]
root      1230  0.0  0.0      0     0 ?        D    13:55   0:00 
[kworker/u16:15]
root      1231  0.0  0.0      0     0 ?        D    13:55   0:00 
[kworker/u16:16]
root     14569  0.0  0.0      0     0 ?        D    12:18   0:00 
[kworker/u16:9]
root     14572  0.0  0.0      0     0 ?        D    12:19   0:00 
[kworker/u16:11]
root     14573  0.0  0.0      0     0 ?        D    12:19   0:00 
[kworker/u16:12]
root     14582  0.0  0.0      0     0 ?        D    12:19   0:00 
[kworker/u16:13]
root     32228  0.0  0.0      0     0 ?        D    13:17   0:00 
[kworker/u16:1]

The last output of the cp:

‘/.snapshots/psql/var/lib/postgresql/9.5/main/base/16385/25009’ -> 
‘./postgresql/9.5/main/base/16385/25009’
‘/.snapshots/psql/var/lib/postgresql/9.5/main/base/16385/25011’ -> 
‘./postgresql/9.5/main/base/16385/25011’
‘/.snapshots/psql/var/lib/postgresql/9.5/main/base/16385/25012’ -> 
‘./postgresql/9.5/main/base/16385/25012’
‘/.snapshots/psql/var/lib/postgresql/9.5/main/base/16385/25243’ -> 
‘./postgresql/9.5/main/base/16385/25243’
‘/.snapshots/psql/var/lib/postgresql/9.5/main/base/16385/25246’ -> 
‘./postgresql/9.5/main/base/16385/25246’
‘/.snapshots/psql/var/lib/postgresql/9.5/main/base/16385/25248’ -> 
‘./postgresql/9.5/main/base/16385/25248’
‘/.snapshots/psql/var/lib/postgresql/9.5/main/base/16385/25249’ -> 
‘./postgresql/9.5/main/base/16385/25249’
‘/.snapshots/psql/var/lib/postgresql/9.5/main/base/16385/25251’ -> 
‘./postgresql/9.5/main/base/16385/25251’
‘/.snapshots/psql/var/lib/postgresql/9.5/main/base/16385/25254’ -> 
‘./postgresql/9.5/main/base/16385/25254’
‘/.snapshots/psql/var/lib/postgresql/9.5/main/base/16385/25256’ -> 
‘./postgresql/9.5/main/base/16385/25256’
‘/.snapshots/psql/var/lib/postgresql/9.5/main/base/16385/25257’ -> 
‘./postgresql/9.5/main/base/16385/25257’
‘/.snapshots/psql/var/lib/postgresql/9.5/main/base/16385/25283’ -> 
‘./postgresql/9.5/main/base/16385/25283’

And those (and other files) that it would have copied:

-rw------- 1 postgres postgres         0 Dec 30 18:11 
/.snapshots/psql/var/lib/postgresql/9.5/main/base/16385/25243
-rw------- 1 postgres postgres         0 Dec 30 18:11 
/.snapshots/psql/var/lib/postgresql/9.5/main/base/16385/25246
-rw------- 1 postgres postgres      8192 Dec 30 18:11 
/.snapshots/psql/var/lib/postgresql/9.5/main/base/16385/25248
-rw------- 1 postgres postgres      8192 Dec 30 18:11 
/.snapshots/psql/var/lib/postgresql/9.5/main/base/16385/25249
-rw------- 1 postgres postgres         0 Dec 30 18:11 
/.snapshots/psql/var/lib/postgresql/9.5/main/base/16385/25251
-rw------- 1 postgres postgres         0 Dec 30 18:11 
/.snapshots/psql/var/lib/postgresql/9.5/main/base/16385/25254
-rw------- 1 postgres postgres      8192 Dec 30 18:11 
/.snapshots/psql/var/lib/postgresql/9.5/main/base/16385/25256
-rw------- 1 postgres postgres      8192 Dec 30 18:11 
/.snapshots/psql/var/lib/postgresql/9.5/main/base/16385/25257
-rw------- 1 postgres postgres 409624576 Dec 30 19:10 
/.snapshots/psql/var/lib/postgresql/9.5/main/base/16385/25283
-rw------- 1 postgres postgres    122880 Dec 30 18:29 
/.snapshots/psql/var/lib/postgresql/9.5/main/base/16385/25283_fsm
-rw------- 1 postgres postgres         0 Dec 30 18:22 
/.snapshots/psql/var/lib/postgresql/9.5/main/base/16385/25284
-rw------- 1 postgres postgres      8192 Dec 30 18:22 
/.snapshots/psql/var/lib/postgresql/9.5/main/base/16385/25285

Also I have quota tracking enabled on the btrfs volume if that makes any 
difference.

Mark

On 04/01/16 12:41, Jack Wang wrote:
> Hi Mark,
>
> Could you do below when the hang happens, and post the dmesg.
>
> echo w > /proc/sysrq-trigger
>
> 2016-01-04 9:35 GMT+01:00 Mark Zealey <mark@markandruth.co.uk>:
>> Hi there, I've run into a very strange hang with btrfs. I was trying to
>> restore a directory (postgres database) from a readonly snapshot. To do this
>> i used the command `cp -ar --reflink=always`. This worked fine for 100s of
>> files, however when it got to a particular file 16 kworker threads (I have 8
>> processors in this system) got marked as being in D state (with 0 cpu usage
>> or disk usage) and I could not access the btrfs file system any more. I
>> can't see any kernel message or OOPS. Can you please let me know what
>> additional debug information I can provide to help track this issue down in
>> the kernel?
>>
>> System is latest ubuntu 14.04 LTS with a backported wily kernel (package
>> linux-image-4.2.0-22-generic):
>>
>> 4.2.0-22-generic #27~14.04.1-Ubuntu SMP Fri Dec 18 10:57:53 UTC 2015 x86_64
>> x86_64 x86_64 GNU/Linux
>>
>> Thanks
>>
>> Mark
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

