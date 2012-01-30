From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: btrfs-raid questions I couldn't find an answer to on the wiki
Date: Mon, 30 Jan 2012 13:49:52 +0800
Message-ID: <4F262F80.5000103@cn.fujitsu.com>
References: <pan.2012.01.26.15.41.32@cox.net> <201201291223.40161.kreijack@inwind.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
To: kreijack@inwind.it
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201201291223.40161.kreijack@inwind.it>
List-ID: <linux-btrfs.vger.kernel.org>

Goffredo Baroncelli wrote:
> On Thursday, 26 January, 2012 16:41:32 Duncan wrote:
>> 1) My /boot partition and its backup (which I do want to keep separate 
>> from root) are only 128 MB each.  The wiki recommends 1 gig sizes 
>> minimum, but there's some indication that's dated info due to mixed data/
>> metadata mode in recent kernels.
>>
>> Is a 128 MB btrfs reasonable?  What's the mixed-mode minumum recommended 
>> and what is overhead going to look like?
> 
> IIRC, the minimum size should be 256MB. Anyway, if you want/allow a separate 
> partition for  /boot I suggest to use a classic filesystem like ext3.
> 

The 256MB limitation has been removed.
