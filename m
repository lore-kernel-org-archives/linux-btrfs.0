From: Arne Jansen <sensille@gmx.net>
Subject: Re: [PATCH v2 3/6] btrfs: add scrub code and prototypes
Date: Wed, 23 Mar 2011 15:19:38 +0100
Message-ID: <4D8A017A.6080705@gmx.net>
References: <cover.1299854593.git.sensille@gmx.net> <4e91674acd2c5a283e1fd6f86024332ff7dfc155.1299854593.git.sensille@gmx.net> <20110311163458.GS17108@twin.jikos.cz> <4D7B50DF.30508@gmx.net> <20110322163812.GD17108@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org, dave@jikos.cz
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110322163812.GD17108@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>

On 22.03.2011 17:38, David Sterba wrote:

>> David Sterba wrote:
>>> On Fri, Mar 11, 2011 at 03:49:40PM +0100, Arne Jansen wrote:
>>>> This is the main scrub code.
>>>>
>>>
>>> sizeof(struct scrub_dev) == 18760 on an x86_64, an order 3 allocation in
>>> scrub_setup_dev()
>>
>> Is this a problem? There are only few allocations of it, one per device.
> 
> High order allocations may fail when memory is fragmented, and should be
> avoided when possible. (And it is here, allocate each 'struct scrub_bio'
> separately and fill the bios array with pointers.) Scrub ioctl may fail
> to start until order-3 allocation will be available.
> 

I updated this in my git repo.

Thanks,
Arne
