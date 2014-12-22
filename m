Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f169.google.com ([209.85.192.169]:48096 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753797AbaLVC3Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 21 Dec 2014 21:29:25 -0500
Received: by mail-pd0-f169.google.com with SMTP id z10so4939257pdj.0
        for <linux-btrfs@vger.kernel.org>; Sun, 21 Dec 2014 18:29:24 -0800 (PST)
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 8.1 \(1993\))
Subject: Re: [BTRFS-PROGS][PATCH][CLEANUP] Remove some gotos
From: Wang Shilong <wangshilong1991@gmail.com>
In-Reply-To: <1419185238-4254-1-git-send-email-kreijack@inwind.it>
Date: Mon, 22 Dec 2014 10:29:21 +0800
Cc: linux-btrfs@vger.kernel.org
Message-Id: <32047B4C-AC48-4C47-AD67-F28295666707@gmail.com>
References: <1419185238-4254-1-git-send-email-kreijack@inwind.it>
To: Goffredo Baroncelli <kreijack@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

> 
> Hi all,
> 
> before sending this patch I thought twice if it is really worth.
> I know the coding style is really a hot topic. But the world
> is already too ugly, to allow even that. And it is Merry Christmas, 
> so let me to make me a gift: a small clean up.
> 
> The culprit are some goto found in 'cmds-filesystem.c' inside the
> function 'cmd_show()'. These are used instead of an 'if' statement.
> 
> I wish you all a Happy Christmas and a successful start to 2015.

I think Nice cleanups are always good for Btrfs..Just take a look
at Btrfs kernel codes etc which really scared a lot of code reviewers and newbies..

Merry Chirismas guys. ^_^

> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Best Regards,
Wang Shilong

