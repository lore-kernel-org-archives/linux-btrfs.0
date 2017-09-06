Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:38763 "EHLO
        mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751029AbdIFFhj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Sep 2017 01:37:39 -0400
Received: by mail-wm0-f53.google.com with SMTP id 187so26433053wmn.1
        for <linux-btrfs@vger.kernel.org>; Tue, 05 Sep 2017 22:37:39 -0700 (PDT)
MIME-Version: 1.0
From: Dave <davestechshop@gmail.com>
Date: Wed, 6 Sep 2017 01:37:17 -0400
Message-ID: <CAH=dxU6uVGXbdYc_65P6XbSby76A6Y=qoM6=cXMHkWDV8JRHVg@mail.gmail.com>
Subject: send | receive: received snapshot is missing recent files
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm running Arch Linux on BTRFS. I use Snapper to take hourly
snapshots and it works without any issues.

I have a bash script that uses send | receive to transfer snapshots to
a couple external HDD's. The script runs daily on a systemd timer. I
set all this up recently and I first noticed that it runs every day
and that the expected snapshots are received.

At a glance, everything looked correct. However, today was my day to
drill down and really make sure everything was working.

To my surprise, the newest received incremental snapshots are missing
all recent files. These new snapshots reflect the system state from
weeks ago and no files more recent than a certain date are in the
snapshots.

However, the snapshots are newly created and newly received. The work
is being done fresh each day when my script runs, but the results are
anchored back in time at this earlier date. Weird.

I'm not really sure where to start troubleshooting, so I'll start by
sharing part of my script. I'm sure the problem is in my script, and
is not related to BTRFS or snapper functionality. (As I said, the
Snapper snapshots are totally OK before being sent | received.

These are the key lines of the script I'm using to send | receive a snapshot:

    old_num=$(snapper -c "$config" list -t single | awk
'/'"$selected_uuid"'/ {print $1}')
    old_snap=$SUBVOLUME/.snapshots/$old_num/snapshot
    new_num=$(snapper -c "$config" create --print-number)
    new_snap=$SUBVOLUME/.snapshots/$new_num/snapshot
    btrfs send -c "$old_snap" "$new_snap" | $ssh btrfs receive
"$backup_location"

I have to admit that even after reading the following page half a
dozen times, I barely understand the difference between -c and -p.
https://btrfs.wiki.kernel.org/index.php/FAQ#What_is_the_difference_between_-c_and_-p_in_send.3F

After reading that page again today, I feel like I should switch to -p
(maybe). However, the -c vs -p choice probably isn't my problem.

Any ideas what my problem could be?
