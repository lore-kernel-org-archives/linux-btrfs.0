Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:40512 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967AbbHOA2r (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Aug 2015 20:28:47 -0400
Message-ID: <55CE87B9.2050502@oracle.com>
Date: Sat, 15 Aug 2015 08:28:41 +0800
From: Anand Jain <anand.jain@oracle.com>
MIME-Version: 1.0
To: Timothy Normand Miller <theosib@gmail.com>
CC: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Can't mount degraded. How to remove/add drives OFFLINE?
References: <CAK7bmU8hWWVn0KxyKLPsmar2EzSKO_V5fYm5gDor=QycqzrfPQ@mail.gmail.com>	<55CE7E94.7090102@oracle.com> <CAK7bmU8EXeYV=ESwzbgtb120Fs1dRgUcO_W0T-GQS8rQRnwmZw@mail.gmail.com>
In-Reply-To: <CAK7bmU8EXeYV=ESwzbgtb120Fs1dRgUcO_W0T-GQS8rQRnwmZw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



> Just to be clear, I removed the drive (the original failed drive) when
> the power was off, then powered up, and then mounted degraded.  That's
> not dangerous that I know of.

patch has details. pls refer.
>
> Where is this patch, and what kernel versions can this be applied to?


https://patchwork.kernel.org/patch/7014141/

its on 4.3. but should apply nice on below.

thanks
Anand
