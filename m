Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f182.google.com ([209.85.220.182]:34828 "EHLO
        mail-qk0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757841AbcH3Q5v (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 30 Aug 2016 12:57:51 -0400
Received: by mail-qk0-f182.google.com with SMTP id v123so24826821qkh.2
        for <linux-btrfs@vger.kernel.org>; Tue, 30 Aug 2016 09:57:50 -0700 (PDT)
Message-ID: <1472576261.3179.16.camel@gmail.com>
Subject: Re: BTRFS constantly reports "No space left on device" even with a
 huge unallocated space
From: Ronan Arraes Jardim Chagas <ronisbr@gmail.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Date: Tue, 30 Aug 2016 13:57:41 -0300
In-Reply-To: <CAJCQCtTn6y1Qy5J_Wuef-bbwJ9g50NgM-a2UtWvh=01S_JntKA@mail.gmail.com>
References: <1471023419.16857.9.camel@gmail.com>
         <57C426AB.3020607@cn.fujitsu.com> <1472485953.3290.0.camel@gmail.com>
         <57C4EB85.7030000@cn.fujitsu.com> <1472561404.3179.3.camel@gmail.com>
         <CAJCQCtTn6y1Qy5J_Wuef-bbwJ9g50NgM-a2UtWvh=01S_JntKA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Em Ter, 2016-08-30 às 10:44 -0600, Chris Murphy escreveu:
> It sounds related to read-only snapshots to me. I wonder if this
> system has something busy that's writing to a file, database, even
> maybe something just spamming journald, and then there's a read-only
> snapshot during the write, which then triggers the enospc.
> 

I saw the problem yesterday after lunch time (13:00) and the last
snapper snapshot was taken at 10:17:

snapper list
Tipo   | #  | Pre # | Data                         | Usuário | Limpeza
| Descrição           | Dados de usuário
-------+----+-------+------------------------------+----------+------
---+-----------------------+------------------
single | 0  |       |                              |
root     |         | current               |                  
single | 1  |       | Ter 16 Ago 2016 15:07:25 BRT |
root     |         | first root filesystem |                  
single | 2  |       | Ter 16 Ago 2016 15:15:57 BRT | root     |
number  | after installation    | important=yes    
pre    | 4  |       | Ter 16 Ago 2016 15:26:44 BRT | root     |
number  | zypp(y2base)          | important=yes    
post   | 5  | 4     | Ter 16 Ago 2016 16:12:46 BRT | root     |
number  |                       | important=yes    
pre    | 29 |       | Ter 16 Ago 2016 18:02:43 BRT | root     |
number  | zypp(zypper)          | important=yes    
post   | 30 | 29    | Ter 16 Ago 2016 18:07:34 BRT | root     |
number  |                       | important=yes    
pre    | 45 |       | Seg 22 Ago 2016 13:59:45 BRT | root     |
number  | zypp(zypper)          | important=yes    
post   | 46 | 45    | Seg 22 Ago 2016 14:11:17 BRT | root     |
number  |                       | important=yes    
pre    | 89 |       | Seg 29 Ago 2016 09:56:19 BRT | root     |
number  | yast sw_single        |                  
pre    | 90 |       | Seg 29 Ago 2016 10:00:00 BRT | root     |
number  | zypp(y2base)          | important=no     
post   | 91 | 90    | Seg 29 Ago 2016 10:01:11 BRT | root     |
number  |                       | important=no     
pre    | 92 |       | Seg 29 Ago 2016 10:07:01 BRT | root     |
number  | zypp(y2base)          | important=no     
post   | 93 | 92    | Seg 29 Ago 2016 10:07:10 BRT | root     |
number  |                       | important=no     
pre    | 94 |       | Seg 29 Ago 2016 10:12:32 BRT | root     |
number  | zypp(y2base)          | important=no     
post   | 95 | 94    | Seg 29 Ago 2016 10:14:25 BRT | root     |
number  |                       | important=no     
post   | 96 | 89    | Seg 29 Ago 2016 10:17:17 BRT | root     |
number  |                       |                 

> Ronan, if you're given a work around, then it's even less likely the
> bug gets fixed. But if you can disable snapper snapshots entirely and
> the problem doesn't happen; or if you can increase the frequency of
> snapper snapshots and the problem happens more often, that might help
> narrow it down to a point where it's more easily reproduced. If it's
> not related, that's still useful to know.

I agree with you. The problem is that since this is a production
machine, it is kind very problematic to have so many reboots that
occurs randomly.

I will install something using zypper, which will trigger snapper, and
see if the problem will be triggered. I will be out of the office this
afternoon, so the machine will be on idle.

Best regards,
Ronan Arraes
