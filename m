From: Ric Wheeler <ricwheeler@gmail.com>
Subject: Re: btrfs_tree_lock & trylock
Date: Mon, 08 Sep 2008 13:32:14 -0400
Message-ID: <48C5619E.9010505@gmail.com>
References: <20080908135414.GG26079@one.firstfloor.org> <1220882551.8537.5.camel@think.oraclecorp.com> <20080908142052.GK26079@one.firstfloor.org> <20080908080751.3d29fd61@extreme> <20080908154714.GM26079@one.firstfloor.org> <20080908085054.21acbe77@extreme> <1220889313.8537.50.camel@think.oraclecorp.com> <48C54F12.3040702@hp.com> <1220890832.8537.63.camel@think.oraclecorp.com> <20080908094942.5d6136e7@extreme> <20080908171742.GB19117@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: Stephen Hemminger <shemminger@vyatta.com>,
	Chris Mason <chris.mason@oracle.com>,
	jim owens <jowens@hp.com>, Andi Kleen <andi@firstfloor.org>,
	linux-btrfs@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20080908171742.GB19117@infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

Christoph Hellwig wrote:
> On Mon, Sep 08, 2008 at 09:49:42AM -0700, Stephen Hemminger wrote:
>   
>> Not to mention the problem that developers seem to have faster machines than
>> average user, but slower than the enterprise and future generation CPU's.
>> So any tuning value seems to get out of date fast.
>>     
>
> So where do my fellow developers get these fast systems from? :)
>
>   

Actually, my experience is that most linux file system developers have 
really poking, aged hardware with little to no cutting edge storage (or 
even cutting edge commercial class storage). Testing file systems on lap 
tops and desktops with old CPUs, no DRAM and 40GB drives does not even 
reflect a typical home user these days :-)

ric

