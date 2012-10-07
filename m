Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:58064 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471Ab2JGKs2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 7 Oct 2012 06:48:28 -0400
Received: by mail-oa0-f46.google.com with SMTP id h16so2984469oag.19
        for <linux-btrfs@vger.kernel.org>; Sun, 07 Oct 2012 03:48:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201210061140.26936.Martin@lichtvoll.de>
References: <CAB9VWqAcwCTDi=pV03CpuXaG0kCE6bT1+NbJJJUdzuwVdR-e-Q@mail.gmail.com>
	<50602781.9010009@jan-o-sch.net>
	<CAHf9xvY1TSNa-zY82whUrK6DtnFYiNx1BEF6R1kGQj1HU+wbxA@mail.gmail.com>
	<201210061140.26936.Martin@lichtvoll.de>
Date: Sun, 7 Oct 2012 12:48:26 +0200
Message-ID: <CAHf9xvb8Oz+9TOQ_HJk8Qh5W==RKRme=u=QVvnBd-7E0oBW-gg@mail.gmail.com>
Subject: Re: btrfs send/receive review by vfs folks
From: Alex Lyakas <alex.bolshoy.btrfs@gmail.com>
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Matrin,

On Sat, Oct 6, 2012 at 11:40 AM, Martin Steigerwald <Martin@lichtvoll.de> wrote:
> Am Donnerstag, 4. Oktober 2012 schrieb Alex Lyakas:
>> Hi Jan,
>> as I promised, here is some code for you to look at.
>>
>> First I will describe the approach in general.
>>
>> # Get rid of the pipe. Instead, user-space passes a buffer and kernel
>> fills the specified user-space buffer with commands.
>> # When the buffer is full, kernel stops generating commands and
>> returns a checkpoint to the user-space.
>
> Can it just fill a second buffer while userspace command handles the first?
No, at this point kernel receives only one buffer and fills it up.
Can you pls elaborate more what improvement you have in mind? Like
user-space sending a list of buffers to the kernel in one shot? Or
that user-space handles kind of producer-consumer pool of buffers and
works on full buffers while kernel fills the empty ones (this, of
course, can work).

In general, my direction was to make the kernel call stateless, which
makes the user-space part more flexible.

Thanks,
Alex.
