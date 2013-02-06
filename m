Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f170.google.com ([209.85.214.170]:57767 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756749Ab3BFBLD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Feb 2013 20:11:03 -0500
Received: by mail-ob0-f170.google.com with SMTP id wc20so909489obb.29
        for <linux-btrfs@vger.kernel.org>; Tue, 05 Feb 2013 17:11:02 -0800 (PST)
Date: Tue, 5 Feb 2013 18:10:54 -0700
From: Jerry Snitselaar <dev@snitselaar.org>
To: linux-btrfs@vger.kernel.org
Subject: btrfs-progs: question about error message
Message-ID: <20130206011054.GA1803@cantor.us.oracle.com>
Reply-To: Jerry Snitselaar <dev@snitselaar.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In some testing that was being done the tester ran into the following:

--

/mnt/abo is a filesystem in Raid1-configuration having two disks: /dev/sdg2 
and /dev/sdg3. When trying to remove one of the devices, you get this error 
on the console: 

# btrfs device delete /dev/sdg2 /mnt/abo 
ERROR: error removing the device '/dev/sdg2' - Invalid argument 

/var/log/messages shows the real error: 
Jan 29 13:54:58 ca-ostest202 kernel: btrfs: unable to go below two devices on 
raid1 

The error message on the console output is wrong : '/dev/sdg2' is not an 
invalid argument, there's another reason why the delete-action can't be 
executed. 

--

Looking at it I can see the EINVAL being correct because it is being
told to remove a member from a raid1 with only 2 members, but I can
see how that message could be confusing as well. Is there some place
that tells users to look at /var/log/messages to see the other
message? Wondering if the error message should point users to
/var/log/messages to get more details.
