Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f171.google.com ([209.85.192.171]:54509 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793Ab3GZEfJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 26 Jul 2013 00:35:09 -0400
Received: by mail-pd0-f171.google.com with SMTP id y14so2480450pdi.16
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Jul 2013 21:35:09 -0700 (PDT)
From: Eryu Guan <guaneryu@gmail.com>
To: zab@redhat.com
Cc: linux-btrfs@vger.kernel.org, Eryu Guan <guaneryu@gmail.com>
Subject: Re: [PATCH v2] btrfs-progs: fix segfault when listing column OTIME on big endian host
Date: Fri, 26 Jul 2013 12:34:18 +0800
Message-Id: <1374813258-25503-1-git-send-email-guaneryu@gmail.com>
In-Reply-To: <20130725212531.GJ26554@lenny.home.zabbo.net>
References: <20130725212531.GJ26554@lenny.home.zabbo.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 26, 2013 at 5:25 AM, Zach Brown <zab@redhat.com> wrote:
>> btrfs-list.c:
>>         case BTRFS_LIST_OTIME:
>>                 if (subv->otime)
>>                         strftime(tstr, 256, "%Y-%m-%d %X",
>>                                  localtime(&subv->otime));
>>                 else
>>                         strcpy(tstr, "-");
>>                 printf("%s", tstr);
>>                 break;
>> 
>> localtime() returned NULL then strftime() got SIGSEGV.
>> 
>> The reason is that ri->otime.sec is stored as little endian but
>> assigned to 't' without conversion.
>
> That's why localtime() returned null, sure, but it doesn't excuse
> strftime() being called with a null *tm!  Add some error checking around
> localtime().  It should warn that otime is nonsense, not crash.
>

Yes, return value of localtime() should be checked. There're other
places call localtime() or localtime_r() without checking the return
value, I think another patch could fix them all and leave this patch
to fix the root cause.

Thanks,
Eryu Guan
