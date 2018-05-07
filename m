Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from corp-mailer.zoner.com ([217.198.120.77]:40009 "EHLO
        corp-mailer.zoner.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752129AbeEGLkD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 May 2018 07:40:03 -0400
Received: from imap33.zoner.com (imap33.zoner.com [217.198.123.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by corp-mailer.zoner.com (Postfix) with ESMTPS id 1EA7F1F24F
        for <linux-btrfs@vger.kernel.org>; Mon,  7 May 2018 13:40:02 +0200 (CEST)
Received: from [10.1.0.143] (gw-sady.zoner.com [217.198.112.101])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: martin.svec@zoner.com)
        by imap33.zoner.com (Postfix) with ESMTPSA id E940E180007C26
        for <linux-btrfs@vger.kernel.org>; Mon,  7 May 2018 13:40:01 +0200 (CEST)
From: Martin Svec <martin.svec@zoner.cz>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: metadata_ratio mount option?
Message-ID: <bd1f9ac2-49ce-7095-7f1f-8a2f905da995@zoner.cz>
Date: Mon, 7 May 2018 13:40:01 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

According to man btrfs [1], I assume that metadata_ratio=1 mount option should
force allocation of one metadata chunk after every allocated data chunk. However,
when I set this option and start filling btrfs with "dd if=/dev/zero of=dummyfile.dat",
only data chunks are allocated but no metadata ones. So, how does the metadata_ratio
option really work?

Note that I'm trying to use this option as a workaround of the bug reported here: 

https://www.spinics.net/lists/linux-btrfs/msg75104.html

i.e. I want to manually preallocate metadata chunks to avoid nightly ENOSPC errors.

Best regards.

Martin


[1] https://btrfs.wiki.kernel.org/index.php/Manpage/btrfs(5)#MOUNT_OPTIONS



