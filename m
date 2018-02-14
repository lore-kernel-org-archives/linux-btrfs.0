Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([46.4.129.203]:48902 "EHLO mail.virtall.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1030429AbeBNOZ3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Feb 2018 09:25:29 -0500
Received: from mail.virtall.com (localhost [127.0.0.1])
        by mail.virtall.com (Postfix) with ESMTP id 3806A1E1145D
        for <linux-btrfs@vger.kernel.org>; Wed, 14 Feb 2018 14:19:22 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1]) (Authenticated sender: tch@virtall.com)
        by mail.virtall.com (Postfix) with ESMTPSA
        for <linux-btrfs@vger.kernel.org>; Wed, 14 Feb 2018 14:19:22 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Wed, 14 Feb 2018 23:19:20 +0900
From: Tomasz Chmielewski <tch@virtall.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: fatal database corruption with btrfs "out of space" with ~50 GB left
Message-ID: <de1fdabb35ffe14eb92433ef444494e7@virtall.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Just FYI, how dangerous running btrfs can be - we had a fatal, 
unrecoverable MySQL corruption when btrfs decided to do one of these "I 
have ~50 GB left, so let's do out of space (and corrupt some files at 
the same time, ha ha!)".

Running btrfs RAID-1 with kernel 4.14.



Tomasz Chmielewski
https://lxadm.com
