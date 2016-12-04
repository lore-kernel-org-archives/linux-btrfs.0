Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f173.google.com ([209.85.161.173]:35014 "EHLO
        mail-yw0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751070AbcLDXqq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 4 Dec 2016 18:46:46 -0500
Received: by mail-yw0-f173.google.com with SMTP id i145so246194817ywg.2
        for <linux-btrfs@vger.kernel.org>; Sun, 04 Dec 2016 15:46:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAPmG0jbMMBvY4pFm4D0AYi=QqGsiskVq4aE=bX3JtK_fUkcvFw@mail.gmail.com>
References: <CAJCQCtQcz6W-UD5eDAiWG1QJk3tSF7boN2haG_Du=PD_U6rx1g@mail.gmail.com>
 <CAPmG0jbMMBvY4pFm4D0AYi=QqGsiskVq4aE=bX3JtK_fUkcvFw@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Sun, 4 Dec 2016 16:39:20 -0700
Message-ID: <CAJCQCtSoiOFcSZq1E_m6JPWeZ6=q252nK_ZYOB4ZfdNsD2MTog@mail.gmail.com>
Subject: Re: btrfs fi du is unreliable
To: Henk Slager <eye1tm@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Dec 4, 2016 at 3:17 PM, Henk Slager <eye1tm@gmail.com> wrote:
> On Sun, Dec 4, 2016 at 7:30 PM, Chris Murphy <lists@colorremedies.com> wrote:
>> Hi,
>>
>> [chris@f25s ~]$ uname -r
>> 4.8.11-300.fc25.x86_64
>> [chris@f25s ~]$ rpm -q btrfs-progs
>> btrfs-progs-4.8.5-1.fc26.x86_64
>>
>>
>> I'm not finding any pattern to this so far, but it's definitely not
>> always reliable. Here is today's example.
>>
>> [chris@f25s ~]$ sudo btrfs fi du -s /mnt/second/jackson.2015/
>>      Total   Exclusive  Set shared  Filename
>>  111.67GiB   111.67GiB       0.00B  /mnt/second/jackson.2015/
>>
>> Super. This is correct. The jackson.2015 subvolume contains only
>> exclusively used data, there are no snapshots, and there are no
>> reflinks involved for any files.
>>
>>
>> [chris@f25s ~]$ sudo btrfs send  /mnt/second/jackson.2015/ | sudo
>> btrfs receive /mnt/int/
>>
>> Send the subvolume to a different btrfs volume. This is not an
>> incremental send. After completion however:
>>
>>
>> [chris@f25s ~]$ sudo btrfs fi du -s /mnt/int/jackson.2015/
>>      Total   Exclusive  Set shared  Filename
>>  111.67GiB    37.20GiB    29.93GiB  /mnt/int/jackson.2015/
>>
>> That makes zero sense. What's going on here?
>
> I tried to reproduce, with progs from git v4.8.5 and kernel
> 4.8.10-1-default (tumbleweed):
>
> # /net/src/btrfs-progs/btrfs send testfidu |
> /net/src/btrfs-progs/btrfs receive /local/omedia/
>
> # /net/src/btrfs-progs/btrfs fi du -s ./testfidu/
>      Total   Exclusive  Set shared  Filename
>   42.56GiB    42.56GiB       0.00B  ./testfidu/
>
> # /net/src/btrfs-progs/btrfs fi du -s /local/omedia/testfidu/
>      Total   Exclusive  Set shared  Filename
>   42.56GiB    42.56GiB       0.00B  /local/omedia/testfidu/
>
> There are no btrfs changes between kernels 4.8.10 and 4.8.11. There is
> no compress mount option in my case, that is the only thing I
> currently can think of that could make your Set shared number
> non-zero.

No compression on either end; default mount options for both volumes.


-- 
Chris Murphy
