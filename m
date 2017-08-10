Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.a-tech.co.th ([202.149.98.155]:37141 "EHLO tpcorp.co.th"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752098AbdHJCDS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 9 Aug 2017 22:03:18 -0400
Message-ID: <2136.49.228.125.166.1502330595.squirrel@mail>
In-Reply-To: <CAJCQCtTpE26mxLq7ufUxCin37sajcXhnM3QsgjXjVd8x_Pw9PA@mail.gmail.com>
References: <21234.192.168.42.222.1502253143.squirrel@mail>
    <CAJCQCtRNT_WL41j7ZBsO3N_=5xAkj4=j7djrh+Ryg3gAV5qyZg@mail.gmail.com>
    <22169.183.88.87.49.1502260598.squirrel@mail>
    <CAJCQCtTpE26mxLq7ufUxCin37sajcXhnM3QsgjXjVd8x_Pw9PA@mail.gmail.com>
Date: Thu, 10 Aug 2017 09:03:15 +0700 (ICT)
Subject: Re: btrfs issue with mariadb incremental backup
From: siranee.ja@tpc.co.th
To: "Chris Murphy" <lists@colorremedies.com>
Cc: "Chris Murphy" <lists@colorremedies.com>,
        "Btrfs BTRFS" <linux-btrfs@vger.kernel.org>, voravat@tpcorp.co.th
MIME-Version: 1.0
Content-Type: text/plain;charset=tis-620
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'll test and response the result to you soon.

I have another question about the combination within Host lxd ubuntu and lxd
container centos

Host Machine X (16.04.3 LTS with lxd 2.0.10 and btrfs-progs v4.4
 kernel 4.4 ) set 1 lvm raw partitions and format to btrfs filesystem (on host)
Partition A  mount to /opt/partA

Container A (CentOS Linux release 7.3.1611 (Core) )  is in Host Machine X
mount /opt/partA to /var/lib/mariadb in container A

Container A making local readonly snapshot everyday

The Options are (online "btrfs send ||ssh btrfs receive" or batch "btrfs send >
file.btrfs" and scp from local to remote then "btrfs receive -f file.btrfs")
1. use btrfs send from Host Machine X to Host Machine Y
2. use btrfs send from Container A to Host Machine Y
3. use btrfs send from Container A to Container B
4. use btrfs send incremental from Host Machine X to Host Machine Y
5. use btrfs send incremental from Container A to Host Machine Y
6. use btrfs send incremental from Container A to Container B


Host Machine Y (16.04.3 LTS with lxd 2.0.10 and btrfs-progs v4.4
 kernel 4.4 ) set 1 lvm raw partitions and format to btrfs filesystem (on host)
Partition B  mount to /opt/partB

Container B (CentOS Linux release 7.3.1611 (Core) ) is in Host Machine Y
mount /opt/partB to /var/lib/mariadb in container B

The Options are (online "btrfs send ||ssh btrfs receive" or batch "btrfs send >
file.btrfs" and scp from local to remote then "btrfs receive -f file.btrfs")

1. use btrfs receive from Host Machine X to Host Machine Y
2. use btrfs receive from Container A to Host Machine Y
3. use btrfs receive from Container A to Container B
4. use btrfs receive incremental from Host Machine X to Host Machine Y
5. use btrfs receive incremental from Container A to Host Machine Y
6. use btrfs receive incremental from Container A to Container B

Could you please suggest me what is the combination that should work properly with
btrfs send and receive?

I plan to setup 2 Site (Production Site and DR site) each site has 1 box (Host
Machine X and Y) and want to test btrfs to send incremental.

Best Regards,

Siranee Jarwachirakul.


> On Wed, Aug 9, 2017 at 12:36 AM,  <siranee.ja@tpc.co.th> wrote:
>
>>   488  btrfs sub snap mysql_201707230830 mysql
>>   489  systemctl start mariadb
>>   490  btrfs sub list .
>>   491  cat /var/log/mariadb/mariadb.log
>
> OK so mysql_201707230830 once on machine B is inconsistent somehow. So
> the questions I have are:
>
> Is mysql_201707230830 on machine A really identical to
> mysql_201707230830 on machine B? You can do an rsync -anc (double
> check those options) which should independently check whether those
> two subvolumes are in fact identical. The -n is a no op, which doesn't
> really matter much because as read only subvolumes any attempt to sync
> will just result in noisy messages. The -c causes rsync to do its own
> checksum verification on both sides.
>
> If the subvolumes are different, we need to find out why.
>
> If the subvolumes are the same, then I wonder if you can reproduce the
> mariadb complaint on machine A merely by making a rw snapshot of
> mysql_201707230830 and trying to start it. If so, then it's not a send
> receive problem, it sounds like the snapshot itself is inconsistent,
> maybe mariadb hasn't actually completely closed out the database at
> the time the read only snapshot was taken? I'm not sure.
>
> If the subvolumes are different, I'm going to recommend updating at
> least the btrfs-progs because 4.4 is kinda old at this point. The
> kernel code is what's mainly responsible for the send stream, and the
> user space code is mainly responsible for receiving. And I don't off
> hand know or want to look up all the send receive changes between 4.4
> and 4.12 to speculate on whether this is has already been fixed.
>
> What's the kernel version?
>
> --
> Chris Murphy
>


