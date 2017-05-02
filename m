Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp73.ord1c.emailsrvr.com ([108.166.43.73]:54008 "EHLO
        smtp73.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750955AbdEBGVm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 2 May 2017 02:21:42 -0400
Received: from smtp2.relay.ord1c.emailsrvr.com (localhost [127.0.0.1])
        by smtp2.relay.ord1c.emailsrvr.com (SMTP Server) with ESMTP id 57824C00BD
        for <linux-btrfs@vger.kernel.org>; Tue,  2 May 2017 02:14:15 -0400 (EDT)
Received: by smtp2.relay.ord1c.emailsrvr.com (Authenticated sender: intranet-AT-rqc.ru) with ESMTPSA id F06DCC00A1
        for <linux-btrfs@vger.kernel.org>; Tue,  2 May 2017 02:14:14 -0400 (EDT)
Received: from CM01.administration.intranet.rqc.ru (unknown [10.101.2.94])
        by postfix.thinky.servers.rqc.ru (Postfix) with ESMTPS id 8AFEB77E7
        for <linux-btrfs@vger.kernel.org>; Tue,  2 May 2017 06:14:12 +0000 (UTC)
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
From: Marat Khalili <mkh@rqc.ru>
Subject: BTRFS warning (device sda7): block group 181491728384 has wrong
 amount of free space
Message-ID: <c73f374d-5d53-c2cf-d09c-5d91f0919b12@rqc.ru>
Date: Tue, 2 May 2017 09:14:12 +0300
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dear all,

I cannot understand two messages in syslog, could someone please shed 
some light? Here they are:

> Apr 29 08:54:03 container-name kernel: [792742.662375] BTRFS warning 
> (device sda7): block group 181491728384 has wrong amount of free space
> Apr 29 08:54:03 container-name kernel: [792742.662381] BTRFS warning 
> (device sda7): failed to load free space cache for block group 
> 181491728384, rebuilding it now
Especially strange is the fact that messages appear in LXC container's 
syslog, but not in syslog of a host system. I only saw network and 
apparmor-related messages in container syslogs before.

I didn't run any usermode btrfs tools at the time (especially in 
container, since they are not even installed there), but there's a quota 
set for this subvolume, and it was coming close to exhausting by large 
mysql database. There're no snapshots this time. smartmon finds no problems.

> marat@host:~$ uname -a
> Linux host 4.4.0-72-generic #93-Ubuntu SMP Fri Mar 31 14:07:41 UTC 
> 2017 x86_64 x86_64 x86_64 GNU/Linux
> marat@host:~$ lsb_release -a
> No LSB modules are available.
> Distributor ID:    Ubuntu
> Description:    Ubuntu 16.04.2 LTS
> Release:    16.04
> Codename:    xenial
> marat@host:~$ btrfs --version
> btrfs-progs v4.4
> marat@host:~$ sudo btrfs qgroup show -F -pcre 
> /mnt/lxc/container-name/rootfs
> qgroupid         rfer         excl     max_rfer max_excl parent  child
> --------         ----         ----     -------- -------- ------  -----
> 0/802        63.93GiB 63.93GiB 64.00GiB         none ---     ---
> marat@host:~$ sudo btrfs filesystem show /dev/sda7 # run after freeing 
> space by clearing database
> Label: 'data'  uuid: 37d3313a-e2ad-4b7f-98fc-a01d815952e0
>     Total devices 2 FS bytes used 47.73GiB
>     devid    1 size 2.71TiB used 114.01GiB path /dev/sda7
>     devid    2 size 2.71TiB used 114.01GiB path /dev/sdb7
> marat@host:~$ sudo btrfs filesystem df /mnt/lxc/container-name/rootfs# 
> run after freeing space by clearing database
> Data, RAID1: total=111.00GiB, used=46.83GiB
> System, RAID1: total=8.00MiB, used=32.00KiB
> Metadata, RAID1: total=3.00GiB, used=983.11MiB
> GlobalReserve, single: total=336.00MiB, used=0.00B
> marat@host:~$ sudo lxc-attach -n container-name cat /proc/mounts | 
> grep sda7
> /dev/sda7 / btrfs 
> rw,relatime,space_cache,subvolid=802,subvol=/lxc/container-name/rootfs 0 0

--

With Best Regards,
Marat Khalili

