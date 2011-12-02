From: Tobias <tracer@robotech.de>
Subject: Re: Blocked for more than 120 seconds
Date: Fri, 02 Dec 2011 16:48:31 +0100
Message-ID: <4ED8F34F.8090609@robotech.de>
References: <4ED34359.6010305@robotech.de> <1322472549.1962.2.camel@Nokia-N900> <4ED5FAEF.8070400@robotech.de> <20111130141006.GY24338@shiny> <4ED738E5.3080200@robotech.de> <20111201184158.GB10535@shiny> <4ED8D6C8.4020609@robotech.de> <4ED8ED36.3080105@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: Konstantinos Skarlatos <k.skarlatos@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4ED8ED36.3080105@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Am 02.12.2011 16:22, schrieb Konstantinos Skarlatos:
>>> So, the transaction close is in btrfs_evict_inode, which sounds like a
>>> deadlock recently fixed by this commit:
>>>
>>> http://git.kernel.org/?p=linux/kernel/git/mason/linux-btrfs.git;a=commit;h=aa38a711a893accf5b5192f3d705a120deaa81e0 
>>>
>>>
>>> If you pull the for-linus branch from today, hopefully the problem will
>>> be gone.
>>>
>>
>> This looks very good. With this Kernel i still have some hangs, but 
>> only in rsync, only under high load and they don't lock up the system 
>> - so i guess it's ok now.
>
> I still have hangs and lock ups under the same situation (rsync of 
> many files) under 3.2rc3. rc3 made the hang appear after 200gb of 
> files, while in rc2 i had hangs after only 11gb .

Yes, i had them too in 3.2rc3! The problem where solved with patches 
from the "btrfs-for-linus" -branch. (see link above).

Tobias

