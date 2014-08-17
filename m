Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qa0-f46.google.com ([209.85.216.46]:59733 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133AbaHQI4H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 17 Aug 2014 04:56:07 -0400
Received: by mail-qa0-f46.google.com with SMTP id v10so3410495qac.33
        for <linux-btrfs@vger.kernel.org>; Sun, 17 Aug 2014 01:56:06 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 17 Aug 2014 14:26:06 +0530
Message-ID: <CAH-HCWVDtPv9gYxpcA4drK=FDes_0z8QTxqOBcocWf9T_b4tyQ@mail.gmail.com>
Subject: Putting very big and small files in one subvolume?
From: Shriramana Sharma <samjnaa@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello. One more Q re generic BTRFS behaviour.
https://btrfs.wiki.kernel.org/index.php/Main_Page specifically
advertises BTRFS's "Space-efficient packing of small files".

So far (on ext3/4) I have been using two partitions for small/regular
files (like my source code repos, home directory with its hidden
config subdirectories etc) and big files (like downloaded Linux ISOs,
VMs etc) under some sort of understanding that this will help curb
fragmentation -- frankly I'm not a professional sysadmin in some
company or such so my assumption may not be valid.

In any case, since BTRFS effectively discourages usage of separate
partitions to take advantage of subvolumes etc, and given the above
claim to the FS automatically handling small files efficiently, I
wonder if it makes sense any longer to create separate subvolumes for
such big/small files as I describe in my use case?

Thanks!

-- 
Shriramana Sharma ஶ்ரீரமணஶர்மா श्रीरमणशर्मा
