Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f177.google.com ([209.85.220.177]:62062 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766AbaGaEOv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Jul 2014 00:14:51 -0400
MIME-Version: 1.0
In-Reply-To: <CAPM=9txGAA3sanpjYBgAuk0BynZRP56SRBfL_Rd88oDzBKHZ_g@mail.gmail.com>
References: <1406752954-26158-1-git-send-email-xerofoify@gmail.com>
	<CAPM=9ty2PhMdLykVX4c074Tdkyh0OO_jtfw-CAFHk8ANcZA4kQ@mail.gmail.com>
	<CAPDOMVgXChx5HST-jMEZmWDydWKe0Yv15pyTiPeOuQSVEjihFA@mail.gmail.com>
	<CAPM=9txGAA3sanpjYBgAuk0BynZRP56SRBfL_Rd88oDzBKHZ_g@mail.gmail.com>
Date: Thu, 31 Jul 2014 00:14:50 -0400
Message-ID: <CAPDOMVgM+E1XxsFvhAYWzHo7HCFqp6sO6Y53_m2am-fno6m_AQ@mail.gmail.com>
Subject: Re: [PATCH] Remove certain calls for releasing page cache
From: Nick Krause <xerofoify@gmail.com>
To: Dave Airlie <airlied@gmail.com>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        "linux-btrfs@vger.kernel.org SYSTEM list:BTRFS FILE"
	<linux-btrfs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 30, 2014 at 11:57 PM, Dave Airlie <airlied@gmail.com> wrote:
> On 31 July 2014 12:05, Nick Krause <xerofoify@gmail.com> wrote:
>> On Wed, Jul 30, 2014 at 7:30 PM, Dave Airlie <airlied@gmail.com> wrote:
>>>> This patch removes the lines for releasing the page cache in certain
>>>> files as this may aid in perfomance with writes in the compression
>>>> rountines of btrfs. Please note that this patch has not been tested
>>>> on my own hardware due to no compression based btrfs volumes of my
>>>> own.
>>>>
>>>
>>> For all that is sacred, STOP.
>>>
>>> Go and do something else, you are wasting people's valuable time,
>>>
>>> Don't send any patches you haven't tested ever. If you aren't capable
>>> of setting up a VM to run compressed btrfs volumes in, what makes you
>>> think you can patch the code.
>>>
>>> This isn't how you learn to be a kernel developer by wasting other
>>> kernel developers time, if you can't work out why releasing the page cache
>>> is necessary then don't send the patch until you have spent the time
>>> understanding what the page cache is.
>>>
>>> I know you'll just ignore this, and keep on trucking just like you ignored
>>> the other messages from Stephen before.
>>>
>>> But if you want to work on the kernel, this isn't the way to do it, and
>>> nobody will ever take a patch from you seriously if you continue in this
>>> fashion.
>>>
>>> Dave.
>> Dave ,
>> Seems I need to have tested this code first.
>> Regards Nick
>
>
> No you needed to do a lot more, these one line replies from you are
> quite stupid,
>
> You are quite deliberately missing the point of people trying to help you,
>
> Dave.

Honestly ,
I understand and thanks for the help a lot. I am wondering if some one
can give me
a pointer on where to download the git repos for the btrfs user spaces
tools as it
seems on the btrfs tools on the wiki.
Regards Nick
