From: TARUISI Hiroaki <taruishi.hiroak@jp.fujitsu.com>
Subject: Re: Way to quickly "revert back" to a snapshot?
Date: Thu, 05 Nov 2009 14:31:29 +0900
Message-ID: <4AF26331.2040400@jp.fujitsu.com>
References: <4AD9FCDC.6060107@ubuntu.com> <20091026093842.GF5564@think> 	<4AEA8D20.3020504@jp.fujitsu.com> <934f64a20911041357y57ee5854r83130ecac797b7ff@mail.gmail.com> <2a31deca0911041433l1ca5f8f4vfb2e51631b53e7a6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: davidnicol@gmail.com, linux-btrfs@vger.kernel.org
To: andrey.v.kuzmin@gmail.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <2a31deca0911041433l1ca5f8f4vfb2e51631b53e7a6@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Thank you for your ideas.

It will be nice we can get snapshot/subvolume information with
usual file/directory interface as you suggested, or like sysfs.

But, now I'm writing using ioctl interface, which may be good
enough for now.


Andrey Kuzmin wrote:
> /mountroot/.{snapshots,subvolumes} seems logical, works fine with
> usual command-line/programmatic interfaces.
> 
> Regards,
> Andrey
> 
> 
> 
> On Thu, Nov 5, 2009 at 12:57 AM, David Nicol <davidnicol@gmail.com> wrote:
>> On Fri, Oct 30, 2009 at 12:52 AM, TARUISI Hiroaki
>> <taruishi.hiroak@jp.fujitsu.com> wrote:
>>> I'm trying to make this snapshots/subvolumes listing feature,
>>> I wonder how the interface should be.
>>>
>>> Is there any other idea?
>> It's layers above where you're working, but how about providing a
>> virtual directory off the mounting root, like the lost+found
>> directories in other FSes, that would appear to contain them?
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
taruisi

