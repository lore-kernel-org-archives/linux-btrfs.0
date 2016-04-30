Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f42.google.com ([209.85.215.42]:34433 "EHLO
	mail-lf0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070AbcD3KzI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 30 Apr 2016 06:55:08 -0400
Received: by mail-lf0-f42.google.com with SMTP id j11so163310983lfb.1
        for <linux-btrfs@vger.kernel.org>; Sat, 30 Apr 2016 03:55:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <pan$e4ba4$a250943d$4b67b01a$4a6c9e1c@cox.net>
References: <CAGGqMYQPVQoKDcuDqp0D=3BCD+oTghew0fyzqo58BSLFrmrEJQ@mail.gmail.com>
	<CAJCQCtTG68BicgFwoyYgM0OzphsVbstgWTNybF3CeBo1VCJhNg@mail.gmail.com>
	<CAGGqMYTso0XNjgfmWfY8g3Xs9xym5gHFcTizzAq1_Y-mMTTx0w@mail.gmail.com>
	<CAJCQCtRk+V0vhdCsyi-3aoNDimV0E4XJjQc9Us35uO59HpjSAQ@mail.gmail.com>
	<CAGGqMYSZ8P=ZVSgL4zWJKi7uuYLxRMZh=XEzPYpT2PykQD58oQ@mail.gmail.com>
	<pan$e4ba4$a250943d$4b67b01a$4a6c9e1c@cox.net>
Date: Sat, 30 Apr 2016 12:55:06 +0200
Message-ID: <CAGGqMYQH7h4-atS+ecBzngBMLu7iRe4-CehjavUAcJMje+v=wA@mail.gmail.com>
Subject: Re: receive snapshot, complains about missing file
From: Alexander Fougner <fougner89@gmail.com>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2016-04-30 12:49 GMT+02:00 Duncan <1i5t5.duncan@cox.net>:
> Alexander Fougner posted on Sat, 30 Apr 2016 12:28:34 +0200 as excerpted:
>
>>>>> Do scrub and btrfs check (no repair) complete without errors?
>>
>> Send side
>>
>> sudo btrfs check /dev/sda1
>> Checking filesystem on /dev/sda1
>
> [... but no errors]
>
>> Receive side only outputs this:
>> sudo btrfs check -p /dev/sdc
>> Couldn't open file system
>
> It wasn't mounted at the time, right?

Nope

>
> Cuz btrfs check won't work with a mounted filesystem.
>
> Of course you'll need to be root to access the device as well,
> but that's pretty much a given.

I think sudo should do that, right?

>
>
>> Scrub completes without errors on both FS.
>
> That's good. =:^)
>
> --
> Duncan - List replies preferred.   No HTML msgs.
> "Every nonfree program has a lord, a master --
> and if you use the program, he is your master."  Richard Stallman
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
