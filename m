Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f177.google.com ([209.85.213.177]:33912 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805AbbLZDxx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Dec 2015 22:53:53 -0500
Received: by mail-ig0-f177.google.com with SMTP id m11so97563767igk.1
        for <linux-btrfs@vger.kernel.org>; Fri, 25 Dec 2015 19:53:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <18552.1451078098@ccs.covici.com>
References: <16107.1451037790@ccs.covici.com>
	<CAPmG0jbOu6BmKfbaoJ6pzprWzbch3tf7=zbBS8AcDz4MQVEJZA@mail.gmail.com>
	<18552.1451078098@ccs.covici.com>
Date: Fri, 25 Dec 2015 20:53:52 -0700
Message-ID: <CAJCQCtTQ-73RbohA9wdrttj_uSnF5f8x1Opa0a6O2ZF-5NVqhQ@mail.gmail.com>
Subject: Re: btrfs problems on new file system
From: Chris Murphy <lists@colorremedies.com>
To: covici@ccs.covici.com
Cc: Henk Slager <eye1tm@gmail.com>, linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If you can post the entire dmesg somewhere that'd be useful. MUAs tend
to wrap that text and make it unreadable on list. I think the problems
with your volume happened before the messages, but it's hard to say.
Also, a generation of nearly 5000 is not that new?

On another thread someone said you probably need to specify the device
to mount when using Btrfs and lvmcache? And the device to specify is
the combined HDD+SSD logical device, for lvmcache that's the "cache
LV", which is the OriginLV + CachePoolLV. If Btrfs decides to mount
the origin, it can result in corruption.


Chris Murphy
