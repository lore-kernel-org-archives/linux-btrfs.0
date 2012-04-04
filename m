From: Shyam Prasad N <nspmangalore@gmail.com>
Subject: Re: hard links
Date: Thu, 05 Apr 2012 01:03:44 +0530
Message-ID: <4F7CA218.5070902@gmail.com>
References: <4F7C78FE.2020508@arndnet.de>
Reply-To: nspmangalore@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: Arnd Hannemann <arnd@arndnet.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F7C78FE.2020508@arndnet.de>
List-ID: <linux-btrfs.vger.kernel.org>

On 04/04/2012 10:08 PM, Arnd Hannemann wrote:
> Hi,
>
> today I experimented with hard links on btrfs and by this used all available inode space of a file.
> Interestingly if this happens even a rename of such an filename to  an _equal length_ filename
> fails:
>
> arnd@kallisto:/mnt/btrfs/tmp$ mv a b
> mv: cannot move `a' to `b': Too many links
>
> Is this expected behavior?
> There should be no reason to let this particular case fail?
>
> Best regards,
> Arnd
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
Hi Arnd,

What do you mean by 'used all available inode space'? What did you do 
exactly?

Thanks,
Shyam
