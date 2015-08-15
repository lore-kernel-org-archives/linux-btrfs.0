Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f179.google.com ([209.85.213.179]:37358 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436AbbHOCcK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Aug 2015 22:32:10 -0400
Received: by igui7 with SMTP id i7so23759197igu.0
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Aug 2015 19:32:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <55CE87B9.2050502@oracle.com>
References: <CAK7bmU8hWWVn0KxyKLPsmar2EzSKO_V5fYm5gDor=QycqzrfPQ@mail.gmail.com>
	<55CE7E94.7090102@oracle.com>
	<CAK7bmU8EXeYV=ESwzbgtb120Fs1dRgUcO_W0T-GQS8rQRnwmZw@mail.gmail.com>
	<55CE87B9.2050502@oracle.com>
Date: Fri, 14 Aug 2015 22:32:09 -0400
Message-ID: <CAK7bmU_Xw0r-YQLwWndJvvn=ozQ1GTj+jWDNjKow1syGDSDdqA@mail.gmail.com>
Subject: Re: Can't mount degraded. How to remove/add drives OFFLINE?
From: Timothy Normand Miller <theosib@gmail.com>
To: Anand Jain <anand.jain@oracle.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I applied that patch to my 4.1.4, it mounted degraded, and now it's
balancing to the new drive.

Thanks for all the help!

On Fri, Aug 14, 2015 at 8:28 PM, Anand Jain <anand.jain@oracle.com> wrote:
>
>
>> Just to be clear, I removed the drive (the original failed drive) when
>> the power was off, then powered up, and then mounted degraded.  That's
>> not dangerous that I know of.
>
>
> patch has details. pls refer.
>>
>>
>> Where is this patch, and what kernel versions can this be applied to?
>
>
>
> https://patchwork.kernel.org/patch/7014141/
>
> its on 4.3. but should apply nice on below.
>
> thanks
> Anand



-- 
Timothy Normand Miller, PhD
Assistant Professor of Computer Science, Binghamton University
http://www.cs.binghamton.edu/~millerti/
Open Graphics Project
