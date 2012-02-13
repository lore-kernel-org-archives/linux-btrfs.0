From: dima <dolenin@parallels.com>
Subject: Re: Set nodatacow per file?
Date: Mon, 13 Feb 2012 17:40:25 +0900
Message-ID: <4F38CC79.6050906@parallels.com>
References: <4F38B8F0.5020506@yahoo.com> <4F38BE53.4080204@parallels.com> <20120213140921.5a009404@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
To: <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120213140921.5a009404@natsu>
List-ID: <linux-btrfs.vger.kernel.org>

On 02/13/2012 05:09 PM, Roman Mamedov wrote:
> On Mon, 13 Feb 2012 16:40:03 +0900
> dima<dolenin@parallels.com>  wrote:
>
>> Hello Ralf-Peter,
>>
>> Actually it is possible. Check out David's response to my question from
>> some time ago:
>> http://permalink.gmane.org/gmane.comp.file-systems.btrfs/14227
>>
>> The nocow.c script he attached does just the thing you want. The script
>> is really working. I needed nocow for different purpose but it did not
>> occur to me to try it on VM image and see if the performance would
>> improve. Sounds like a great idea. If you get around to try it, pls.
>> post your impressions here.
>
> Thanks for the link, this is indeed interesting.
>
> I made a couple of small changes, i.e. I wanted a way to unset nocow and to
> check that changing flags really worked.
>
> gcc -o /usr/local/bin/nocow nocow.c
> ln -sf /usr/local/bin/nocow /usr/local/bin/cow
>
> Perhaps the support for setting this flag should be added to the 'btrfs'
> utility.


Cool. Thanks Roma!
I really wanted the feature to 'unset' the nocow and check the current 
state of flags. Will check it out today. I also think that it should 
definitely be included into the userspace btrfs utilities.
best
~dima
