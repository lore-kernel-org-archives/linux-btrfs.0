Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f52.google.com ([209.85.215.52]:36551 "EHLO
	mail-lf0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932331AbcE2SQS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 29 May 2016 14:16:18 -0400
Received: by mail-lf0-f52.google.com with SMTP id b73so41633115lfb.3
        for <linux-btrfs@vger.kernel.org>; Sun, 29 May 2016 11:16:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtTpnr6OLg=0pcovK8aYUAgPLDAsYv5sam9AzWSfOBzZcA@mail.gmail.com>
References: <CAEtw4r2aknnz=+FCGq2ysSQT3K3ZHmZqnbPpyvr+C7QD6TyEAQ@mail.gmail.com>
	<CAGGqMYS_SLn9RY8Gtgf5nkwyXnOr57ehtYSH=HugiEeA8D_chw@mail.gmail.com>
	<CAEtw4r2mtxyz=_OfsgFSpGvUsYbdEqhOjOc-Dpvdd=aOwpeQ-Q@mail.gmail.com>
	<CAJCQCtTpnr6OLg=0pcovK8aYUAgPLDAsYv5sam9AzWSfOBzZcA@mail.gmail.com>
Date: Sun, 29 May 2016 20:16:16 +0200
Message-ID: <CAEtw4r0nEFwj_rFzXTbyeCRNFc7bA3N7i7=nBze_67r+wO1J3w@mail.gmail.com>
Subject: Re: Resize doesnt work as expected
From: Peter Becker <floyd.net@gmail.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Alexander Fougner <fougner89@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2016-05-29 19:11 GMT+02:00 Chris Murphy <lists@colorremedies.com>:
> On Sat, May 28, 2016 at 3:42 PM, Peter Becker <floyd.net@gmail.com> wrote:
>> Thanks for the clarification. I've probably overlooked this.
>>
>> But should "resize max" does not do what you expect instead of falling
>> back on an "invisible" 1?
>
> How does it know what the user expects?

Then simply remove the default deviceid und let the user choise what the want.
IMHO its a bad think to choise automaticly a option if its not clear
what the user wants. And in spezial there is no hint in the output of
the deviceid who is used.
The output is:

"Resize '/mnt' of 'max'" .. no hint the this only affect the deviceid
1. The suggestion for me is that the whole pool is resized to max.

Possible solutions:
1. remove the default deviceid
2. resize without deviceid affects the whole pool
3. improve the output of the resize command by adding the deviceid
4. remove the inconsitent between add+remove and replace by triggering
resize max after replace is finished.

> I think the issue is not with the resize command, but rather the
> replace command does not include the resize max operation. Presumably
> the user intends the entire block device provided as the target for
> replacement to be used.
>
> So I think the mistake is replace assumes the user wants to use the
> same amount of space as the former block device. I think if the user
> wanted to use the former block device size on the new block device,
> they'd partition it and use the partition as the target.
>
>
> --
> Chris Murphy
