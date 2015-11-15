Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:53126 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751283AbbKOB3b (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 14 Nov 2015 20:29:31 -0500
Subject: Re: bad extent [5993525264384, 5993525280768), type mismatch with
 chunk
To: Christoph Anton Mitterer <calestyo@scientia.net>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <1447365063.7045.7.camel@scientia.net> <56468CE4.2010605@gmx.com>
 <1447468167.27386.3.camel@scientia.net>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <5647DFED.5020507@gmx.com>
Date: Sun, 15 Nov 2015 09:29:17 +0800
MIME-Version: 1.0
In-Reply-To: <1447468167.27386.3.camel@scientia.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



在 2015年11月14日 10:29, Christoph Anton Mitterer 写道:
> On Sat, 2015-11-14 at 09:22 +0800, Qu Wenruo wrote:
>> Manually checked they all.
> thanks a lot :-)
>
>
>> Strangely, they are all OK... although it's a good news for you.
> Oh man... you're soooo mean ;-D
>
>
>> They are all tree blocks and are all in metadata block group.
> and I guess that's... expected/intended?

Yes, that's the expected behavior.
But dismatch with btrfsck error report.
>
>
>> It seems to be a btrfsck false alert
> that's a relieve (for me)
>
> Well I've already started to copy all files from the device to a new
> one... unfortunately I'll loose all older snapshots (at least on the
> new fs) but instead I get skinny-metadata, which wasn't the default
> back then.

Skinny metadata is quite nice feature, hugely reduce the space of 
metadata extent item size.

> (being able to copy a full fs, with all subvols/snapshots is IMHO
> really something that should be worked on)
>
>
>> If type is wrong, all the extents inside the chunk should be reported
>> as
>> mismatch type with chunk.
> Isn't that the case? At least there are so many reported extents...

If you posted all the output, that's just a little more than nothing.
Just tens of error reported, compared to millions of extents.
And in your case, if a chunk is really bad, it will report about 65K errors.

>
>> And according to the dump result, the reported ones are not
>> continuous
>> even they have adjacent extents but adjacent ones are not reported.
> I'm not so deep into btrfs... is this kinda expected and if not how
> could all this happen? Or is it really just a check issue and
> filesystem-wise fully as it should be?

I think it's a btrfsck issue, at least from the dump info, your extent 
tree is OK.
And if there is no other error reported from btrfsck, your filesystem 
should be OK.

>
>
>> Did you have any smaller btrfs with the same false alert?
> Uhm... I can check, but I don't think so, especially as all other btrfs
> I have are newer and already have skinny-metadata.
> The only ones I had without are those two big 8TB HDDs...
> Unfortunately they contain sensitive data from work, which I don't
> think I can copy, otherwise  could have sent you the device or so...
>
>> Although I'll check the code to find what's wrong, but if you have
>> any
>> small enough image, debugging will be much much faster.
> In any case, I'll keep the fs in question for a while, so that I can do
> verifications in case you have patches.

Nice.

Thanks,
Qu
>
> thanks a lot,
> Chris.
>
