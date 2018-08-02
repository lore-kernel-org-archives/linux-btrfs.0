Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ed1-f45.google.com ([209.85.208.45]:33720 "EHLO
        mail-ed1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726862AbeHBMgT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Aug 2018 08:36:19 -0400
Received: by mail-ed1-f45.google.com with SMTP id x5-v6so782945edr.0
        for <linux-btrfs@vger.kernel.org>; Thu, 02 Aug 2018 03:45:44 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (1.0)
Subject: Re: BTRFS and databases
From: Andrei Borzenkov <arvidjaar@gmail.com>
In-Reply-To: <1276acbf-a834-cd7e-1f06-56e13386a240@gmx.com>
Date: Thu, 2 Aug 2018 13:45:41 +0300
Cc: MegaBrutal <megabrutal@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Message-Id: <940C43FD-9710-4DAC-937E-6BE290A7A6F6@gmail.com>
References: <CAE8gLhm96B1xxoMv=sYuaNeLYRDP3YUw2qsKumpjLm+jJVjfQQ@mail.gmail.com> <1276acbf-a834-cd7e-1f06-56e13386a240@gmx.com>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Отправлено с iPhone

> 2 авг. 2018 г., в 10:02, Qu Wenruo <quwenruo.btrfs@gmx.com> написал(а):
> 
> 
> 
>> On 2018年08月01日 11:45, MegaBrutal wrote:
>> Hi all,
>> 
>> I know it's a decade-old question, but I'd like to hear your thoughts
>> of today. By now, I became a heavy BTRFS user. Almost everywhere I use
>> BTRFS, except in situations when it is obvious there is no benefit
>> (e.g. /var/log, /boot). At home, all my desktop, laptop and server
>> computers are mainly running on BTRFS with only a few file systems on
>> ext4. I even installed BTRFS in corporate productive systems (in those
>> cases, the systems were mainly on ext4; but there were some specific
>> file systems those exploited BTRFS features).
>> 
>> But there is still one question that I can't get over: if you store a
>> database (e.g. MySQL), would you prefer having a BTRFS volume mounted
>> with nodatacow, or would you just simply use ext4?
>> 
>> I know that with nodatacow, I take away most of the benefits of BTRFS
>> (those are actually hurting database performance – the exact CoW
>> nature that is elsewhere a blessing, with databases it's a drawback).
>> But are there any advantages of still sticking to BTRFS for a database
>> albeit CoW is disabled, or should I just return to the old and
>> reliable ext4 for those applications?
> 
> Since I'm not a expert in database, so I can totally be wrong, but what
> about completely disabling database write-ahead-log (WAL), and let
> btrfs' data CoW to handle data consistency completely?
> 

This would make content of database after crash completely unpredictable, thus making it impossible to reliably roll back transaction.


> If there is some concern about the commit interval, it could be tuned by
> commit= mount option.
> 
> It may either lead to super unexpected fast behavior, or some unknown
> disaster. (And for latter, we at least could get some interesting
> feedback and bugs to fix)
> 
> Thanks,
> Qu
> 
>> 
>> 
>> Kind regards,
>> MegaBrutal
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> 
> 
