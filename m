Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:65127 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273AbaHIJdb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 9 Aug 2014 05:33:31 -0400
Received: by mail-wi0-f181.google.com with SMTP id bs8so2058608wib.14
        for <linux-btrfs@vger.kernel.org>; Sat, 09 Aug 2014 02:33:30 -0700 (PDT)
Received: from linuxpc.localnet (188-22-86-150.adsl.highway.telekom.at. [188.22.86.150])
        by mx.google.com with ESMTPSA id fe5sm23407417wjc.12.2014.08.09.02.33.28
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Sat, 09 Aug 2014 02:33:28 -0700 (PDT)
From: GEO <1g2e3o4@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: Couple of problems regarding btrfs qgroup show reliability
Date: Sat, 09 Aug 2014 11:33:27 +0200
Message-ID: <3096690.KjNAKx2h9H@linuxpc>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Here is an simplified excerpt of my backup bash script:

CURRENT_TIME=$(date +"%Y-%m-%d_%H:%M-%S")
# LAST_TIME variable contains the timestamp of the last backup in the same 
format as $CURRENT_TIME

btrfs subvolume snapshot -r /mnt/root/@home /mnt/root/@home-
backup-$CURRENT_TIME
sync

# Define space check variables

btrfs quota enable /mnt/root
SUBVOLUME_ID=$(btrfs subvolume list /mnt/root | grep $CURRENT_TIME | awk 
'{print $2}')
ABSOLUTE_SIZE=$(btrfs qgroup show /mnt/root | grep "0/$SUBVOLUME_ID" | awk 
'{print $2}')
RELATIVE_SIZE=$(btrfs qgroup show /mnt/root | grep "0/$SUBVOLUME_ID" | awk 
'{print $3}')
FREE_SPACE=$(df -B1 /mnt/backup | tail -1 | awk '{print $4}')

# Now I want to check if there is enough space on /mnt/backup, for sending the 
incremental part to /mnt/backup (Let us assume us, that there have not been 
made snapshots more recent than @home-backup-$LAST_TIME), so I did the 
following in my backup script:

if (( $FREE_SPACE > $RELATIVE_SIZE )); then
   btrfs send -p /mnt/root/@home-backup-$LAST_TIME /mnt/root/@home-
backup-$CURRENT_TIME | btrfs receive /mnt/backup
fi

# For the initial bootstrapping I choose 

if (( $FREE_SPACE < $ABSOLUTE_SIZE )); then
   btrfs send /mnt/root/@home-backup-$CURRENT_TIME | btrfs receive /mnt/backup
fi


Now I have a couple of questions:

1.) does it matter when I enable btrfs quota? I mean even if it is enabled for 
the first time in the backup script? Does this have any influence on the values 
determined for $ABSOLUTE_SIZE and $RELATIVE_SIZE?

2.) does btrfs implement some way to show free space on its own or do I have 
to rely on df?

3.) Is the logic right for the incremental backup space check? I mean the 
unshared space should be more or less what is transmittted by btrfs send, 
right, since we already have the last snapshot on the backup drive? If this 
isn't the right approach, how do I get the size difference of two special 
snapshots say @home-backup-$CURRENT_TIME and @home-backup-$LAST_TIME?

4.) Out of curiosity I checked the ABSOLUTE_SIZE values of the sent snapshot 
on the backup device too, in theory they should be equal right? But they are 
not for some reason they are not equal at all, neither are the RELATIVE_SIZE 
values.
Checking the ABSOLUTE_SIZE with du, seems to inidicate that the values on the 
backup device seems to be right (2,6 GB), but on the internal drive the value 
of $ABSOLUTE_SIZE is 2.0 GB, how can that be?
Of course the RELATIVE_SIZE can very a bit, depending on what snapshots are 
residing on the same drive, but let as assume no confounding factors, then 
they should be roughly in the same magnitude. And the ABSOLUTE_SIZE variables 
should be definitely equal on both the backup drive and the internal harddrive 
for the same snapshot. 
Where am I wrong?

5.) I understand that btrfs snapshot delete breaks the RELATIVE_SIZE, at least 
this is noted in the wiki. Is this still true, and will it be resolved soon? 
The wiki also notes "After deleting a subvolume, you must manually delete the 
associated qgroup." How would I do that?
