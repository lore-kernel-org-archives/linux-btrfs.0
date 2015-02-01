Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f42.google.com ([209.85.215.42]:61631 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753456AbbBAS5H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 1 Feb 2015 13:57:07 -0500
Received: by mail-la0-f42.google.com with SMTP id ms9so34698800lab.1
        for <linux-btrfs@vger.kernel.org>; Sun, 01 Feb 2015 10:57:05 -0800 (PST)
Received: from Macadmins-MBP-5.smurfbo (h-60-194.a213.priv.bahnhof.se. [46.59.60.194])
        by mx.google.com with ESMTPSA id be13sm682682lab.38.2015.02.01.10.57.04
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Sun, 01 Feb 2015 10:57:05 -0800 (PST)
Date: Sun, 1 Feb 2015 19:55:54 +0100
From: Kalle Ahlin <kalle.ahlin@gmail.com>
To: linux-btrfs@vger.kernel.org
Message-ID: <etPan.54ce76ff.327b23c6.4cb@Macadmins-MBP-5.smurfbo>
Subject: How to fix uncorrectable errors
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

 
About a week ago my machine started reporting the following after scrubbing the btrfs filesystem which I do regularly:

scrub status for f74d1ed9-e591-4cbd-8b56-cda5c2f40285  
scrub device /dev/sda (id 1) history
scrub started at Wed Jan 28 01:00:02 2015 and finished after 48737 seconds
total bytes scrubbed: 3.04TiB with 0 errors
scrub device /dev/sdh (id 2) history
scrub started at Wed Jan 28 01:00:02 2015 and finished after 15612 seconds
total bytes scrubbed: 1.22TiB with 0 errors
scrub device /dev/sdb (id 3) history
scrub started at Wed Jan 28 01:00:02 2015 and finished after 20059 seconds
total bytes scrubbed: 789.07GiB with 0 errors
scrub device /dev/sdc (id 5) history
scrub started at Wed Jan 28 01:00:02 2015 and finished after 29746 seconds
total bytes scrubbed: 2.13TiB with 0 errors
scrub device /dev/sde (id 6) history
scrub started at Wed Jan 28 01:00:02 2015 and finished after 26889 seconds
total bytes scrubbed: 2.10TiB with 4027 errors
error details: csum=4027
corrected errors: 0, uncorrectable errors: 4027, unverified errors: 0
scrub device /dev/sdg (id 7) history
scrub started at Wed Jan 28 01:00:02 2015 and finished after 27231 seconds
total bytes scrubbed: 2.10TiB with 4027 errors
error details: csum=4027
corrected errors: 0, uncorrectable errors: 4027, unverified errors: 0



That is, there are 4027 uncorrectable errors on both /dev/sde and /dev/sdg. Neither disk seems to have any hardware problems as far as I can tell. I have no idea why this happened - nothing unusual has been going on with the machine or filesystem.  

I have found the files which seems to be related to the uncorrectable errors, and if I do anything at all with those files the entire btrfs filesystem is mounted readonly and I cannot fix the problem.  

>From a data perspective it’s not a big deal - the problem files are not important. For now I have made a copy of the files in the subvolume with problems to a new sub volume and I’m now using that copy instead without any problems.  

However, I would like to get rid of those uncorrectable errors since they make me somewhat worried that something serious is wrong with my filesystem so I would like to fix that. Preferrably I would like to remove the subvolume with the broked files but I cannot do that since I cannot rm the files and I cannot remove the subvolume unless it’s empty.  

Can anybody help me with suggestions about how to solve this?  

(Since the exact same problem appeared out of nowhere on two separate disks which don’t have any hardware issues I’m also curious how something like this could happen but I guess that is secondary to actually fixing the problem.)

Best Regards,  
Karl Ahlin


