Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:56863 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751938AbaDGQDk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 7 Apr 2014 12:03:40 -0400
Message-ID: <5342CC4D.10302@fb.com>
Date: Mon, 7 Apr 2014 12:03:25 -0400
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: ylet ylet <levin.front@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Fwd: Is this a race bug when releasing eb?
References: <CAAcaxmWqrLUwbvmsyE+3zLLP1jSVZXGASRvN-D-BLaJp4WnpLQ@mail.gmail.com>	<5342C944.2020000@fb.com>	<CAAcaxmWEDa+jS8n4LZKdE_ZXFVAoOgACDseQs0_fViYdfRHShg@mail.gmail.com> <CAAcaxmURiYRV7Rszb9UQuxSCgR+ZRTu2f+CxVhS4x7qHU2wb4A@mail.gmail.com>
In-Reply-To: <CAAcaxmURiYRV7Rszb9UQuxSCgR+ZRTu2f+CxVhS4x7qHU2wb4A@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04/07/2014 12:01 PM, ylet ylet wrote:
> hi Josef
>
> Thanks, I got it. But i still have no idea to reliably reproduce it.
> This bug-on is triggered when I ran POSTMARK test lasting two days.
>
> BTW, can you reproduce the bug reported by email with title of "btrfs
> hung with iozone test under linux kernel 3.14." The reported bug can
> be reliably reproduced in my environment.
>

Can I have the postmark options you are using and the general setup of 
your fs?  Number of disks, mount options and mkfs options.  I've not 
seen it, I'm flirting with paternity leave atm and was gone all last 
week, once we track down this memory leak I'll give it a shot.  Thanks,

Josef

