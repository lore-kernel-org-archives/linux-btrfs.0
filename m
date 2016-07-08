Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f177.google.com ([209.85.223.177]:36162 "EHLO
	mail-io0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754150AbcGHJ6v (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Jul 2016 05:58:51 -0400
Received: by mail-io0-f177.google.com with SMTP id l202so39735373ioe.3
        for <linux-btrfs@vger.kernel.org>; Fri, 08 Jul 2016 02:58:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <ab5cc111-7ed7-3209-7411-6c656892d4a3@fb.com>
References: <CAEJqkghMZDOJoyRkf_-HTfuKLnj0eaAGmtjVAPY2UftV7TxbvA@mail.gmail.com>
 <ab5cc111-7ed7-3209-7411-6c656892d4a3@fb.com>
From: Gabriel C <nix.or.die@gmail.com>
Date: Fri, 8 Jul 2016 11:57:50 +0200
Message-ID: <CAEJqkgiWOnyk8AzROc-tGTqKiDJkCt364tgFT5P-2Sa+XwjeMA@mail.gmail.com>
Subject: Re: A lot warnings in dmesg while running thunderbird
To: Chris Mason <clm@fb.com>
Cc: linux-btrfs@vger.kernel.org, quwenruo@cn.fujitsu.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2016-07-07 21:21 GMT+02:00 Chris Mason <clm@fb.com>:
>
>
> On 07/07/2016 06:24 AM, Gabriel C wrote:
>>
>> Hi,
>>
>> while running thunderbird on linux 4.6.3 and 4.7.0-rc6 ( didn't tested
>> other versions )
>> I trigger the following :
>
>
> I definitely thought we had this fixed in v4.7-rc.  Can you easily fsck this filesystem?  Something strange is going on.

Yes , btrfs check and btrfs check  --check-data-csum are fine , no errors found.

If you want me to test any patches let me know.


Regards,

Gabriel C
