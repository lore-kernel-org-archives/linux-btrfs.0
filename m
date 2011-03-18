From: Arne Jansen <sensille@gmx.net>
Subject: Re: [PATCH] btrfs: quasi-round-robin for chunk allocation
Date: Fri, 18 Mar 2011 20:57:25 +0100
Message-ID: <4D83B925.90100@gmx.net>
References: <1297188212-23212-1-git-send-email-sensille@gmx.net>	<4D5203E5.7000902@cn.fujitsu.com>	<4D822FB6.7020901@gmx.net>	<1300458780-sup-7019@think> <AANLkTimx2BrXuSpKzcjV3EC3MO0YFAWFszg5hJDhKjgJ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: Chris Mason <chris.mason@oracle.com>, miaox <miaox@cn.fujitsu.com>,
	josef <josef@redhat.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: cwillu <cwillu@cwillu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTimx2BrXuSpKzcjV3EC3MO0YFAWFszg5hJDhKjgJ@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 18.03.2011 17:25, cwillu wrote:
> On Fri, Mar 18, 2011 at 8:40 AM, Chris Mason<chris.mason@oracle.com>  wrote:
>> I think that filling all the devices fully is more important than the
>> initial spread.  Miao is correct that the administrator will
>> probably complain if all the devices aren't used for the initial stripes.
>> But, over the long term the admin does expect that if he gives us 350GB
>> of drives in any config, we find try our best to use all 350GB.  I'd
>> rather meet that expectation than worry about initial performance in a
>> mixed drive setup.
>
> There's no reason why you can't get optimal distribution from the
> start while still having complete usage.  And it's preferable to do
> that, so that you get optimal distribution even as you add capacity;
> otherwise front-loading the worst cases makes sure you run into them,
> even if the administrator would have added more disks before you
> needed to handle them.

I'm not sure I understand the scenario you have in mind correctly.
Are you talking of equally sized disks where you want to add more
disks the same size later on? Or do you have disks of uneven sizes
initially? If you describe the fictional setup we can figure out
how the algorithm reacts to it and how it might be improved.

The intention of this patch is to build a foundation that solidly
gives a near optimal utilization. After that, we can build on it
and add more sophisticated algorithms that can spread the data
right from the start if it's possible without sacrificing utilization.

