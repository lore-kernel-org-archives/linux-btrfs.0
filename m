Return-Path: <linux-btrfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 473AAC54EBC
	for <linux-btrfs@archiver.kernel.org>; Sun,  8 Jan 2023 01:06:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229989AbjAHA74 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 7 Jan 2023 19:59:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbjAHA7z (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 7 Jan 2023 19:59:55 -0500
X-Greylist: delayed 14369 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 07 Jan 2023 16:59:52 PST
Received: from len.romanrm.net (len.romanrm.net [91.121.86.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92186164BD
        for <linux-btrfs@vger.kernel.org>; Sat,  7 Jan 2023 16:59:52 -0800 (PST)
Received: from nvm (nvm2.home.romanrm.net [IPv6:fd39::4a:3cff:fe57:d6b5])
        by len.romanrm.net (Postfix) with SMTP id ED9B44020A
        for <linux-btrfs@vger.kernel.org>; Sun,  8 Jan 2023 00:59:50 +0000 (UTC)
Date:   Sun, 8 Jan 2023 05:59:50 +0500
From:   Roman Mamedov <rm@romanrm.net>
To:     linux-btrfs@vger.kernel.org
Subject: Re: Weird behavior (no commit?) when writing to a really slow block
 device
Message-ID: <20230108055950.2625fd86@nvm>
In-Reply-To: <20230108020331.3491fb52@nvm>
References: <20230108020331.3491fb52@nvm>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sun, 8 Jan 2023 02:03:31 +0500
Roman Mamedov <rm@romanrm.net> wrote:

> if there was a complete flush of data and metadata. And I suspect issuing a
> "sync" on command-line would cause that to occur.

In fact, no. :D

Running a "sync" simply does not return while the rsync process is still
actively copying data to the slow device.

It's stuck for 30 minutes by now, despite it would take less than 4 minutes to
write out the 3.5 GB of the writeback buffer at 15 MB/sec of the target device.

And the free space in "df" still did not update from what it was when I started
the copy process 3 hours ago. rsync has managed to write 185 GB since then,
according to its /proc/xxx/io.


-- 
With respect,
Roman
