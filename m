Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp.domeneshop.no ([194.63.252.55]:50468 "EHLO
        smtp.domeneshop.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1761083AbdKRKln (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 18 Nov 2017 05:41:43 -0500
Reply-To: waxhead@dirtcellar.net
Subject: Re: 4.14 balance: kernel BUG at
 /home/kernel/COD/linux/fs/btrfs/ctree.c:1856!
To: Roman Mamedov <rm@romanrm.net>,
        Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Cc: Tomasz Chmielewski <mangoo@wpkg.org>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <e01cb2f95b44b7648855a4fe5070fd10@wpkg.org>
 <5000f429-8b4b-b4ea-5e38-89f7c91af6f3@mendix.com>
 <20171118144037.0fa8ad4b@natsu>
From: waxhead <waxhead@dirtcellar.net>
Message-ID: <3686dc7b-e860-8cd5-93e3-9e5bf383afe5@dirtcellar.net>
Date: Sat, 18 Nov 2017 11:41:40 +0100
MIME-Version: 1.0
In-Reply-To: <20171118144037.0fa8ad4b@natsu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Roman Mamedov wrote:
> On Sat, 18 Nov 2017 02:08:46 +0100
> Hans van Kranenburg <hans.van.kranenburg@mendix.com> wrote:
>
>> It's using send + balance at the same time. There's something that makes
>> btrfs explode when you do that.
>>
>> It's not new in 4.14, I have seen it in 4.7 and 4.9 also, various
>> different explosions in kernel log. Since that happened, I made sure I
>> never did those two things at the same time.
>
> Shouldn't it prevent send during balance, or balance during send then, if
> that's the case?
>
> You talk about it "exploding" like it's a normal thing, to have Invalid opcode
> BUGs in kernel log, and the user has to take care to not use two of the
> regular FS features at the same time.
>
> Seems to be a bug which should be fixed, rather than warning everyone "not to
> send during balance".
>
Agree, either that or someone needs to update the status page to show 
that either send or balance is 'unstable'
