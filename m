Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ve0-f176.google.com ([209.85.128.176]:60154 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022AbaBHWpz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 8 Feb 2014 17:45:55 -0500
Received: by mail-ve0-f176.google.com with SMTP id oz11so3897414veb.35
        for <linux-btrfs@vger.kernel.org>; Sat, 08 Feb 2014 14:45:54 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20140209041050.529ff6f9@natsu>
References: <20140206021516.304732cd@natsu>
	<52F3EED4.7030603@fb.com>
	<agsfsa-mks.ln1@hurikhan77.spdns.de>
	<20140208173310.1f90af3b@natsu>
	<20140208114634.GH6490@carfax.org.uk>
	<cikisa-qf7.ln1@hurikhan77.spdns.de>
	<20140209041050.529ff6f9@natsu>
Date: Sat, 8 Feb 2014 16:45:54 -0600
Message-ID: <CAE5mzviJK7NA_bT2ccVKwbo4FfjhZNykSw6jm0j=CpwC5Lk+=g@mail.gmail.com>
Subject: Re: Provide a better free space estimate on RAID1
From: cwillu <cwillu@cwillu.com>
To: Roman Mamedov <rm@romanrm.net>
Cc: Kai Krakow <hurikhan77+btrfs@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Everyone who has actually looked at what the statfs syscall returns
and how df (and everyone else) uses it, keep talking.  Everyone else,
go read that source code first.

There is _no_ combination of values you can return in statfs which
will not be grossly misleading in some common scenario that someone
cares about.
