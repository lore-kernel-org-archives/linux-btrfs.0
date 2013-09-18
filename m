Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.windriver.com ([147.11.1.11]:48846 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942Ab3IRBzc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Sep 2013 21:55:32 -0400
Message-ID: <52390810.6050400@windriver.com>
Date: Wed, 18 Sep 2013 09:55:28 +0800
From: Rongqing Li <rongqing.li@windriver.com>
MIME-Version: 1.0
To: Eric Sandeen <sandeen@redhat.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs-progs: Add dependencies explicitly to fix a parallel
 build issue
References: <1379466661-27973-1-git-send-email-rongqing.li@windriver.com> <52390704.3010902@redhat.com>
In-Reply-To: <52390704.3010902@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 09/18/2013 09:51 AM, Eric Sandeen wrote:
>>   	@echo "    [CC]     $@"
>> >  	$(Q)$(CC) $(DEPFLAGS) $(AM_CFLAGS) $(STATIC_CFLAGS) -c $< -o $@
>> >
> I think this can be done more cleanly, I'll send a patch.
>
> -Eric
>
>

Thanks, expect your patch


-Roy

-- 
Best Reagrds,
Roy | RongQing Li
