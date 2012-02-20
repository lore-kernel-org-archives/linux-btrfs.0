From: Olivier Bonvalet <btrfs.list@daevel.fr>
Subject: Re: btrfs-convert processing time
Date: Mon, 20 Feb 2012 15:29:41 +0100
Message-ID: <4F4258D5.4070101@daevel.fr>
References: <4F4241D1.4080506@daevel.fr> <20458953.qbO19NXijp@k85hala03> <4F424D8D.4030802@daevel.fr> <1920178.zXOEpupmQW@k85hala03> <CAG1y0sevgB0=Y-Sxe_N4zGeZvYp+Pmpjv0q8JeRg22qtkZ0tJw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: "Fajar A. Nugraha" <list@fajar.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAG1y0sevgB0=Y-Sxe_N4zGeZvYp+Pmpjv0q8JeRg22qtkZ0tJw@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 20/02/2012 15:00, Fajar A. Nugraha wrote:
> On Mon, Feb 20, 2012 at 8:50 PM, Hubert Kario<hka@qbs.com.pl>  wrote:
>> On Monday 20 of February 2012 14:41:33 Olivier Bonvalet wrote:
>>> Lot of small files (like compressed email from Maildir), and lot of
>>> hardlinks, and probably low free space (near 15% I suppose).
>>>
>>>
>>> So I think I have my answer :)
>>>
>>
>> Yes, this is probably the worst possible combination.
>>
>> Plese keep us updated. Just to have exact numbers for new users.
>
>
> ... although it would probably fail anyway due to btrfs hardlink limit
> in the same directory.
>

And in that case, btrfs-convert will abort, or ignore the error, or just 
hang ?
