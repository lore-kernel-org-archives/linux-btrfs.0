Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.131]:57538 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753732AbcHZTTB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Aug 2016 15:19:01 -0400
Received: from durkon.lan ([37.201.97.218]) by mrelayeu.kundenserver.de
 (mreue004) with ESMTPSA (Nemesis) id 0M3fC1-1ammAK0HlR-00rKoe for
 <linux-btrfs@vger.kernel.org>; Fri, 26 Aug 2016 21:18:57 +0200
Received: from haley.lan (haley.lan [192.168.2.21])
        by durkon.lan (Postfix) with ESMTPSA id D70D71741
        for <linux-btrfs@vger.kernel.org>; Fri, 26 Aug 2016 21:18:55 +0200 (CEST)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Fri, 26 Aug 2016 21:18:55 +0200
From: Gert Menke <gert@menke.ac>
To: linux-btrfs@vger.kernel.org
Subject: Re: Switch raid mode without rebalance?
In-Reply-To: <CAJCQCtR=pjcCWYqpA=X5RG8RmpJ7Sk=hR-34obXyKjLw=JJcgg@mail.gmail.com>
References: <efe09b37f04cbc7754f6c6d84c9070f0@durkon.lan>
 <CAJCQCtRuQvgTj-jj=k8Ehsnq0uEkbbzJJwRR6T16H+R4d6SeTw@mail.gmail.com>
 <392b5e39596611f0ec15501dbf300c0e@durkon.lan>
 <CAJCQCtR=pjcCWYqpA=X5RG8RmpJ7Sk=hR-34obXyKjLw=JJcgg@mail.gmail.com>
Message-ID: <ab0b6d021c60d76e32b69de6019adecb@durkon.lan>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,

first off, thank you for the detailled explanations!

On 2016-08-26 01:04, Chris Murphy wrote:
> No, it's not a file, directory or subvolume specific command. It
> applies to a whole volume.
You are right, but all I was after in the first place was a way to 
change the mode for new data on the whole volume.
But I understand now that there is no simple switch for that. (And to be 
honest it's not overly important, I was just being curious.)

> If I add another file, I'll get another data chunk allocated, and
> it'll be added to the chunk tree as item 5, and it'll have its own
> physical  offset on each device.
And this chunk just uses the same profile as the last one (or the parent 
in the tree), I suppose.

> So the point now is, in order to change the profile of a chunk, it has
> to be completely rewritten.
That makes sense.

> To do what you want is planned, with no work picked up yet as far as I
> know. It'd probably involve some work to associate something like an
> xattr to let the allocator know which profile the user wants for the
> data, and then to allocate it to the proper existing chunk or create a
> new chunk with that profile as needed.
I see.

I think it would be very nice to have something like that for the 
different compression modes. For example, use LZ4 for daily use but LZMA 
for the subvolume that stores backups, and no compression at all for 
/boot, so the bootloader doesn't have to know about all the different 
compression algorithms.

Speaking of which, I read here: 
https://btrfs.wiki.kernel.org/index.php/Compression#Why_does_not_du_report_the_compressed_size.3F
that du will not tell me the compressed size of a file. This is very 
counter-intuitive, isn't it?
The reason stated is that some tools apparently determine the 
sparse-ness of a file by comparing the size with the stat.st_blocks 
value.
I do not know if there is a better way to do that, so maybe my argument 
falls apart right here, BUT: this looks to me like working around one 
bug by introducing another. Wouldn't it be better to have a mount option 
"make_du_lie_for_buggy_tools" for those that really need it? BTW, which 
tools would an honest du break, and how? (What harm is there in thinking 
that a compressed file is sparse?)

Thanks!
Gert
