From: Spelic <spelic@shiftmail.org>
Subject: Re: Offline Deduplication for Btrfs
Date: Thu, 06 Jan 2011 02:56:13 +0100
Message-ID: <4D25213D.1080504@shiftmail.org>
References: <1294245410-4739-1-git-send-email-josef@redhat.com>
 <4D24AD92.4070107@bobich.net> <20110105194645.GC2562@localhost.localdomain>
 <4D24D8BC.90808@bobich.net> <4D250B3C.6010708@shiftmail.org>
 <4D2514DC.6060306@bobich.net>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Gordan Bobic <gordan@bobich.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <4D2514DC.6060306@bobich.net>
List-ID: <linux-btrfs.vger.kernel.org>

On 01/06/2011 02:03 AM, Gordan Bobic wrote:
>
> That's just alarmist. AES is being cryptanalyzed because everything 
> uses it. And the news of it's insecurity are somewhat exaggerated (for 
> now at least). 

Who cares... the fact of not being much used is a benefit for RIPEMD / 
blowfish-twofish then.
Nobody makes viruses for Linux because they target windows. Same thing...
RIPEMD has still an advantage over SHA imho, and blowfish over AES.


>
>> If there is full blocks compare, a simpler/faster algorithm could be
>> chosen, like md5. Or even a md-64bits which I don't think it exists, but
>> you can take MD4 and then xor the first 8 bytes with the second 8 bytes
>> so to reduce it to 8 bytes only. This is just because it saves 60% of
>> the RAM occupation during dedup, which is expected to be large, and the
>> collisions are still insignificant at 64bits. Clearly you need to do
>> full blocks compare after that.
>
> I really don't think the cost in terms of a few bytes per file for the 
> hashes is that significant.

20 to 8 = 12 bytes per *filesystem block* saved, I think
Aren't we talking about block-level deduplication?
For every TB of filesystem you occupy 2GB of RAM with hashes instead of 
5.3GB (I am assuming 4K blocks, I don't remember how big are btrfs blocks)
For a 24 * 2TB storage you occupy 96GB instead of 254GB of RAM. It might 
be the edge between feasible and not feasible.
Actually it might not be feasible anyway... an option to store hashes 
into a ssd should be provided then...
