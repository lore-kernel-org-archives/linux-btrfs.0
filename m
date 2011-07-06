From: Proskurin Kirill <k.proskurin@corp.mail.ru>
Subject: Re: [btrfs-transacti] & btrfs-endio-wri] - WAS: Re: [btrfs-delalloc-]
Date: Wed, 06 Jul 2011 20:31:32 +0400
Message-ID: <4E148DE4.7070904@corp.mail.ru>
References: <4E0D7323.9010202@corp.mail.ru> <4E0DD4AB.9040900@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: Btrfs mailing list <linux-btrfs@vger.kernel.org>
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E0DD4AB.9040900@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 07/01/2011 06:07 PM, Josef Bacik wrote:

>> I found what my btrfs partition now is really slow. Something wrong
>> happend. I try on 2.6.32 and 2.6.39 - same result. It is because
>> partition is almost full?
>>
>> I run a simple cycle to clean some old files:
>> for i in `cat /tmp/delit`; do rm -f $i ; done
>>
>> And it is takes about 5-10 second per file to delete.
>> I get sysrq+w while rm is work - it is attached.
>>
>
> Just a shot in the dark, but will you give this a shot and let me know
> how it goes?  Thanks

Sorry for late answer. Im afraid I can`t test it now - then problem 
occurs I have no time to wait and format partition. But I will save 
this patch and if I run at this problem again I will try it and report 
here.

Thanks for your help anyway.

-- 
Best regards,
Proskurin Kirill
