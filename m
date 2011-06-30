From: Proskurin Kirill <k.proskurin@corp.mail.ru>
Subject: Re: [btrfs-transacti] & btrfs-endio-wri] - WAS: Re: [btrfs-delalloc-]
Date: Thu, 30 Jun 2011 21:19:33 +0400
Message-ID: <4E0CB025.2020904@corp.mail.ru>
References: <4E084786.2070200@corp.mail.ru> <201106271521.54497.hka@qbs.com.pl> <4E0B46CA.2030205@corp.mail.ru> <4E0B4F67.30702@redhat.com> <4E0C8443.7070109@corp.mail.ru> <4E0CAE9E.7000406@redhat.com>
Reply-To: Btrfs mailing list <linux-btrfs@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: Btrfs mailing list <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E0CAE9E.7000406@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 06/30/2011 09:13 PM, Josef Bacik wrote:
> On 06/30/2011 10:12 AM, Proskurin Kirill wrote:
>> On 06/29/2011 08:14 PM, Josef Bacik wrote:
>>>> Ok - I upgrade to 2.6.39-2 but it is seems to all things get worse.
>>>> Now I see [btrfs-transacti]&   btrfs-endio-wri] 80-100% all the time and
>>>> io performance looks like lower then before.
>>>>
>>>> Our scribe daemon in state D most of the time with half of a normal
>>>> load. Only kernel was changed.
>>>>
>>>> Any performance tune recommendation?
>>>>
>>>
>>> Can you get sysrq+w while this problem is happening so we can see whats
>>> going on?  Thanks,
>>
>> I attached sysrq+w. Hope it helps.
>>
>
> Heh so it just looks like you are writing a bunch of stuff, that's not
> particularly helpful.  What does this program do generically?  How full
> is your fs?  Do you have snapshots/subvolumes?  If so how many?  Thanks,

Scribe is taling logs by network. ~300 hosts send it to it and scribe 
write them to fs. I use zlib compression on btrfs partition.

Mount options is noatime,noacl,compress-force=zlib

iostat -x 1 tells me what util of btrfs partition is from 50% to ~90% 
all the time.

Btrfs partition is near full:
Size  Used Avail Use%
28T   26T  2.1T  93%

I don`t use snapshots/subvolumes at this time so none.

-- 
Best regards,
Proskurin Kirill
