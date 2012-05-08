From: Felix Blanke <felixblanke@gmail.com>
Subject: Re: kernel 3.3.4 damages filesystem (?)
Date: Tue, 08 May 2012 15:44:12 +0200
Message-ID: <4FA9232C.4020308@gmail.com>
References: <C8TFFEueCXB@helmut.hullen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Cc: Helmut Hullen <Hullen@t-online.de>, linux-btrfs@vger.kernel.org
To: helmut@hullen.de
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <C8TFFEueCXB@helmut.hullen.de>
List-ID: <linux-btrfs.vger.kernel.org>

On 5/8/12 3:13 PM, Helmut Hullen wrote:
> Hallo, Clemens,
>
> Du meintest am 08.05.12:
>
>>>> But where's the gain? If a disk fails I have a lot of tools for
>>>> repairing an ext2/3/4 system.
>
>> Nope, when a disk in your ext4 raid0 array fails, you are just as
>> doomed.
>
> Why should I use RAID0 with a bundle of ext2/3/4? Mounting on/in the
> directory tree does the job.

Nobody told you that you should do it. What EVERYBODY here is telling 
you: The problem you have right now would be the same damn problem, no 
matter what fs you would you. Every fs will be unusable if you lose one 
disk in a raid0 setup. That's all what we are trying to tell you for the 
last 15 mails :)

If you don't see any benefits using btrfs then simply don't  use it :) 
Again: You misconfigured your fs if you never wanted to use raid0. Don't 
blame the fs, blame yourself.

>
> Viele Gruesse!
> Helmut
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
