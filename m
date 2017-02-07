Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f65.google.com ([209.85.214.65]:32870 "EHLO
        mail-it0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932098AbdBGTuK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Feb 2017 14:50:10 -0500
Received: by mail-it0-f65.google.com with SMTP id e137so13352798itc.0
        for <linux-btrfs@vger.kernel.org>; Tue, 07 Feb 2017 11:50:10 -0800 (PST)
Subject: Re: BTRFS for OLTP Databases
To: Peter Zaitsev <pz@percona.com>, Hugo Mills <hugo@carfax.org.uk>,
        linux-btrfs@vger.kernel.org
References: <CA+RUij3aW1ZYyJPNRLzckwOCCmoWa15Eu4h142jB_-qKc49hBw@mail.gmail.com>
 <20170207140058.GA4249@carfax.org.uk>
 <CA+RUij3LJeFR1pz9QDOkMEVbh1cws5Rv2KPep3ghVAimJy7aLA@mail.gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <91c8a758-23b6-edf1-74b0-2d87acbb2560@gmail.com>
Date: Tue, 7 Feb 2017 14:50:04 -0500
MIME-Version: 1.0
In-Reply-To: <CA+RUij3LJeFR1pz9QDOkMEVbh1cws5Rv2KPep3ghVAimJy7aLA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-02-07 14:31, Peter Zaitsev wrote:
> Hi Hugo,
>
> As I re-read it closely (and also other comments in the thread) I know
> understand there is a difference how nodatacow works even if snapshot are
> in place.
>
> On autodefrag I wonder is there some more detailed documentation about how
> autodefrag works.
>
> The manual  https://btrfs.wiki.kernel.org/index.php/Mount_options    has
> very general statement.
>
> What does "detect random IO" really means  ? It also talks about
>  defragmenting the file - is i really about the whole file which is
> triggered for defrag or is defrag locally ?      Ie I would understand what
> as writes happen the  1MB block is checked and if it is more than X
> fragments it is defragmented or something like that.
I don't know the exact algorithm, but I'm pretty sure it's similar to 
what bcache uses to bypass the cache device for sequential I/O.  In 
essence, it's going to trigger for database usage.
>
> Also does autodefrag works with nodatacow (ie with snapshot)  or are these
> exclusive ?
I'm not sure about this one.  I would assume based on the fact that many 
other things don't work with nodatacow and that regular defrag doesn't 
work on files which are currently mapped as executable code that it does 
not, but I could be completely wrong about this too.
>
>
>>
>>    There's another approach which might be worth testing, which is to
>> use autodefrag. This will increase data write I/O, because where you
>> have one or more small writes in a region, it will also read and write
>> the data in a small neghbourhood around those writes, so the
>> fragmentation is reduced. This will improve subsequent read
>> performance.
>>
>>    I could also suggest getting the latest kernel you can -- 16.04 is
>> already getting on for a year old, and there may be performance
>> improvements in upstream kernels which affect your workload. There's
>> an Ubuntu kernel PPA you can use to get the new kernels without too
>> much pain.
>>
>>
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

