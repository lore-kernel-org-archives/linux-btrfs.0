From: Christian Robert <christian.robert@polymtl.ca>
Subject: Re: btrfs: block rsv returned -28
Date: Fri, 24 Feb 2012 21:47:20 -0500
Message-ID: <4F484BB8.2090601@polymtl.ca>
References: <4F4846E1.50307@polymtl.ca>
 <CAE5mzvhzsHDU=HU9_MTcp8ptA25tcn7HkxqOE1SNqznvRk9eMQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII; format=flowed
Cc: cwillu <cwillu@cwillu.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <CAE5mzvhzsHDU=HU9_MTcp8ptA25tcn7HkxqOE1SNqznvRk9eMQ@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

wrong, I tryed to wait until "Load average" got near to zero (couple of minutes)
before unmounting and it changed nothing. None of thoses subvolumes have any data inside
so deleting should be trivial and quick.

Got the kernel backtrace "while" doing the deletes. Not after.


Xtian.

On 2012-02-24 21:37, cwillu wrote:
> On Fri, Feb 24, 2012 at 8:26 PM, Christian Robert
> <christian.robert@polymtl.ca>  wrote:
>> Hi,
>>
>> I ran a quite heavy script who create 10,000 subvolumes and then delete
>> thoses 10,000 subvolumes.
>>
>> No problems in the "create" part, but at the "delete" part
>> I got several traceback from the kernel:
>>
> [snip]
>>
>> and finally the partition cannot be unmounted and I had to reboot.
>>
>> well, it's probably not that important, who the hell will be deleting 10,000
>> subvolumes
>> in a 2 minutes timeframe ?
>
> Deletion works in the background, and involves a walk over the
> contents being deleted.  I'm fairly sure that unmounting blocks on the
> completion of that background process, which could take quite some
> time in this case.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
