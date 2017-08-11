Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ua0-f170.google.com ([209.85.217.170]:33463 "EHLO
        mail-ua0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752883AbdHKPGh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 11 Aug 2017 11:06:37 -0400
Received: by mail-ua0-f170.google.com with SMTP id 80so16228896uas.0
        for <linux-btrfs@vger.kernel.org>; Fri, 11 Aug 2017 08:06:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <27218.183.88.87.49.1502426431.squirrel@mail>
References: <21234.192.168.42.222.1502253143.squirrel@mail>
 <CAJCQCtRNT_WL41j7ZBsO3N_=5xAkj4=j7djrh+Ryg3gAV5qyZg@mail.gmail.com>
 <22169.183.88.87.49.1502260598.squirrel@mail> <CAJCQCtTpE26mxLq7ufUxCin37sajcXhnM3QsgjXjVd8x_Pw9PA@mail.gmail.com>
 <27218.183.88.87.49.1502426431.squirrel@mail>
From: Chris Murphy <lists@colorremedies.com>
Date: Fri, 11 Aug 2017 09:06:36 -0600
Message-ID: <CAJCQCtQqaNxK7Y-1czvA61mrb_QQSDc=nPZ=S-3-wSnEeND8sg@mail.gmail.com>
Subject: Re: btrfs issue with mariadb incremental backup
To: siranee.ja@tpc.co.th
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>, voravat@tpcorp.co.th
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 10, 2017 at 10:40 PM,  <siranee.ja@tpc.co.th> wrote:
> Hi Chris,
> The kernel version that I test is "4.4.0-89-generic" as I tested on ubuntu lxd If I
> want to change the kernel version I have to upgrade the host box.


I can't parse what kernel that really is compared to upstream, which
is at 4.4.80.



> As you suggest the rsync to  compare the subvolumes. I found the point.
> the subvolumes are different only after I start to del old subvolumes on machine A
> the steps are

You're saying a read only snapshot's contents are changing after
deleting other (child) snapshots?

If you have a subvolume "subvolume" and you make read only snapshots
of it over time "snapshot1" "snapshot2" "snapshot3" "snapshot4"
"snapshot5" "snapshot6" on both machine A and machine B.

And rsync -anc machineA/snapshot6 machineB/snapshot6 they are identical.

And then you delete "snapshot1" "snapshot2" "snapshot3" "snapshot4" on
machine A.

And rsync -anc machineA/snapshot6 machineB/snapshot6 they are no
longer identical?

I've never heard of this before.


>
> 30 08 * * * root /root/script/backup/backupsnap.sh root password
> /var/lib/mariadb/mysql >> /var/log/btrfs_snap.log
> 05 09 * * * root /root/script/backupbtrfs_inc.sh /var/lib/mariadb 192.168.45.166
> /var/lib/mariadb >> /var/log/btrfs_send.log
> 30 19 * * * root /root/script/delete_btrfs_sub_snap_volume.sh /var/lib/mariadb 7 >>
> /var/log/btrfs_del.log

I have no idea what this means or why it's relevant.


>
>
> The following script maintain snapshot to currently only 7 snapshots.
> [root@backuplogC7 ~]# cat /root/script/delete_btrfs_sub_snap_volume.sh
> basepath=$1
> keepcount=$2
> havecount=`btrfs sub list -s ${basepath}|cut -d' ' -f14|wc -l`
> delcount=$[$keepcount-$havecount];
> datet=$(date +%Y%m%d%H%M)
> echo "Start Delete ${datet}"
> if [ $delcount -lt 0 ]; then
> # list only snapshot subvolume
> for i in `btrfs sub list -s ${basepath}|cut -d' ' -f14|head ${delcount}`
> do
>         echo "btrfs sub delete ${basepath}/$i"
>         btrfs sub delete ${basepath}/$i
>         btrfs sub sync ${basepath}


Seems sane.


> Does it mean my delete script is not the properly way of the btrfs purge old
> snapshot on source?


I don't think so. But I still don't understand the problem, and what
exactly has changed and when, and it might be my confusion. But if you
have an ro snapshot that's correct at one moment, but then changes
when some other (child) snapshots are deleted, that's pretty
remarkable so I have to assume I'm confused.


-- 
Chris Murphy
