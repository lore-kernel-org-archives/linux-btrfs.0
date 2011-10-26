From: Arne Jansen <sensille@gmx.net>
Subject: Re: [patch] Move nodesize/leafsize/sectorsize to fs_info
Date: Wed, 26 Oct 2011 22:54:10 +0200
Message-ID: <4EA87372.5050006@gmx.net>
References: <CAKyAS7s1Xm3L_1QwptAKs61e0bc4s4z7k8jWo4SiujQFMSss0g@mail.gmail.com> <20111026133409.GA5914@twin.jikos.cz> <4EA81D73.8090005@gmx.net> <20111026162338.GD5914@twin.jikos.cz> <20111026162719.GC5177@shiny.Mikenopa.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: Chris Mason <chris.mason@oracle.com>,
	Peeters Simon <peeters.simon@gmail.com>,
	linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111026162719.GC5177@shiny.Mikenopa.local>
List-ID: <linux-btrfs.vger.kernel.org>

On 10/26/2011 06:27 PM, Chris Mason wrote:
> On Wed, Oct 26, 2011 at 06:23:38PM +0200, David Sterba wrote:
>> On Wed, Oct 26, 2011 at 04:47:15PM +0200, Arne Jansen wrote:
>>> The sizes get initialized to 4096, but after the super block is read,
>>> these are replaced by those from the SB.
>>
>> [reads sources again] right, and the initial values are not used up to
>> that point, so 4096 could be any number.
>>
>>> It was indeed meant to get rid of the possibility to have different
>>> sizes for different trees, as it just adds complexity. Chris mentioned
>>> once that he does not intend to allow different sizes between trees,
>>> thus the idea for this cleanup.
>>
>> Ok then. I'll gather it to cleanup patch queue.
>
> Thanks, I actually don't intend to allow different leaf and node sizes
> anymore either, but we might as well keep both numbers.

So that would be another good cleanup, as it is not always easy to tell
if a block is a node or a leaf. It would actually simplify things.

-Arne

>
> -chris
>
