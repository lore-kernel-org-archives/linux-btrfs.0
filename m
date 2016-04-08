Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:46945 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755289AbcDHNUS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 8 Apr 2016 09:20:18 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Fri, 08 Apr 2016 22:20:12 +0900
From: Tomasz Chmielewski <tch@virtall.com>
To: Roman Mamedov <rm@romanrm.net>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>, Chris Mason <clm@fb.com>,
        Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: Re: 4.4.0 - no space left with >1.7 TB free space left
In-Reply-To: <20160408165332.450659c4@natsu>
References: <0c19f800da3013f22f2ab0d77d5a9efb@admin.virtall.com>
 <20160208162410.58cb2b4a@natsu>
 <eaeffce90cd04fa5b91284ca580b5969@admin.virtall.com>
 <20160408165332.450659c4@natsu>
Message-ID: <cb23a9f1ff0a46a4a4de284f3c8743a5@admin.virtall.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-04-08 20:53, Roman Mamedov wrote:

>> > Do you snapshot the parent subvolume which holds the databases? Can you
>> > correlate that perhaps ENOSPC occurs at the time of snapshotting? If
>> > yes, then
>> > you should try the patch https://patchwork.kernel.org/patch/7967161/
>> >
>> > (Too bad this was not included into 4.4.1.)
>> 
>> By the way - was it included in any later kernel? I'm running 4.4.5 on
>> that server, but still hitting the same issue.
> 
> It's not in 4.4.6 either. I don't know why it doesn't get included, or 
> what
> we need to do. Last time I asked, it was queued:
> http://www.spinics.net/lists/linux-btrfs/msg52478.html
> But maybe that meant 4.5 or 4.6 only? While the bug is affecting people 
> on
> 4.4.x today.

Does it mean 4.5 also doesn't have it yet?


Tomasz Chmielewski
http://wpkg.org

