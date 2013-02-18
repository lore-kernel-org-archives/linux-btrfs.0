Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f41.google.com ([209.85.160.41]:53302 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756346Ab3BRRx3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Feb 2013 12:53:29 -0500
Received: by mail-pb0-f41.google.com with SMTP id um15so1771041pbc.14
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Feb 2013 09:53:28 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <512266F5.7000109@die-jansens.de>
References: <CALJXSJrNNkEmSeGkez+A5-SWT9k8CUA7fUW5MRviXBWTLB1nqQ@mail.gmail.com>
	<512266F5.7000109@die-jansens.de>
Date: Mon, 18 Feb 2013 12:53:28 -0500
Message-ID: <CALJXSJpEVB6vESOQmpLfBkHYSqxU0quhByYGSJqgUR5SVY6Shw@mail.gmail.com>
Subject: Re: Kernel panic when scrub is used
From: =?UTF-8?B?SsOpcsO0bWUgUG91bGlu?= <jeromepoulin@gmail.com>
To: Arne Jansen <lists@die-jansens.de>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Here you go, I also added 2 other screenshots of the same problem.
http://tinypic.com/r/5ckgug/6
http://tinypic.com/r/t0i9t4/6
http://tinypic.com/r/2r3xdvl/6

On Mon, Feb 18, 2013 at 12:37 PM, Arne Jansen <lists@die-jansens.de> wrote:
> On 02/18/13 18:14, Jérôme Poulin wrote:
>> I experience a kernel panic with "General protection fault" when doing
>> a scrub on Kernel 3.8-rc7.
>>
>> Here is a screenshot: http://tinypic.com/r/34r6nad/6
>
> I'd love to see the first stacktrace...
>
>>
>> The weird part is that the scrub completes from initramfs, but when
>> system is fully booted, is kernel panics every time in the low
>> percentage. (<10%)
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
