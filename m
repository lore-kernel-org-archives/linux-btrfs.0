Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f172.google.com ([209.85.223.172]:34018 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752560Ab3B1OSk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Feb 2013 09:18:40 -0500
Received: by mail-ie0-f172.google.com with SMTP id c10so2120777ieb.3
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Feb 2013 06:18:40 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <512E2D36.4040307@redhat.com>
References: <1361449575-1835-1-git-send-email-wangshilong1991@gmail.com>
	<20130227155255.GI27541@twin.jikos.cz>
	<512E2D36.4040307@redhat.com>
Date: Thu, 28 Feb 2013 22:18:39 +0800
Message-ID: <CAP9B-Q=rFcby1q8bK7wKtXYxx6oCGfD5v_iRnzwiRGkWxOgNzg@mail.gmail.com>
Subject: Re: [PATCH] Btrfs-progs: fix parse_limit function to return errors
 when parsing unit
From: Shilong Wang <wangshilong1991@gmail.com>
To: Eric Sandeen <sandeen@redhat.com>, David Sterba <dsterba@suse.cz>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello, Eric, David

2013/2/27 Eric Sandeen <sandeen@redhat.com>:
> On 2/27/13 9:52 AM, David Sterba wrote:
>> On Thu, Feb 21, 2013 at 08:26:15PM +0800, Wang Shilong wrote:
>>> From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
>>>
>>> Steps to reproduce:
>>>      btrfs qgroup limit m <mnt>/subv
>>>
>>> Here, unit(k/K/g/G/m/M/t/T) all will trigger the problem.
>>> For the above command, the original code will parse the limit value as 0
>>> and return successfully.It is wrong,fix it.
>>
>> I don't think we should allow to accept bare units for specifing
>> numbers, so in that case fail with 'unrecognized limit'.
>
> I agree with that.
>
> Maybe since David didn't quite want to take my patch 01/17, and Zach
> thought we needed better code for it all, and Goffredo didn't like
> the exit() from parse_size, and now this problem, we need a single,
> concerted effort to fix up size parsing.

I Agre exit() should not be used in parse_size...
But i don't agree with Zach about better code for it...

Maybe like this:

int parse_size(const char *s, u64 * size)..

Many places that use the function parse_size/parse_limit,
they have to be corrected after change....

Thanks,
Wang

>
> Who knew it was so hard? :)
>
> -Eric
>
>> david
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
