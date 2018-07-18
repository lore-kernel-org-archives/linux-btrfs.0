Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:33295 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730053AbeGRNXb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 18 Jul 2018 09:23:31 -0400
Received: by mail-io0-f196.google.com with SMTP id z20-v6so3972070iol.0
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Jul 2018 05:45:44 -0700 (PDT)
Received: from [191.9.206.254] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by smtp.gmail.com with ESMTPSA id f18-v6sm1716545itc.44.2018.07.18.05.45.42
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Jul 2018 05:45:42 -0700 (PDT)
Subject: Re: [PATCH 0/4] 3- and 4- copy RAID1
To: linux-btrfs@vger.kernel.org
References: <cover.1531503452.git.dsterba@suse.com>
 <9945d460-99b5-a927-a614-c797bbc7862d@dirtcellar.net>
 <d340ce28-6c93-22d4-0f56-73de8e55f1f6@libero.it>
 <pan$b5258$f3ecc84$8e06948b$54511335@cox.net>
 <793d8ec3-7934-ea60-521d-7a039c9f1ce9@libero.it>
 <pan$98af2$39851f53$ef9fd141$bfd51f5b@cox.net>
 <pan$47c54$5df59e3d$ab971dce$aa203b1@cox.net>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <3288c191-c2d9-edd2-74a3-f86ba07ba9ee@gmail.com>
Date: Wed, 18 Jul 2018 08:45:41 -0400
MIME-Version: 1.0
In-Reply-To: <pan$47c54$5df59e3d$ab971dce$aa203b1@cox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018-07-18 04:39, Duncan wrote:
> Duncan posted on Wed, 18 Jul 2018 07:20:09 +0000 as excerpted:
> 
>>> As implemented in BTRFS, raid1 doesn't have striping.
>>
>> The argument is that because there's only two copies, on multi-device
>> btrfs raid1 with 4+ devices of equal size so chunk allocations tend to
>> alternate device pairs, it's effectively striped at the macro level,
>> with the 1 GiB device-level chunks effectively being huge individual
>> device strips of 1 GiB.
>>
>> At 1 GiB strip size it doesn't have the typical performance advantage of
>> striping, but conceptually, it's equivalent to raid10 with huge 1 GiB
>> strips/chunks.
> 
> I forgot this bit...
> 
> Similarly, multi-device single is regarded by some to be conceptually
> equivalent to raid0 with really huge GiB strips/chunks.
> 
> (As you may note, "the argument is" and "regarded by some" are distancing
> phrases.  I've seen the argument made on-list, but while I understand the
> argument and agree with it to some extent, I'm still a bit uncomfortable
> with it and don't normally make it myself, this thread being a noted
> exception tho originally I simply repeated what someone else already said
> in-thread, because I too agree it's stretching things a bit.  But it does
> appear to be a useful conceptual equivalency for some, and I do see the
> similarity.
If the file is larger than the data chunk size, it _is_ striped, because 
it spans multiple chunks which are on separate devices.  Otherwise, it's 
more similar to what in GlusterFS is called a 'distributed volume'.  In 
such a Gluster volume, each file is entirely stored on one node (or you 
have a complete copy on N nodes where N is the number of replicas), with 
the selection of what node is used for the next file created being based 
on which node has the most free space.

That said, the main reason I explain single and raid1 the way I do is 
that I've found it's a much simpler way to explain generically how they 
work to people who already have storage background but may not care 
about the specifics.
> 
> Perhaps it's a case of coder's view (no code doing it that way, it's just
> a coincidental oddity conditional on equal sizes), vs. sysadmin's view
> (code or not, accidental or not, it's a reasonably accurate high-level
> description of how it ends up working most of the time with equivalent
> sized devices).)
> 
