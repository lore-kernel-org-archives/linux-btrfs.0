Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f44.google.com ([209.85.218.44]:35137 "EHLO
	mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814AbbGHWQ4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 8 Jul 2015 18:16:56 -0400
Received: by oihr66 with SMTP id r66so120739044oih.2
        for <linux-btrfs@vger.kernel.org>; Wed, 08 Jul 2015 15:16:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <559D964C.8060502@friedels.name>
References: <000f4242.05e425492a977c7b@friedels.name> <CAC=t97AcztZ9vKvMe8o70F3VsGR-_9TdFO4t=Rdt8q=9hDYm8A@mail.gmail.com>
 <559B66C9.6060606@friedels.name> <CAC=t97Cm8nAhwfS3vYc802Xi2tmGuvzRzOfXzSkUgaF5y0zQWQ@mail.gmail.com>
 <559D7245.9030204@friedels.name> <CAC=t97CWsK1HLY9WMOQb7WxN9n2dS=FBE1PE+8bQ-Fa1VzNCQA@mail.gmail.com>
 <559D964C.8060502@friedels.name>
From: Donald Pearson <donaldwhpearson@gmail.com>
Date: Wed, 8 Jul 2015 17:16:36 -0500
Message-ID: <CAC=t97CoEZgU4+bQXtJGFrgQfUgXdk0XqUBBVd-rQ=VW7bpxAQ@mail.gmail.com>
Subject: Re: size 2.73TiB used 240.97GiB after balance
To: Hendrik Friedel <hendrik@friedels.name>
Cc: Omar Sandoval <osandov@fb.com>, Hugo Mills <hugo@carfax.org.uk>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Basically I wouldn't trust the drive that's already showing signs of
failure to survive a dd.  It isn't completely full, so the recover is
less load.  That's just the way I see it.  But I see your point of
trying to get drive images now to hedge against failures.

Unfortunately those errors are over my head so hopefully someone else
has insights.

Also the posessive "think's" at the end of those outputs made me chuckle.



On Wed, Jul 8, 2015 at 4:29 PM, Hendrik Friedel <hendrik@friedels.name> wrote:
> Hello Donald,
>
> thanks for your reply. I appreciate your help.
>
>> I would use recover to get the data if at all possible, then you can
>>
>> experiment with try to fix the degraded condition live.  If you have
>> any chance of getting data from the pool, you reduce that chance every
>> time you make a change.
>
>
> Ok, you assume that btrfs recover is the most likely way of recovering data.
> But if mounting degraded, scrubbing, btrfsck, ... are more successful, your
> proposal is more risky, isn't it? With a dd-image I can always go back to
> todays status.
>
>> If btrfs did the balance like you said, it wouldn't be raid5.  What
>> you just described is raid4 where only one drive holds parity data.  I
>> can't say that I actually know for a fact that btrfs doesn't do this,
>> but I'd be shocked and some dev would need to eat their underware if
>> the balance job didn't distribute the parity also.
>
>
> Ok, I was not aware of the difference between raid4&5.
>
> So, I did try a btrs-recover:
> warning devid 3 not found already
> Check tree block failed, want=8300102483968, have=65536
> Check tree block failed, want=8300102483968, have=65536
> Check tree block failed, want=8300102483968, have=65536
> read block failed check_tree_block
> Couldn't setup extent tree
> [it is still running]
>
> btrfs-find-root gives me:
> http://paste.ubuntu.com/11844005/
> http://paste.ubuntu.com/11844009/
> (on the two disks)
>
>
> btrfs-show-super:
> http://paste.ubuntu.com/11844016/
>
> Greetings,
> Hendrik
>
>
>
>
>
> ---
> Diese E-Mail wurde von Avast Antivirus-Software auf Viren geprüft.
> https://www.avast.com/antivirus
>
