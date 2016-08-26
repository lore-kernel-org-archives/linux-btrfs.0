Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f50.google.com ([209.85.218.50]:36206 "EHLO
        mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752988AbcHZUcb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Aug 2016 16:32:31 -0400
Received: by mail-oi0-f50.google.com with SMTP id f189so125783667oig.3
        for <linux-btrfs@vger.kernel.org>; Fri, 26 Aug 2016 13:31:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <ab0b6d021c60d76e32b69de6019adecb@durkon.lan>
References: <efe09b37f04cbc7754f6c6d84c9070f0@durkon.lan> <CAJCQCtRuQvgTj-jj=k8Ehsnq0uEkbbzJJwRR6T16H+R4d6SeTw@mail.gmail.com>
 <392b5e39596611f0ec15501dbf300c0e@durkon.lan> <CAJCQCtR=pjcCWYqpA=X5RG8RmpJ7Sk=hR-34obXyKjLw=JJcgg@mail.gmail.com>
 <ab0b6d021c60d76e32b69de6019adecb@durkon.lan>
From: Chris Murphy <lists@colorremedies.com>
Date: Fri, 26 Aug 2016 14:31:48 -0600
Message-ID: <CAJCQCtQ7krkcSisQ0MYtk7_Eb=7OQLeG+JYBjJQPUApnYNqVpA@mail.gmail.com>
Subject: Re: Switch raid mode without rebalance?
To: Gert Menke <gert@menke.ac>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 26, 2016 at 1:18 PM, Gert Menke <gert@menke.ac> wrote:
> Hi Chris,
>
> first off, thank you for the detailled explanations!
>
> On 2016-08-26 01:04, Chris Murphy wrote:
>>
>> No, it's not a file, directory or subvolume specific command. It
>> applies to a whole volume.
>
> You are right, but all I was after in the first place was a way to change
> the mode for new data on the whole volume.

New chunks, yes in a rudimentary sense (btrfs balance start then
cancel with a dconvert/mconvert), but there's no user control to
provide a hint to the allocator which chunks to put new data into. It
can go into new chunks or old chunks.

Also, I *think* if you cancel the balance, a new balance is not going
to complete the conversion - it will do the balance maintaining the
mixed profile state of existing chunks. So you'd want to do something
like -dconvert=profile,soft -mconvert=profile,soft



>> If I add another file, I'll get another data chunk allocated, and
>> it'll be added to the chunk tree as item 5, and it'll have its own
>> physical  offset on each device.
>
> And this chunk just uses the same profile as the last one (or the parent in
> the tree), I suppose.

I honestly don't know how it determines what the profile will be; it
might be the profile of the chunk with the most recent generation.



https://btrfs.wiki.kernel.org/index.php/Compression#Why_does_not_du_report_the_compressed_size.3F
> that du will not tell me the compressed size of a file. This is very
> counter-intuitive, isn't it?
> The reason stated is that some tools apparently determine the sparse-ness of
> a file by comparing the size with the stat.st_blocks value.
> I do not know if there is a better way to do that, so maybe my argument
> falls apart right here, BUT: this looks to me like working around one bug by
> introducing another. Wouldn't it be better to have a mount option
> "make_du_lie_for_buggy_tools" for those that really need it? BTW, which
> tools would an honest du break, and how? (What harm is there in thinking
> that a compressed file is sparse?)

I don't know anything about this so someone else will have to chime in.

-- 
Chris Murphy
