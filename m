Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:62936 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751918Ab2LFBmr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 5 Dec 2012 20:42:47 -0500
Received: by mail-lb0-f174.google.com with SMTP id gi11so4960999lbb.19
        for <linux-btrfs@vger.kernel.org>; Wed, 05 Dec 2012 17:42:46 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAPkEcwhJ1HTDDxg63n==JHvJWkrSYKUszdv2LLWscog4UzAUWQ@mail.gmail.com>
References: <CAMRmmp+qQZg2_vkZ9bfLFg-AC20SGkmEo4cdCOQEs+4i1JUeDQ@mail.gmail.com>
 <CAPkEcwhJ1HTDDxg63n==JHvJWkrSYKUszdv2LLWscog4UzAUWQ@mail.gmail.com>
From: Ins <insfocus@gmail.com>
Date: Thu, 6 Dec 2012 09:42:04 +0800
Message-ID: <CAMRmmpLUF6CLgVOyptfTY5M-jhvwqZq4QWwwb4ZPjgpi5qsmig@mail.gmail.com>
Subject: Re: send/receive questions
To: james northrup <northrup.james@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

What the emacs sendrecv.el does?

2012/12/6 james northrup <northrup.james@gmail.com>:
> more important, when will the emacs sendrecv.el be ready?
>
>
> On Tue, Dec 4, 2012 at 9:29 PM, Ins <insfocus@gmail.com> wrote:
>>
>> Hello all,
>>
>>     The implementation of send/receive is very cool.
>>
>>     But I wonder whether there are any plans to support these features
>> below or not,
>>
>>     1. support writable subvolume
>>
>>     2. can skip something to receive, for example,
>>          (1) only receive those commands in range [1000, ..), skip the
>> before 1000
>>          (2) only receive changes after some time, like recent 3 days.
>>
>>     3. can revert one receive
>>         Just like the patch command does
>>
>>     4. support this scene,
>>         When doing the receive process, if it suddently be stopped,
>> how to continue the receive process.
>>
>>     If 2 and 3 can be supported, 4 may be easy.
>>
>>     It's true there may be many errors if we skip something to receive.
>>
>>
>> --
>> Thanks.
>> -Rock
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>



-- 
Thanks.
-Rock
