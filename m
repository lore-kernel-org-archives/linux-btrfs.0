Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ua0-f171.google.com ([209.85.217.171]:34853 "EHLO
	mail-ua0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932115AbcHOVUb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Aug 2016 17:20:31 -0400
Received: by mail-ua0-f171.google.com with SMTP id n59so92449293uan.2
        for <linux-btrfs@vger.kernel.org>; Mon, 15 Aug 2016 14:20:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160815183051.GD20440@carfax.org.uk>
References: <d87a7caa-d414-1dbc-7c7e-a051e382114a@cn.fujitsu.com>
 <d27bad69-1041-7771-aff6-c15beb85fbb1@gmail.com> <9fb53c9f-b6c1-6bb9-8c3b-7147b64b601f@oracle.com>
 <a12a63d2-1710-611b-7d94-35db3a2aaa3d@gmail.com> <089d5900-8915-bf74-ffb3-044be11b04ae@oracle.com>
 <20160815183051.GD20440@carfax.org.uk>
From: Henk Slager <eye1tm@gmail.com>
Date: Mon, 15 Aug 2016 23:20:29 +0200
Message-ID: <CAPmG0jY3JbTTQJ4iQd=LeG0cFKEmoh7gDOkgQp2XVPY3vMOZow@mail.gmail.com>
Subject: Re: About minimal device number for RAID5/6
To: Hugo Mills <hugo@carfax.org.uk>, Anand Jain <anand.jain@oracle.com>,
        "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>,
        btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 15, 2016 at 8:30 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
> On Mon, Aug 15, 2016 at 10:32:25PM +0800, Anand Jain wrote:
>>
>>
>> On 08/15/2016 10:10 PM, Austin S. Hemmelgarn wrote:
>> >On 2016-08-15 10:08, Anand Jain wrote:
>> >>
>> >>
>> >>>>IMHO it's better to warn user about 2 devices RAID5 or 3 devices RAID6.
>> >>>>
>> >>>>Any comment is welcomed.
>> >>>>
>> >>>Based on looking at the code, we do in fact support 2/3 devices for
>> >>>raid5/6 respectively.
>> >>>
>> >>>Personally, I agree that we should warn when trying to do this, but I
>> >>>absolutely don't think we should stop it from happening.

About a year ago I had a raid5 array in an disk upgrade situation from
5x 2TB to 4x 4TB. As intermediate I had 2x 2TB + 2x 4TB situation for
several weeks. The 2x 2TB were getting really full and the fs was
slow. just wondering if an enospc would happen, I started an filewrite
task doing several 100 GB's and it simply did work to my surprise. At
some point, chunks only occupying the 4TB disks must have been
created. I also saw the expected write rate on the 4TB disks. CPU load
was not especially high as far as I remember, like a raid1 fs as far
as I remember.

So it is good that in such a situation, one can still use the fs. I
don't remember how the allocated/free space accounting was, probably
not correct, but I did not fill up the whole fs to see/experience
that.

I have no strong opinion whether we should warn about amount of
devices at mkfs time for raid56. It's just that the other known issues
with raid56 draw more attention.

>> >> How does 2 disks RAID5 work ?
>> >One disk is your data, the other is your parity.
>>
>>
>> >In essence, it works
>> >like a really computationally expensive version of RAID1 with 2 disks,
>> >which is why it's considered a degenerate configuration.
>>
>>    How do you generate parity with only one data ?
>
>    For plain parity calculations, parity is the value p which solves
> the expression:
>
> x_1 XOR x_2 XOR ... XOR x_n XOR p = 0
>
> for corresponding bits in the n data volumes. With one data volume,
> n=1, and hence p = x_1.
>
>    What's the problem? :)
>
>    Hugo.
>
>> -Anand
>>
>>
>> > Three disks in
>> >RAID6 is similar, but has a slight advantage at the moment in BTRFS
>> >because it's the only way to configure three disks so you can lose two
>> >and not lose any data as we have no support for higher order replication
>> >than 2 copies yet.
>
> --
> Hugo Mills             | I always felt that as a C programmer, I was becoming
> hugo@... carfax.org.uk | typecast.
> http://carfax.org.uk/  |
> PGP: E2AB1DE4          |
