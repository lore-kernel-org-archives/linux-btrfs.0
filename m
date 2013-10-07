Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f176.google.com ([74.125.82.176]:50886 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653Ab3JGWgN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Oct 2013 18:36:13 -0400
Received: by mail-we0-f176.google.com with SMTP id w62so6111736wes.35
        for <linux-btrfs@vger.kernel.org>; Mon, 07 Oct 2013 15:36:11 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 8 Oct 2013 00:36:11 +0200
Message-ID: <CACe732uTQrbVTV_Ov-0U4hLtdx8==2+9uXtzoVxFhteF3rr1ag@mail.gmail.com>
Subject: Re: kernel BUG at mm/page-writeback.c:2317!
From: Jan Killius <tmpnerd@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,
I'm hitting similar bug with the patch from Lui Bo.
But If I revert: 573aecafca1cf7a974231b759197a1aebcf39c2a,
Btrfs: actually limit the size of delalloc range) everything works fine.

Here are the 2 backtraces from my machines with 3.12-rc4:
http://imgur.com/sVkjGK6,mWUtzMV#0
http://imgur.com/sVkjGK6,mWUtzMV#1

Sorry for the screenshots but It was the only way to capture the backtraces.
I get the bug at the end of a 2GB scp transfer almost everytime.
