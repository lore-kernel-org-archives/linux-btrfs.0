Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:20914 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756091AbbKSAmR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Nov 2015 19:42:17 -0500
Subject: Re: Kernel 3.19 and still "disk full" even though 'btrfs fi df"
 reports enough room left?
To: Hugo Mills <hugo@carfax.org.uk>, <linux-btrfs.tebulin@xoxy.net>,
        <linux-btrfs@vger.kernel.org>
References: <564CC90F.3060703@gmail.com>
 <20151118190857.GY24333@carfax.org.uk>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <564D1AE5.3000700@cn.fujitsu.com>
Date: Thu, 19 Nov 2015 08:42:13 +0800
MIME-Version: 1.0
In-Reply-To: <20151118190857.GY24333@carfax.org.uk>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Hugo Mills wrote on 2015/11/18 19:08 +0000:
> On Wed, Nov 18, 2015 at 07:53:03PM +0100, linux-btrfs.tebulin@xoxy.net wrote:
>> Hello there!
>>
>> I'm stumbling over this regularly. I explicitly upgraded the kernel to
>> avoid this, but it still occurs me every few months:
>>
>>    $ touch foo
>>    touch: »foo“ kann nicht berührt werden: Auf dem Gerät ist kein
>> Speicherplatz mehr verfügbar
>>    $ sudo btrfs fi df /
>>    Data, single: total=101.14GiB, used=78.99GiB
>>    System, DUP: total=32.00MiB, used=16.00KiB
>>    Metadata, DUP: total=9.00GiB, used=8.48GiB
>>    unknown, single: total=512.00MiB, used=832.00KiB
>>
>> Whut? Why? WTF?
>
>     Running out of metadata space, probably, although it's impossible
> to tell from only this information -- see below.

It's almost 100% sure that you already run out of metadata space.

Although the metadata output is showing that you still have about 512M 
available, but the 512M is Global Reserved space, or the unknown one.

Global reserved space should not be used, until metadata is really 
running out.
And in your case, you are already using global reserved space, see the 
832KB?

You may question that why not continue using global reserved space, but 
that's the last method, so Btrfs will just give you ENOSPC error.


The output is really a little confusing. I'd like the change the output 
by adding global reserved into metadata used space and make it a sub 
item for metadata.
This should make the output more understandable.

Thanks,
Qu

>
>>    $ uname -a
>>    Linux neptun 3.19.0-31-generic #36~14.04.1-Ubuntu SMP Thu Oct 8
>> 10:21:08 UTC 2015 x86_64 x86_64 x86_64 GNU/Linux
>>
>> dmesg is empty. Resolution is to delete a whole bunch of btrfs
>> subvolumes which are produced by apt-btrfs-snapshot. I run a
>>     sudo btrfs balance start -dusage=5 /
>> afterwards as part of my regular "i have no clue what the heck is wrong
>> with this; maybe it will help & mend my problem" process.
>>
>> This is annoying. Why is even btrfs own "disk free" utility lying to me?
>
>     I't snot lying to you -- you're just not seeing the whole
> story. You can't tell everything about disk usage from btrfs fi df.
> You need to use btrfs fi show as well to get the full information (or
> btrfs fi usage, which combines the output of both). See the FAQ[1] for
> how to interpret the output.
>
>> How to fix this? How to avoid this? How to get notified about this?
>
>     Without seeing your btrfs fi show output, I can't say for sure, but
> the usual problem in this instance is that you've got all your
> available space allocated to either data or metadata, and the FS needs
> more metadata space and can't allocate it. The solution is to free up
> some of the data allocation, using a filtered balance. See the FAQ[2]
> for how to spot the problem, and what to do about it.
>
> [1] https://btrfs.wiki.kernel.org/index.php/FAQ#Understanding_free_space.2C_using_the_original_tools
> [2] https://btrfs.wiki.kernel.org/index.php/FAQ#if_your_device_is_large_.28.3E16GiB.29
>
>     Hugo.
>
>> - Ben
>>
>> P.S.: Just as user feedback: For /srv I'm using on the very same system
>> ZFS since the very first day. With snapshots & all the fancy stuff like
>> ZRAID-1, lz4, ... My number of Issues there: 0
>>
>
