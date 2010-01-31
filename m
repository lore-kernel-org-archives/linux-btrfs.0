From: Thomas Kupper <thomas@kupper.org>
Subject: Re: how to check data and metadata type
Date: Sun, 31 Jan 2010 10:17:24 +0100
Message-ID: <608110C7-A896-4223-8852-521D9C7CAF55@kupper.org>
References: <42D1AF99-19ED-4C44-9A01-8039576AA572@kupper.org> <20100130151848.GA7233@localhost.localdomain> <E3FCE606-1BB2-4D76-8DB7-94B3534A8E7F@kupper.org> <20100130182000.GB7233@localhost.localdomain> <55B112D8-062D-40A9-B3CB-6F3C8059DD69@kupper.org>
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <55B112D8-062D-40A9-B3CB-6F3C8059DD69@kupper.org>
List-ID: <linux-btrfs.vger.kernel.org>


On 31 Jan 2010, at 09:46, Thomas Kupper wrote:

> On 30 Jan 2010, at 19:20, Josef Bacik wrote:
> 
>> On Sat, Jan 30, 2010 at 05:57:49PM +0100, Thomas Kupper wrote:
>>> 
>>> On 30 Jan 2010, at 16:18, Josef Bacik wrote:
>>> 
>>>> On Fri, Jan 29, 2010 at 11:43:45PM +0100, Thomas Kupper wrote:
>>>>> Just a short question:
>>>>> 
>>>>> How can I check the data and metadata modes of a multi-device btrfs device? btrfs-show is of no help and df is still not showing the correct size of it either (using latest btrfs kernel module and btrfs tools).
>>>> 
>>>> There are patches to do this for you, look for the "-i" patch for btrfs-progs
>>>> and the "df" patch for the kernel, that will give you the information you are
>>>> looking for.  Thanks,
>>>> 
>>>> Josef
[...]
>> 
>> This is the btrfs-progs patch
>> 
>> http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg03808.html
>> 
>> and this is the kernel patch you'll want
>> 
>> http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg03807.html
>> 
>> Thanks,
>> 
>> Josef
> 
> Josef, do you have a user space app which uses the new IOCTL? df is using, right?

Typo: it should have written -> "df isn't using it, right?"

o/
Thomas