Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:37476 "EHLO
        mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751969AbdIFTqw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Sep 2017 15:46:52 -0400
Received: by mail-wm0-f44.google.com with SMTP id u26so34817070wma.0
        for <linux-btrfs@vger.kernel.org>; Wed, 06 Sep 2017 12:46:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAH=dxU7RM7s+pxT=wxE9WcUNMWjSG_A0=1pUWD1dWGVQ6g+g8Q@mail.gmail.com>
References: <CAH=dxU6uVGXbdYc_65P6XbSby76A6Y=qoM6=cXMHkWDV8JRHVg@mail.gmail.com>
 <CAH=dxU7RM7s+pxT=wxE9WcUNMWjSG_A0=1pUWD1dWGVQ6g+g8Q@mail.gmail.com>
From: Dave <davestechshop@gmail.com>
Date: Wed, 6 Sep 2017 15:46:29 -0400
Message-ID: <CAH=dxU6xwikfvfY7zCfuPavnCMMdecnyPckOZ3nyYm+_PZtOrg@mail.gmail.com>
Subject: Re: send | receive: received snapshot is missing recent files
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an even better set of steps for reproducing the problem.

[root@srv]# sync
[root@srv]# mkdir /home/.snapshots/test1
[root@srv]# btrfs su sn -r /home/ /home/.snapshots/test1/
Create a readonly snapshot of '/home/' in '/home/.snapshots/test1//home'
[root@srv]# sync
[root@srv]# mkdir /mnt/x5a/home/test1
[root@srv]# btrfs send /home/.snapshots/test1/home/ | btrfs receive
/mnt/x5a/home/test1/
At subvol /home/.snapshots/test1/home/
At subvol home
[root@srv]# ls -la /mnt/x5a/home/test1/home/user1/
NOTE: all recent files are present
[root@srv]# ls -la /mnt/x5a/home/test1/home/user2/Documents/
NOTE: all recent files are present
[root@srv]# mkdir /home/.snapshots/test2
[root@srv]# mkdir /mnt/x5a/home/test2
[root@srv]# btrfs su sn -r /home/ /home/.snapshots/test2/
Create a readonly snapshot of '/home/' in '/home/.snapshots/test2//home'
[root@srv]# sync
[root@srv]# btrfs send -p /home/.snapshots/test1/home/
/home/.snapshots/test2/home/ | btrfs receive /mnt/x5a/home/test2/
At subvol /home/.snapshots/test2/home/
At snapshot home
[root@srv]# ls -la /mnt/x5a/home/test2/home/user1/
NOTE: all recent files are MISSING
[root@srv]# ls -la /mnt/x5a/home/test2/home/user2/Documents/
NOTE: all recent files are MISSING

Any ideas what could be causing this problem with incremental backups?


On Wed, Sep 6, 2017 at 3:23 PM, Dave <davestechshop@gmail.com> wrote:
>
> Here is more info on this problem. I can reproduce this without using my script. Simple btrfs commands will reproduce the problem every time. The same files are missing every time. There is no randomness to the missing data.
>
> Here are my steps:
>
> 1. snapper -c home create
> result is a valid snapshot at /home/.snapshots/1704/snapshot
> 2. btrfs send /home/.snapshots/1704/snapshot | btrfs receive /mnt/x5a/home/1704
> 3. snapper -c home create
> result is a valid snapshot at /home/.snapshots/1716/snapshot
> 4. btrfs send -c /home/.snapshots/1704/snapshot/ /home/.snapshots/1716/snapshot/ | btrfs receive /mnt/x5a/home/1716/
>
> I expect /mnt/x5a/home/1716/snapshot to be identical to /home/.snapshots/1716/snapshot. However, it is not.
> The result is that /mnt/x5a/home/1716/snapshot is missing all recent files.
>
> Next step was to delete snapshot 1716 (in both locations) and repeat the send | receive using -p
>
> btrfs su del /mnt/x5a/home/1716/snapshot
> snapper -c home delete 1716
> snapper -c home create
> btrfs send -p /home/.snapshots/1704/snapshot/ /home/.snapshots/1716/snapshot/ | btrfs receive /mnt/x5a/home/1716/
>
> The result is once again that /mnt/x5a/home/1716/snapshot is missing all recent files. However, the other snapshots are all valid:
> /home/.snapshots/1704/snapshot is valid & complete
> /mnt/x5a/home/1704/snapshot -- non-incremental send: snapshot is valid & complete
> /home/.snapshots/1716/snapshot is valid & complete
> /mnt/x5a/home/1716/snapshot -- incrementally sent snapshot is missing all recent files whether sent with -c or -p
>
> The incrementally sent snapshot is even missing files that are present in the reference snapshot /mnt/x5a/home/1704/snapshot.
>
>
>
> On Wed, Sep 6, 2017 at 1:37 AM, Dave <davestechshop@gmail.com> wrote:
>>
>> I'm running Arch Linux on BTRFS. I use Snapper to take hourly
>> snapshots and it works without any issues.
>>
>> I have a bash script that uses send | receive to transfer snapshots to
>> a couple external HDD's. The script runs daily on a systemd timer. I
>> set all this up recently and I first noticed that it runs every day
>> and that the expected snapshots are received.
>>
>> At a glance, everything looked correct. However, today was my day to
>> drill down and really make sure everything was working.
>>
>> To my surprise, the newest received incremental snapshots are missing
>> all recent files. These new snapshots reflect the system state from
>> weeks ago and no files more recent than a certain date are in the
>> snapshots.
>>
>> However, the snapshots are newly created and newly received. The work
>> is being done fresh each day when my script runs, but the results are
>> anchored back in time at this earlier date. Weird.
>>
>> I'm not really sure where to start troubleshooting, so I'll start by
>> sharing part of my script. I'm sure the problem is in my script, and
>> is not related to BTRFS or snapper functionality. (As I said, the
>> Snapper snapshots are totally OK before being sent | received.
>>
>> These are the key lines of the script I'm using to send | receive a snapshot:
>>
>>     old_num=$(snapper -c "$config" list -t single | awk
>> '/'"$selected_uuid"'/ {print $1}')
>>     old_snap=$SUBVOLUME/.snapshots/$old_num/snapshot
>>     new_num=$(snapper -c "$config" create --print-number)
>>     new_snap=$SUBVOLUME/.snapshots/$new_num/snapshot
>>     btrfs send -c "$old_snap" "$new_snap" | $ssh btrfs receive
>> "$backup_location"
>>
>> I have to admit that even after reading the following page half a
>> dozen times, I barely understand the difference between -c and -p.
>> https://btrfs.wiki.kernel.org/index.php/FAQ#What_is_the_difference_between_-c_and_-p_in_send.3F
>>
>> After reading that page again today, I feel like I should switch to -p
>> (maybe). However, the -c vs -p choice probably isn't my problem.
>>
>> Any ideas what my problem could be?
>
>
