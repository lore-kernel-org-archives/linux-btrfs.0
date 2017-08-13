Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from server.len.li ([83.169.36.140]:36480 "EHLO server.len.li"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751053AbdHMRXJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 13 Aug 2017 13:23:09 -0400
Received: from localhost (localhost [127.0.0.1])
        by server.len.li (Postfix) with ESMTP id 24663320A26
        for <linux-btrfs@vger.kernel.org>; Sun, 13 Aug 2017 19:14:00 +0200 (CEST)
Received: from server.len.li ([127.0.0.1])
        by localhost (mafio.net [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id fvWF3+USBpEs for <linux-btrfs@vger.kernel.org>;
        Sun, 13 Aug 2017 19:13:58 +0200 (CEST)
Received: from [10.38.190.42] (unknown [89.204.154.42])
        (using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: the@len.li)
        by server.len.li (Postfix) with ESMTPSA id 6597332089A
        for <linux-btrfs@vger.kernel.org>; Sun, 13 Aug 2017 19:13:58 +0200 (CEST)
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Subject: Btrfs data recovery
From: Christian Rene Thelen <the@len.li>
Date: Sun, 13 Aug 2017 19:12:48 +0200
To: linux-btrfs@vger.kernel.org
Message-ID: <1386d7aa-10c2-4463-a26b-50f2b022f6b6@email.android.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I have formated an encrypted disk, containing a LVM with a btrfs system.

All superblocks appear to be destroyed; the btrfs-progs tools can't find the root tree anymore and scalpel, binwalk, foremost & co return only scrap. The filesystem was on an ssd and mounted with -o compression=lzo.

How screwed am I? Any chances to recover some files? Is there a plausible way to rebuild the superblock manually? Checking the raw image with xxd gives me not a single readable word.

I managed to decrypt the LV and dd it to an image. What can I do?
