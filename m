Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f176.google.com ([209.85.220.176]:35245 "EHLO
	mail-qk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754251AbcCULYI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Mar 2016 07:24:08 -0400
Received: by mail-qk0-f176.google.com with SMTP id o6so77740099qkc.2
        for <linux-btrfs@vger.kernel.org>; Mon, 21 Mar 2016 04:24:07 -0700 (PDT)
Received: from [127.0.0.1] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by smtp.gmail.com with ESMTPSA id w1sm11968142qha.3.2016.03.21.04.24.05
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1/SSLv3 cipher=OTHER);
        Mon, 21 Mar 2016 04:24:05 -0700 (PDT)
Subject: Re: overlay file to test btrfs repairs
To: linux-btrfs@vger.kernel.org
References: <CAJCQCtRbOa14an+UooFJYBK5JNQppYfXKHqpOfKVXHBYPAQ_Kg@mail.gmail.com>
 <pan$2fe7d$1410eb30$c926ea8c$aa8d1cf9@cox.net>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <56EFD981.7020606@gmail.com>
Date: Mon, 21 Mar 2016 07:22:41 -0400
MIME-Version: 1.0
In-Reply-To: <pan$2fe7d$1410eb30$c926ea8c$aa8d1cf9@cox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-03-21 05:55, Duncan wrote:
> Chris Murphy posted on Sun, 20 Mar 2016 21:43:52 -0600 as excerpted:
>
>> Hi folks,
>>
>> So I just ran into this:
>> https://raid.wiki.kernel.org/index.php/
> Recovering_a_failed_software_RAID#Making_the_harddisks_read-
> only_using_an_overlay_file
>
> [That's a single link, wrapped by my client.]
>
>> This is a device mapper overlay file - not overlayfs.
>>
>> For the repairs that are sometimes uncertain what's next, maybe this is
>> a viable option to avoid changing the file system? I'm thinking
>> chunk-recover might take up too much space, I'm not sure how that one
>> works, if chunks are just being read or if they have to be rewritten or
>> if it's just the chunk tree? But for 'btrfs check' and 'btrfs rescue
>> super-recover/zero-log' there should be very little being written so the
>> overlay idea might be a good step?
>>
>> Opinions?
>
> That's a creative and potentially quite useful possible solution to an
> often hairy problem.  Thanks for bringing it up. =:^)
>
> Provided Hugo and the devs don't find major fault with the idea, linking
> that from appropriate locations (as a possible solution in the Problem
> FAQ is the first one that occurs to me) in the btrfs wiki could be quite
> useful, to many.
>
If we could find some way to have the programs themselves do this if the 
system supports it (and the user opts in of course), it would be really 
helpful.  That said, I can see this possibly causing issues due to 
duplicate device UUID's.
