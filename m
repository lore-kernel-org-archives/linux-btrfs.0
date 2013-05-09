Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f172.google.com ([74.125.82.172]:33137 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912Ab3EIHRm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 May 2013 03:17:42 -0400
Received: by mail-we0-f172.google.com with SMTP id w60so2631292wes.3
        for <linux-btrfs@vger.kernel.org>; Thu, 09 May 2013 00:17:40 -0700 (PDT)
Message-ID: <518B4D92.1030409@gmail.com>
Date: Thu, 09 May 2013 09:17:38 +0200
From: Gabriel de Perthuis <g2p.code@gmail.com>
MIME-Version: 1.0
To: Zhi Yong Wu <zwu.kernel@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: [RFC 0/5] BTRFS hot relocation support
References: <1367830418-26865-1-git-send-email-zwu.kernel@gmail.com>
In-Reply-To: <1367830418-26865-1-git-send-email-zwu.kernel@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 09 May 2013 07:13:56 +0800, Zhi Yong Wu wrote:
> HI, all
> 
>    I saw that bcache will be merged into kernel upstream soon, so i
> want to know if btrfs hot relocation support is still meanful, if no,
> i will not continue to work on it. can anyone let me know this?
> thanks.

bcache performance would be poor if Btrfs-raid1 is used;
the hits will be spread across mirrors are random, bcache will have
to cache twice as much and convergence could be slow.

Hot tracking also has much more precise info about which files are hot, 
whereas bcache can't know anything about files that are in the
page cache and risks evicting some of them.

It all comes down to benchmarks, but these two situations could be easy
wins for hot-reloc.

