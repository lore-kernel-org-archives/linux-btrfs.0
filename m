Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f182.google.com ([74.125.82.182]:62699 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755871AbaGaD5p (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Jul 2014 23:57:45 -0400
MIME-Version: 1.0
In-Reply-To: <CAPDOMVgXChx5HST-jMEZmWDydWKe0Yv15pyTiPeOuQSVEjihFA@mail.gmail.com>
References: <1406752954-26158-1-git-send-email-xerofoify@gmail.com>
	<CAPM=9ty2PhMdLykVX4c074Tdkyh0OO_jtfw-CAFHk8ANcZA4kQ@mail.gmail.com>
	<CAPDOMVgXChx5HST-jMEZmWDydWKe0Yv15pyTiPeOuQSVEjihFA@mail.gmail.com>
Date: Thu, 31 Jul 2014 13:57:43 +1000
Message-ID: <CAPM=9txGAA3sanpjYBgAuk0BynZRP56SRBfL_Rd88oDzBKHZ_g@mail.gmail.com>
Subject: Re: [PATCH] Remove certain calls for releasing page cache
From: Dave Airlie <airlied@gmail.com>
To: Nick Krause <xerofoify@gmail.com>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        "linux-btrfs@vger.kernel.org SYSTEM list:BTRFS FILE"
	<linux-btrfs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 31 July 2014 12:05, Nick Krause <xerofoify@gmail.com> wrote:
> On Wed, Jul 30, 2014 at 7:30 PM, Dave Airlie <airlied@gmail.com> wrote:
>>> This patch removes the lines for releasing the page cache in certain
>>> files as this may aid in perfomance with writes in the compression
>>> rountines of btrfs. Please note that this patch has not been tested
>>> on my own hardware due to no compression based btrfs volumes of my
>>> own.
>>>
>>
>> For all that is sacred, STOP.
>>
>> Go and do something else, you are wasting people's valuable time,
>>
>> Don't send any patches you haven't tested ever. If you aren't capable
>> of setting up a VM to run compressed btrfs volumes in, what makes you
>> think you can patch the code.
>>
>> This isn't how you learn to be a kernel developer by wasting other
>> kernel developers time, if you can't work out why releasing the page cache
>> is necessary then don't send the patch until you have spent the time
>> understanding what the page cache is.
>>
>> I know you'll just ignore this, and keep on trucking just like you ignored
>> the other messages from Stephen before.
>>
>> But if you want to work on the kernel, this isn't the way to do it, and
>> nobody will ever take a patch from you seriously if you continue in this
>> fashion.
>>
>> Dave.
> Dave ,
> Seems I need to have tested this code first.
> Regards Nick


No you needed to do a lot more, these one line replies from you are
quite stupid,

You are quite deliberately missing the point of people trying to help you,

Dave.
