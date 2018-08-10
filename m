Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from shout02.mail.de ([62.201.172.25]:34787 "EHLO shout02.mail.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725724AbeHJEH7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 10 Aug 2018 00:07:59 -0400
Received: from postfix01.mail.de (postfix01.bt.mail.de [10.0.121.125])
        by shout02.mail.de (Postfix) with ESMTP id 0B69BC3344
        for <linux-btrfs@vger.kernel.org>; Fri, 10 Aug 2018 03:40:24 +0200 (CEST)
Received: from smtp03.mail.de (smtp03.bt.mail.de [10.0.121.213])
        by postfix01.mail.de (Postfix) with ESMTP id E78C640459
        for <linux-btrfs@vger.kernel.org>; Fri, 10 Aug 2018 03:40:23 +0200 (CEST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by smtp03.mail.de (Postfix) with ESMTPSA id C3FBD8073A
        for <linux-btrfs@vger.kernel.org>; Fri, 10 Aug 2018 03:40:23 +0200 (CEST)
From: erenthetitan@mail.de
To: linux-btrfs@vger.kernel.org
Subject: List of known BTRFS Raid 5/6 Bugs?
Date: Fri, 10 Aug 2018 03:40:23 +0200
Content-Type: text/plain; charset=utf-8
MIME-Version: 1.0
Message-Id: <20180810014023.C3FBD8073A@smtp03.mail.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I am searching for more information regarding possible bugs related to BTRFS Raid 5/6. All sites i could find are incomplete and information contradicts itself:

The Wiki Raid 5/6 Page (https://btrfs.wiki.kernel.org/index.php/RAID56)
warns of the write hole bug, stating that your data remains safe (except data written during power loss, obviously) upon unclean shutdown unless your data gets corrupted by further issues like bit-rot, drive failure etc.

The Wiki Gotchas Page (https://btrfs.wiki.kernel.org/index.php/Gotchas)
warns of possible incorrigible "transid" mismatch, not stating which versions are affected or what transid mismatch means for your data. It does not mention the write hole at all.

This Mail Archive (linux-btrfs@vger.kernel.org/msg55161.html" target="_blank">https://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg55161.html)
states that scrubbing BTRFS Raid 5/6 will always repair Data Corruption, but may corrupt your Metadata while trying to do so - meaning you have to scrub twice in a row to ensure data integrity.

The Bugzilla Entry (https://bugzilla.kernel.org/buglist.cgi?component=btrfs)
contains mostly unanswered bugs, which may or may not still count (2013 - 2018).

This Spinics Discussion (https://www.spinics.net/lists/linux-btrfs/msg76471.html)
states that the write hole can even damage old data eg. data that was not accessed during unclean shutdown, the opposite of what the Raid5/6 Status Page states!

This Spinics comment (https://www.spinics.net/lists/linux-btrfs/msg76412.html)
informs that hot-plugging a device will trigger the write hole. Accessed data will therefore be corrupted.
In case the earlier statement about old data corruption is true, random data could be permamently lost.
This is even more dangerous if you are connecting your devices via USB, as USB can unconnect due to external influence, eg. touching the cables, shaking...

Lastly, this Superuser question (https://superuser.com/questions/1325245/btrfs-transid-failure#1344494)
assumes that the transid mismatch bug could toggle your system unmountable.
While it might be possible to restore your data using sudo BTRFS Restore, it is still unknown how the transid mismatch is even toggled, meaning that your file system could fail at any time!

Do you know of any comprehensive and complete Bug list?

Do you know more about the stated Bugs?

Do you know further Bugs that are not addressed in any of these sites?

-------------------------------------------------------------------------------------------------
FreeMail powered by mail.de - MEHR SICHERHEIT, SERIOSITÄT UND KOMFORT
