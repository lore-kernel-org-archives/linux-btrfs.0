Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lj1-f172.google.com ([209.85.208.172]:40710 "EHLO
        mail-lj1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725832AbeH1E2l (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 28 Aug 2018 00:28:41 -0400
Received: by mail-lj1-f172.google.com with SMTP id j19-v6so647802ljc.7
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Aug 2018 17:39:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQ=CiB5cY8RL4tzps21d=umjzNM=BKjdUBCc7WiP0QF9A@mail.gmail.com>
References: <CAN4oSBdfDVGmG8L2vS9h9McEs5aSuP5RfTGREB2ZhGwmAg4JhA@mail.gmail.com>
 <CAJCQCtSq5K90gpfGQN8JhqQddBg62m8EG_bFuWN5XyzdNStDfw@mail.gmail.com>
 <CAN4oSBeHwnsm5Ecz1hAQLk6s6utHfn5XeR8xMhnZpmT-sb-_iw@mail.gmail.com> <CAJCQCtQ=CiB5cY8RL4tzps21d=umjzNM=BKjdUBCc7WiP0QF9A@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 27 Aug 2018 18:39:38 -0600
Message-ID: <CAJCQCtSGV1gz66X9BJAJosuhMTvd2=Me-X2tVDwJ0Eg9PA7BPA@mail.gmail.com>
Subject: Re: DRDY errors are not consistent with scrub results
To: Chris Murphy <lists@colorremedies.com>
Cc: Cerem Cem ASLAN <ceremcem@ceremcem.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 27, 2018 at 6:38 PM, Chris Murphy <lists@colorremedies.com> wrote:

>> Metadata,single: Size:8.00MiB, Used:0.00B
>>    /dev/mapper/master-root         8.00MiB
>>
>> Metadata,DUP: Size:2.00GiB, Used:562.08MiB
>>    /dev/mapper/master-root         4.00GiB
>>
>> System,single: Size:4.00MiB, Used:0.00B
>>    /dev/mapper/master-root         4.00MiB
>>
>> System,DUP: Size:32.00MiB, Used:16.00KiB
>>    /dev/mapper/master-root        64.00MiB
>>
>> Unallocated:
>>    /dev/mapper/master-root       915.24GiB
>
>
> OK this looks like it maybe was created a while ago, it has these
> empty single chunk items that was common a while back. There is a low
> risk to clean it up, but I still advise backup first:
>
> 'btrfs balance start -mconvert=dup <mountpoint>'

You can skip this advise now, it really doesn't matter. But future
Btrfs shouldn't have both single and DUP chunks like this one is
showing, if you're using relatively recent btrfs-progs to create the
file system.


-- 
Chris Murphy
