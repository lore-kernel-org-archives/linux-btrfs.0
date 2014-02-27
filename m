Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f181.google.com ([209.85.192.181]:61125 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663AbaB0RFO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Feb 2014 12:05:14 -0500
Received: by mail-pd0-f181.google.com with SMTP id p10so2666259pdj.12
        for <linux-btrfs@vger.kernel.org>; Thu, 27 Feb 2014 09:05:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAN6S_2R5i7uBfoxi=Ncmj7-3x820hHX7cRTbJRA=WkVQb4B2bw@mail.gmail.com>
References: <CAN6S_2R5i7uBfoxi=Ncmj7-3x820hHX7cRTbJRA=WkVQb4B2bw@mail.gmail.com>
Date: Thu, 27 Feb 2014 18:05:14 +0100
Message-ID: <CAFTPBcK8s+9G-6-pnLNAVeEOLFEH+=dOV4BLtWQ1YLYGSO+aNw@mail.gmail.com>
Subject: Re: What are the linux kernel versions incompatibilities with btrfs?
From: Felix Blanke <felixblanke@gmail.com>
To: Brent Millare <bmillar1@jhmi.edu>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I can't give you a specific answer to your question. But because btrfs
is still under heavy development you shouldn't use it with those old
kernels at all in my oppinion. You should never be more than one
version away from the current stable kernel.

Regards,
Felix

On Thu, Feb 27, 2014 at 5:31 PM, Brent Millare <bmillar1@jhmi.edu> wrote:
> I read that usage of a btrfs volume with a newer kernel can render it
> unreadable when that same volume is used with an older kernel. I have
> a mobile storage device that will be used by different linux
> distributions and kernels. What are the kernel version
> incompatibilities I might have to worry about? The machines I will use
> have kernel versions 3.2.0, 3.5.0, and higher.
>
> -Brent
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
