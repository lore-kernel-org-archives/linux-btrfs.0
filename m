From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: billion file testing of btrfs
Date: Mon, 16 Aug 2010 09:10:04 -0400
Message-ID: <4C6938AC.2080703@redhat.com>
References: <4C692F24.5000208@redhat.com> <20100816123735.GV3315@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: Chris Mason <chris.mason@oracle.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100816123735.GV3315@think>
List-ID: <linux-btrfs.vger.kernel.org>

  On 08/16/2010 08:37 AM, Chris Mason wrote:
> On Mon, Aug 16, 2010 at 08:29:24AM -0400, Ric Wheeler wrote:
>> I decided to try btrfs on F13 (2.6.33.6-147.2.4.fc13.x86_64 kernel)
>> with the following fs_mark command and a 1.5 TB Seagate S-ATA disk:
>>
>> # fs_mark -s 0 -S 0 -D 1000 -n 1000000 -L 1000 -d /test/ -l btrfs_log.txt
>>
>> btrfs starts off at a fantastic rate - roughly 3-4 times the speed of ext4:
>>
> [ log ]
>
>> I will fill this and get some plots, etc to do relative performance
>> &  then wanted to try the current RC kernel just to refresh.
> Thanks Ric, I think this is related to the perf problem delalloc
> flushing performance bug.  I'll nail it down shortly.
>
> -chris

Great, I will be happy to test patches when you have them. No particular hurry 
on my end.

I also hope to get our new arrays online and should be able to steal a couple of 
days run there with luck,

Ric

