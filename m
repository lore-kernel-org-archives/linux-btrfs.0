From: dima <dolenin@parallels.com>
Subject: Re: Set nodatacow per file?
Date: Mon, 13 Feb 2012 16:40:03 +0900
Message-ID: <4F38BE53.4080204@parallels.com>
References: <4F38B8F0.5020506@yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
To: <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F38B8F0.5020506@yahoo.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hello Ralf-Peter,

Actually it is possible. Check out David's response to my question from 
some time ago:
http://permalink.gmane.org/gmane.comp.file-systems.btrfs/14227

The nocow.c script he attached does just the thing you want. The script 
is really working. I needed nocow for different purpose but it did not 
occur to me to try it on VM image and see if the performance would 
improve. Sounds like a great idea. If you get around to try it, pls. 
post your impressions here.

best
~dima



On 02/13/2012 04:17 PM, Ralf-Peter Rohbeck wrote:
> Hello,
> is it possible to set nodatacow on a per-file basis? I couldn't find
> anything.
> If not, wouldn't that be a great feature to get around the performance
> issues with VM and database storage? Of course cloning should still
> cause COW.
>
> Thanks,
> Ralf-Peter
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html
