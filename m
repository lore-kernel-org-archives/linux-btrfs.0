Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.webx.cz ([109.123.222.201]:48770 "EHLO mail.webx.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751688AbdBHSps (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 8 Feb 2017 13:45:48 -0500
Received: from localhost (localhost [127.0.0.1])
        by mail.webx.cz (Postfix) with ESMTP id 463E342840
        for <linux-btrfs@vger.kernel.org>; Wed,  8 Feb 2017 19:38:07 +0100 (CET)
Received: from mail.webx.cz ([127.0.0.1])
        by localhost (mail1.webx.cz [127.0.0.1]) (amavisd-new, port 10042)
        with LMTP id vkbe19eAgJ3w for <linux-btrfs@vger.kernel.org>;
        Wed,  8 Feb 2017 19:38:07 +0100 (CET)
Received: from libor-nb.localnet (unknown [77.48.255.132])
        (using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mail.webx.cz (Postfix) with ESMTPSA id 235634283E
        for <linux-btrfs@vger.kernel.org>; Wed,  8 Feb 2017 19:38:07 +0100 (CET)
From: Libor =?utf-8?B?S2xlcMOhxI0=?= <libor.klepac@bcom.cz>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: BTRFS and cyrus mail server
Date: Wed, 08 Feb 2017 19:38:06 +0100
Message-ID: <24389268.gAX5gEpECb@libor-nb>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,
inspired by recent discussion on BTRFS vs. databases i wanted to ask on 
suitability of BTRFS for hosting a Cyrus imap server spool. I haven't found 
any recent article on this topic.

I'm preparing migration of our mailserver to Debian Stretch, ie. kernel 4.9 
for now. We are using XFS for storage now. I will migrate using imapsync to 
new server. Both are virtual machines running on vmware on Dell hardware.
Disks are on battery backed hw raid controllers over vmfs.

I'm considering using BTRFS, but I'm little concerned because of reading this 
mailing list ;)

I'm interested in using:
 - compression (emails should compress well - right?)
 - maybe deduplication (cyrus does it by hardlinking of same content messages 
now) later
 - snapshots for history
 - send/receive for offisite backup
 - what about data inlining, should it be turned off?

Our Cyrus pool consist of ~520GB of data in ~2,5million files, ~2000 
mailboxes.
We have message size limit of ~25MB, so emails are not bigger than that.
There are however bigger files, these are per mailbox caches/index files of 
cyrus (some of them are around 300MB) - and these are also files which are 
most modified.
Rest of files (messages) are usualy just writen once.

-----------
I started using btrfs on backup server as a storage for 4 backuppc run in 
containers (backups are then send away with btrbk), year ago.
After switching off data inlining i'm satisfied, everything works (send/
receive is sometime slow, but i guess it's because of sata disks on receive 
side).


Thanks for you opinions,

Libor

