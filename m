Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f177.google.com ([209.85.213.177]:35202 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757251AbcCURNp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Mar 2016 13:13:45 -0400
Received: by mail-ig0-f177.google.com with SMTP id cl4so37242757igb.0
        for <linux-btrfs@vger.kernel.org>; Mon, 21 Mar 2016 10:13:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <56EFD981.7020606@gmail.com>
References: <CAJCQCtRbOa14an+UooFJYBK5JNQppYfXKHqpOfKVXHBYPAQ_Kg@mail.gmail.com>
	<pan$2fe7d$1410eb30$c926ea8c$aa8d1cf9@cox.net>
	<56EFD981.7020606@gmail.com>
Date: Mon, 21 Mar 2016 11:13:44 -0600
Message-ID: <CAJCQCtTsMYmvqVNX_Nfy2aSdfLtV2gUUESp82gk=W0ifQc0r0Q@mail.gmail.com>
Subject: Re: overlay file to test btrfs repairs
From: Chris Murphy <lists@colorremedies.com>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 21, 2016 at 5:22 AM, Austin S. Hemmelgarn
<ahferroin7@gmail.com> wrote:
> On 2016-03-21 05:55, Duncan wrote:
>>
>> Chris Murphy posted on Sun, 20 Mar 2016 21:43:52 -0600 as excerpted:
>>
>>> Hi folks,
>>>
>>> So I just ran into this:
>>> https://raid.wiki.kernel.org/index.php/
>>
>> Recovering_a_failed_software_RAID#Making_the_harddisks_read-
>> only_using_an_overlay_file
>>
>> [That's a single link, wrapped by my client.]
>>
>>> This is a device mapper overlay file - not overlayfs.
>>>
>>> For the repairs that are sometimes uncertain what's next, maybe this is
>>> a viable option to avoid changing the file system? I'm thinking
>>> chunk-recover might take up too much space, I'm not sure how that one
>>> works, if chunks are just being read or if they have to be rewritten or
>>> if it's just the chunk tree? But for 'btrfs check' and 'btrfs rescue
>>> super-recover/zero-log' there should be very little being written so the
>>> overlay idea might be a good step?
>>>
>>> Opinions?
>>
>>
>> That's a creative and potentially quite useful possible solution to an
>> often hairy problem.  Thanks for bringing it up. =:^)
>>
>> Provided Hugo and the devs don't find major fault with the idea, linking
>> that from appropriate locations (as a possible solution in the Problem
>> FAQ is the first one that occurs to me) in the btrfs wiki could be quite
>> useful, to many.
>>
> If we could find some way to have the programs themselves do this if the
> system supports it (and the user opts in of course), it would be really
> helpful.  That said, I can see this possibly causing issues due to duplicate
> device UUID's.

I thought of this. Btrfs seed device. The problem is it has some
minimal requirements (that I don't understand) for file system
integrity, probably starting out with the superblocks all being in a
good state. So literal leveraging of seed device is not possible, and
it's also non-obvious. Any repairs should be fail safe or they're
arguably broken. But if there were a way to effectively setup a seed +
ram or file based device behind the scene so that repairs can be
tested, that might be useful. And it would be mountable, even rw, and
that too would be reversible.


-- 
Chris Murphy
