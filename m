From: Josef Bacik <josef@redhat.com>
Subject: Re: [btrfs-transacti] & btrfs-endio-wri] - WAS: Re: [btrfs-delalloc-]
Date: Wed, 29 Jun 2011 12:14:31 -0400
Message-ID: <4E0B4F67.30702@redhat.com>
References: <4E084786.2070200@corp.mail.ru> <201106271521.54497.hka@qbs.com.pl> <4E0B46CA.2030205@corp.mail.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Hubert Kario <hka@qbs.com.pl>,
	Btrfs mailing list <linux-btrfs@vger.kernel.org>
To: Proskurin Kirill <k.proskurin@corp.mail.ru>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E0B46CA.2030205@corp.mail.ru>
List-ID: <linux-btrfs.vger.kernel.org>

On 06/29/2011 11:37 AM, Proskurin Kirill wrote:
> On 06/27/2011 05:21 PM, Hubert Kario wrote:
>> On Monday 27 of June 2011 11:04:06 Proskurin Kirill wrote:
>>> Hello all.
>>>
>>> What we have:
>>> SL6 - kernel 2.6.32-131.2.1.el6.x86_64
>>> btrfs on mdadm RAID5 with 8 HDD - 27T partition.
>>>
>>> I see this at top:
>>> 1182 root      20   0     0    0    0 R 100.0  0.0  16:39.73
>>> [btrfs-delalloc-]
>>>
>>> And LA is grow. What is this and how can I fix it?
>>
>> delalloc is a delayed allocation kernel thread -- it probably means
>> something
>> is writing large amounts of data to the file system
>>
>> 2.6.32 is *old* as far as btrfs is concerned, there have been many
>> bugs fixed
>> and performance improvements since
> 
> Ok - I upgrade to 2.6.39-2 but it is seems to all things get worse.
> Now I see [btrfs-transacti] & btrfs-endio-wri] 80-100% all the time and
> io performance looks like lower then before.
> 
> Our scribe daemon in state D most of the time with half of a normal
> load. Only kernel was changed.
> 
> Any performance tune recommendation?
> 

Can you get sysrq+w while this problem is happening so we can see whats
going on?  Thanks,

Josef
