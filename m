Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:63841 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754864AbcJLODB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Oct 2016 10:03:01 -0400
Subject: Re: Btrfs progs build fails for 4.8
To: Abhay Sachan <lkp.abhay@gmail.com>, linux-btrfs@vger.kernel.org
References: <CAKHchJzbo7=fZrtbOwaMdMNiYMSdUuiys3iHTpyxTP92SAY1TQ@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <454e3eda-1e46-4964-2ce5-f71893bd93e7@gmx.com>
Date: Wed, 12 Oct 2016 22:01:27 +0800
MIME-Version: 1.0
In-Reply-To: <CAKHchJzbo7=fZrtbOwaMdMNiYMSdUuiys3iHTpyxTP92SAY1TQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 10/12/2016 09:58 PM, Abhay Sachan wrote:
> Hi,
> I tried building latest btrfs progs on CentOS 6, "./configure" failed
> with the error:
>
> checking for FIEMAP_EXTENT_SHARED defined in linux/fiemap.h... no
> configure: error: no definition of FIEMAP_EXTENT_SHARED found
>
> Any ideas what am I lacking in the system?

Your kernel is too old and its header doesn't support 
FIEMAP_EXTENT_SHARED flag for fiemap ioctl.

And since that flag is very important for tools like "btrfs filesystem 
du", for old kernel doesn't support EXTENT_SHARED flag, we have no 
choice but abort configuration.

Thanks,
Qu

>
> Regards,
> Abhay
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
