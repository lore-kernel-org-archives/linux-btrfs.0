Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f174.google.com ([209.85.213.174]:48709 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754686AbaAAUMn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Jan 2014 15:12:43 -0500
Received: by mail-ig0-f174.google.com with SMTP id hk11so40236628igb.1
        for <linux-btrfs@vger.kernel.org>; Wed, 01 Jan 2014 12:12:43 -0800 (PST)
Message-ID: <52C476B8.2040601@gmail.com>
Date: Wed, 01 Jan 2014 15:12:40 -0500
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: Kai Krakow <hurikhan77+btrfs@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: Migrate to bcache: A few questions
References: <kof6pa-akd.ln1@hurikhan77.spdns.de> <52C1990D.9060704@gmail.com>
In-Reply-To: <52C1990D.9060704@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/30/2013 11:02 AM, Austin S Hemmelgarn wrote:
> 
> As an alternative to using bcache, you might try something simmilar to
> the following:
>     64G SSD with /boot, /, and /usr
>     Other HDD with /var, /usr/portage, /usr/src, and /home
>     tmpfs or ramdisk for /tmp and /var/tmp
> This is essentially what I use now, and I have found that it
> significantly improves system performance.
> 
On this specific note, I would actually suggest against putting the 
portage tree on btrfs, it makes syncing go ridiculously slow, 
and it also seems to slow down emerge as well.
