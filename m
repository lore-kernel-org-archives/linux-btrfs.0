Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:19139 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750729AbdJLESN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 12 Oct 2017 00:18:13 -0400
Subject: Re: btrfs seed question
To: Joseph Dunn <jdunn14@gmail.com>, linux-btrfs@vger.kernel.org
References: <20171011204759.1848abd7@olive.ig.local>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <ff596f2f-7232-4ee0-7967-6888236cc831@oracle.com>
Date: Thu, 12 Oct 2017 12:18:01 +0800
MIME-Version: 1.0
In-Reply-To: <20171011204759.1848abd7@olive.ig.local>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 10/12/2017 08:47 AM, Joseph Dunn wrote:
> After seeing how btrfs seeds work I wondered if it was possible to push
> specific files from the seed to the rw device.  I know that removing
> the seed device will flush all the contents over to the rw device, but
> what about flushing individual files on demand?
> 
> I found that opening a file, reading the contents, seeking back to 0,
> and writing out the contents does what I want, but I was hoping for a
> bit less of a hack.
> 
> Is there maybe an ioctl or something else that might trigger a similar
> action?

   You mean to say - seed-device delete to trigger copy of only the 
specified or the modified files only, instead of whole of seed-device ? 
What's the use case around this ?


Thanks, Anand


> Thanks,
> -Joseph
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
