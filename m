Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f176.google.com ([209.85.223.176]:41956 "EHLO
        mail-io0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387568AbeHAOFc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Aug 2018 10:05:32 -0400
Received: by mail-io0-f176.google.com with SMTP id q9-v6so15869569ioj.8
        for <linux-btrfs@vger.kernel.org>; Wed, 01 Aug 2018 05:20:00 -0700 (PDT)
Subject: Re: BTRFS and databases
To: MegaBrutal <megabrutal@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <CAE8gLhm96B1xxoMv=sYuaNeLYRDP3YUw2qsKumpjLm+jJVjfQQ@mail.gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <750b5e99-38b1-b7d5-ba25-f228e498416f@gmail.com>
Date: Wed, 1 Aug 2018 08:19:57 -0400
MIME-Version: 1.0
In-Reply-To: <CAE8gLhm96B1xxoMv=sYuaNeLYRDP3YUw2qsKumpjLm+jJVjfQQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018-07-31 23:45, MegaBrutal wrote:
> Hi all,
> 
> I know it's a decade-old question, but I'd like to hear your thoughts
> of today. By now, I became a heavy BTRFS user. Almost everywhere I use
> BTRFS, except in situations when it is obvious there is no benefit
> (e.g. /var/log, /boot). At home, all my desktop, laptop and server
> computers are mainly running on BTRFS with only a few file systems on
> ext4. I even installed BTRFS in corporate productive systems (in those
> cases, the systems were mainly on ext4; but there were some specific
> file systems those exploited BTRFS features).
> 
> But there is still one question that I can't get over: if you store a
> database (e.g. MySQL), would you prefer having a BTRFS volume mounted
> with nodatacow, or would you just simply use ext4?
> 
> I know that with nodatacow, I take away most of the benefits of BTRFS
> (those are actually hurting database performance – the exact CoW
> nature that is elsewhere a blessing, with databases it's a drawback).
> But are there any advantages of still sticking to BTRFS for a database
> albeit CoW is disabled, or should I just return to the old and
> reliable ext4 for those applications?
You still have snapshotting, which can be useful if you for some reason 
can't just dump all the tables to SQL for backups (but seriously, that's 
_really_ what you should be doing to back up your database, it decouples 
it from whatever back-end storage you're using).  You also still have 
the guaranteed metadata consistency (nodatacow disables COW for data 
chunks only, COW still happens for metadata chunks), but you can get 
(close) to that with the newest versions of XFS too.

If you want to use BTRFS, I'd suggest playing around with the different 
on-disk storage formats offered by your RDBMS (MySQL in this case). 
Some of the offer measurably better performance on BTRFS than others, 
but it's at least partially dependent on how your software uses that 
database.
