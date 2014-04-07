Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:65077 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754335AbaDGQQl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 7 Apr 2014 12:16:41 -0400
Message-ID: <5342CF5F.6090009@fb.com>
Date: Mon, 7 Apr 2014 12:16:31 -0400
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: ylet ylet <levin.front@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Is this a race bug when releasing eb?
References: <CAAcaxmWqrLUwbvmsyE+3zLLP1jSVZXGASRvN-D-BLaJp4WnpLQ@mail.gmail.com>	<5342C944.2020000@fb.com>	<CAAcaxmWEDa+jS8n4LZKdE_ZXFVAoOgACDseQs0_fViYdfRHShg@mail.gmail.com>	<CAAcaxmURiYRV7Rszb9UQuxSCgR+ZRTu2f+CxVhS4x7qHU2wb4A@mail.gmail.com> <CAAcaxmWTTz-KRyXtQ-Hgn=J-1uERgnzM1H4g0m4pp1q68RYP9Q@mail.gmail.com>
In-Reply-To: <CAAcaxmWTTz-KRyXtQ-Hgn=J-1uERgnzM1H4g0m4pp1q68RYP9Q@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04/07/2014 12:12 PM, ylet ylet wrote:
> ======================This is the IOzone test bug (can be reliably
> reproduced)==================================
>
> Btrfs falls into hang when I ran iozone test with the following configuration:
>
> ./iozone -s 8g -i 0 -i 2 -i 1 -t 4 -r 4k -+w 50 -+y 20 -+C 60 -F
> /mnt/btrfs/test1 /mnt/btrfs/test2 /mnt/btrfs/test3 /mnt/btrfs/test
>
> The bug can be very easily triggered when running this test in my PC.
> My PC equipped with 4-core intel I5 cpu, 8G memory and a SSD. dmesg
> result is as below, hoping to help you guys:

Oh goody one I can answer!  That is fixed by this

     Btrfs: fix deadlock with nested trans handles

I'll look into the postmark thing.  Thanks,

Josef
