From: Goffredo Baroncelli <kreijack@libero.it>
Subject: Re: mkfs.btrfs - error checking /dev/sda5 mount status
Date: Wed, 09 Feb 2011 19:25:34 +0100
Message-ID: <4D52DC1E.2050302@libero.it>
References: <iiqphe$217$1@dough.gmane.org> <4D51A0D9.9000701@libero.it> <iiscep$udg$1@dough.gmane.org>
Reply-To: kreijack@inwind.it
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Lubos Kolouch <lubos.kolouch@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <iiscep$udg$1@dough.gmane.org>
List-ID: <linux-btrfs.vger.kernel.org>

On 02/08/2011 10:26 PM, Lubos Kolouch wrote:
> Goffredo Baroncelli, Tue, 08 Feb 2011 21:00:25 +0100:
> 
>> On 02/08/2011 07:57 AM, Lubos Kolouch wrote:
>>> Hi,
>>>
>>> I'm hitting this issue - sda5 is a normal device, nothing to do with
>>> loop, encryption etc.
>>>
>>> # mkfs.btrfs /dev/sda5
>>>
>>> WARNING! - Btrfs v0.19-35-g1b444cd-dirty IS EXPERIMENTAL WARNING! - see
>>> http://btrfs.wiki.kernel.org before using
>>>
>>> error checking /dev/sda5 mount status
>>>
>>> Is there something I can do to resolve this?
>>
>> Some months ago I posted a patch [*] which allows to create a filesystem
>> even if an integrity tests fail.
>> Anyway it would be interesting understand why mkfs.btrfs fails. It is
>> possible to have a strace of the command ?
>>
> 
> here ... http://paste.pocoo.org/show/334638/
> but it is not in chroot, it is in "normal" system
> 
> Lubos
> 

Hi Lubos,

Could you post also the output of "cat /proc/mounts" command and the
output of "btrfs filesystem show" command.
I cannot understand what should be the problem.


> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> .
> 

