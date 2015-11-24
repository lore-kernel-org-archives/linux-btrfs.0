Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f180.google.com ([209.85.214.180]:34610 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568AbbKXCbp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Nov 2015 21:31:45 -0500
Received: by obbbj7 with SMTP id bj7so2869190obb.1
        for <linux-btrfs@vger.kernel.org>; Mon, 23 Nov 2015 18:31:44 -0800 (PST)
Received: from [192.168.50.103] (66-162-210-194.static.twtelecom.net. [66.162.210.194])
        by smtp.googlemail.com with ESMTPSA id do3sm7186751obb.15.2015.11.23.18.31.44
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1/SSLv3 cipher=OTHER);
        Mon, 23 Nov 2015 18:31:44 -0800 (PST)
To: linux-btrfs@vger.kernel.org
From: Steven Hoff <electrodexsnet@gmail.com>
Subject: Weird space issues (with more than plenty left; over 100GiB free on
 465.63GiB RAID partition)
Message-ID: <5653CC0F.7000001@gmail.com>
Date: Mon, 23 Nov 2015 19:31:43 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

BTRFS Community,

I seem to be having a bit of an issue. A comment on
https://btrfs.wiki.kernel.org/index.php/Problem_FAQ#I_get_.22No_space_left_on_device.22_errors.2C_but_df_says_I.27ve_got_lots_of_space
suggested reporting this to the mailing list.

Issue: BTRFS claims to be running out of space

Setup:
/home: 2 500GB hard drives in MDADM RAID1 with BTRFS being the primary 
filesystem

Output of various commands:

$ sudo btrfs fi df /home
Data, single: total=334.00GiB, used=333.84GiB
System, DUP: total=32.00MiB, used=80.00KiB
Metadata, DUP: total=1.50GiB, used=987.17MiB
unknown, single: total=336.00MiB, used=0.00

$ sudo btrfs fi show /home
Label: none  uuid: (private information removed)
     Total devices 1 FS bytes used 334.80GiB
     devid    1 size 465.63GiB used 337.06GiB path /dev/md0p1
Btrfs v3.12

$ df /home
Filesystem     1K-blocks      Used Available Use% Mounted on
/dev/md0p1     488252416 352418008 134988424  73% /home


I would like to note that "total" in the following line:
Data, single: total=334.00GiB, used=333.84GiB
gets smaller whenever data is deleted or moved from /home. I'm not sure if
that is by design, or if it is a bug. Either way, every once in a while 
applications will
start closing unexpectedly complaining that there is no space left. I've run
sudo btrfs fi balance /home
with no discernible result (other than relocating ~300 blocks). I have a 
system
monitoring tool that updates usage stats on my hard drives once every 
couple
seconds. It shows no abnormal disk usage during the times when 
applications start
complaining about no room left.

Any thoughts/ideas/help would be appreciated.

Regards,

Lectrode

