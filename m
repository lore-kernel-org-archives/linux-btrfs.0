Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f45.google.com ([209.85.160.45]:49736 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753615Ab3HFNzT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 Aug 2013 09:55:19 -0400
Received: by mail-pb0-f45.google.com with SMTP id mc17so454923pbc.4
        for <linux-btrfs@vger.kernel.org>; Tue, 06 Aug 2013 06:55:18 -0700 (PDT)
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: [PATCH 09/10] btrfs-progs: Fix the return value of btrfs-map-logical
From: Wang Shilong <wangshilong1991@gmail.com>
In-Reply-To: <20130806134851.GJ5284@twin.jikos.cz>
Date: Tue, 6 Aug 2013 21:55:13 +0800
Cc: Wang Shilong <wangsl.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Message-Id: <742DA9C3-F544-4E03-A54F-99E17073F59B@gmail.com>
References: <1375335334-32540-1-git-send-email-wangsl.fnst@cn.fujitsu.com> <1375335334-32540-9-git-send-email-wangsl.fnst@cn.fujitsu.com> <20130806134851.GJ5284@twin.jikos.cz>
To: dsterba@suse.cz
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> On Thu, Aug 01, 2013 at 01:35:33PM +0800, Wang Shilong wrote:
>> From: Qu Wenruo <quwenruo@cn.fujitsu.com>
>> 
>> The ret variant in the main function is not changed so even problems
>> happen, return value is still 0.
>> The patch fixs the minor bug and return 1 if any problems happen.
> 
> Please don't mix code fixes into documentation updates next time (unless
> you're testing my attention).
> 

I am sorry , we will take care of that.

Thanks,
Wang
> david
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

