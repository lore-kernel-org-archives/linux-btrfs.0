Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:54796 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751283AbbHCAyR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 2 Aug 2015 20:54:17 -0400
Subject: Re: btrfs partition converted from ext4 becomes read-only minutes
 after booting: WARNING: CPU: 2 PID: 2777 at ../fs/btrfs/super.c:260
 __btrfs_abort_transaction+0x4b/0x120
To: Robert Munteanu <robert.munteanu@gmail.com>
References: <CAC8ULPYHuqsZN1Lm_2TxGMw7z6n=4zAprqYr9uoi=3kjoiSxQw@mail.gmail.com>
 <558CB0D4.8060401@cn.fujitsu.com> <558CB404.8050300@cn.fujitsu.com>
 <CAJCQCtTMdQG4EB8dNAYPq8H3V68TCb2YQztoXXYMkCYA3GBCXw@mail.gmail.com>
 <CAO5K3OcA1_Z4-jvv_2C0StBkOr++_vUX4kOspY8cuhnX2t3z_A@mail.gmail.com>
 <CAJCQCtQ35xzMBjcUUTzWm3CjC1r=UNgkog2YbB0X1QcZofNj0g@mail.gmail.com>
 <559F131B.30206@cn.fujitsu.com>
 <CAC8ULPaOWS=WS-_oSkihrzi7bnWXuevyqL3R7FPFFQQCdjqdvA@mail.gmail.com>
 <CAC8ULPaYmQNj_cvgGxqKtJ4w237J5vAJFTQMO1=o+y+eUYrPLg@mail.gmail.com>
 <55BAD89A.8030203@cn.fujitsu.com>
 <CAC8ULPbe+E6JzGS-BYvjoLTN+Y9j6PYGC4U3f5cYhgz=eaaUOg@mail.gmail.com>
CC: Chris Murphy <lists@colorremedies.com>, Vytautas D <vytdau@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <55BEBBB4.4040801@cn.fujitsu.com>
Date: Mon, 3 Aug 2015 08:54:12 +0800
MIME-Version: 1.0
In-Reply-To: <CAC8ULPbe+E6JzGS-BYvjoLTN+Y9j6PYGC4U3f5cYhgz=eaaUOg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks for the log.

I'll investigate it to see whether we can resolve the infinite loop problem.

Thanks,
Qu

Robert Munteanu wrote on 2015/07/31 16:38 +0300:
> On Fri, Jul 31, 2015 at 5:08 AM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>> Any full output about it?
>
> Please see the attached log. I left the process running for about 4
> hours, and after the first five minutes all it cared about was a
> single inode. I ended up stopping it as it looks like it's not making
> progress.
>
>> Not sure if it real loops, but maybe the inode number changed in later
>> output?
>
> Looks to me like it's the same inode
>
>    $ awk '/ for inode/ { print $7  } ' screenlog.0  | sort | uniq
>    14214570
>
> Thanks,
>
> Robert
>
>
>
>
>
>
>
