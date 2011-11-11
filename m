From: dima <dolenin@parallels.com>
Subject: Re: How to remount btrfs without compression?
Date: Fri, 11 Nov 2011 22:29:51 +0900
Message-ID: <4EBD234F.4050705@parallels.com>
References: <4EB72C1B.1030702@parallels.com> <201111071319.14493.Martin@lichtvoll.de> <4EB87E01.1040704@parallels.com> <4EB880A0.1030304@gmail.com> <CAG1y0seMUUNwXCY6-=JehE+rrd4PRF55MZoHEUB_9+jDm6N_rA@mail.gmail.com> <4EB88BC9.7020509@gmail.com> <4EB88D4A.5050908@parallels.com> <20111108150151.GA4954@shiny> <20111108151208.GB4954@shiny> <4EB9D0D9.1000009@parallels.com> <20111110001103.GV12759@twin.jikos.cz> <4EBB35A7.8080909@parallels.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
To: <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4EBB35A7.8080909@parallels.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 11/10/2011 11:23 AM, dima wrote:
> On 11/10/2011 09:11 AM, David Sterba wrote:
>> On Wed, Nov 09, 2011 at 10:01:13AM +0900, dima wrote:
>>> Just for the record - I could find a solution thanks to the btrfs wiki
>>> being online again. In Gotchas it says
>>>
>>> mount -o nodatacow also disables compression
>>>
>>> and indeed it does. Remounting with this option and re-saving the file
>>> makes it uncompressed. However, I could not find how to remount the
>>> filesystem afterwards without nodatacow.
>>
>> I saw this mentioned on irc today (that nodatacow diasables
>> compression). There is a way how to turn off compression on a file --
>> with help of the NOCOW _file_ attribute, ie. you don't have to remount.
>>
>> * create the file, compression enabled
>> * set NOCOW (with the attached single-purpose nocow.c utility)
>> * btrfs fi defrag the_file
>>
>> Make sure you have enough free space for the uncompressed file size. You
>> can compare the extent layout before and after the defrag with
>> "filefrag -v" .
>
>
> Hello David,
>
> Thank you, I will try it out tonight. Is there any way to see if nocow
> attribute was set on a particular file, and is there any way to unset it?


Hi David
I tried the nocow utility. It worked.
First I made sure to re-save the syslinux.cfg file while btrfs was 
mounted with lzo to ensure that it is compressed, then I set the NOCOW 
flag with your utility. Then I checked fragmentation of the file and 
since it was a small one it was not fragmented. So when I ran btrfs fi 
defrag syslinux.cfg it did not have any effect and file was not 
uncompressed. Then I simply re-saved the file and it got uncompressed 
fine since bootloader could read it on reboot.

thanks
