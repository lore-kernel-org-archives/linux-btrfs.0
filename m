From: david@lang.hm
Subject: Re: Mis-Design of Btrfs?
Date: Fri, 15 Jul 2011 09:03:39 -0700 (PDT)
Message-ID: <alpine.DEB.2.02.1107150900110.3745@asgard.lang.hm>
References: <20110623105337.GD3753@ethz.ch> <20110627164637.377314e2@notabene.brown> <4E0AF091.9030301@redhat.com> <20110714155620.6e9ac2cc@notabene.brown> <4E1E866E.2050405@redhat.com> <20110714163836.35a729c1@notabene.brown> <4E1E9372.3030208@redhat.com>
 <1310696606-sup-710@shiny> <alpine.DEB.2.02.1107142149420.3558@asgard.lang.hm> <20110715163354.74fa2083@notabene.brown>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Chris Mason <chris.mason@oracle.com>,
	Ric Wheeler <rwheeler@redhat.com>,
	Nico Schottelius <nico-lkml-20110623@schottelius.org>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Alasdair G Kergon <agk@redhat.com>
To: NeilBrown <neilb@suse.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110715163354.74fa2083@notabene.brown>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 15 Jul 2011, NeilBrown wrote:

> On Thu, 14 Jul 2011 21:58:46 -0700 (PDT) david@lang.hm wrote:
>
>> On Thu, 14 Jul 2011, Chris Mason wrote:
>>
>>> Excerpts from Ric Wheeler's message of 2011-07-14 02:57:54 -0400:
>>>> On 07/14/2011 07:38 AM, NeilBrown wrote:
>>>>> On Thu, 14 Jul 2011 07:02:22 +0100 Ric Wheeler<rwheeler@redhat.com>  wrote:
>>>>>
>>
>> I would suggest that each layer take the value it's give, do an integer
>> division by the number of values that layer supports, using the modulo
>> value for that layer and pass the rest of the result down to the next
>> layer.
>
> I, on the other hand, would suggest that each layer be given the freedom, and
> the responsibility, to do whatever it thinks is most appropriate.
>
> This would probably involved checking the lower levels to see how many
> strategies each has, and doing some appropriate arithmetic depending on how
> it combines those devices.

nothing is wrong with doing something smarter than what I was proposing, I 
was just intending to propose a default rule that would work (just about) 
everywhere. I was specifically trying to counter the throught hat the 
method number would/should be contant as it's passed down the layers.

The proposal had been made to have each layer do the retries for the layer 
below it, that would avoid this stacking problem, but at the cost of 
potentially doing a LOT of retries without the upper level being able to 
limit it.

David Lang

> One problem here is the assumption that the lower levels don't change, and we
> know that not to be the case.
> However this is already a problem.  It is entirely possible that the request
> size parameters of devices can change at any moment, even while a request is
> in-flight ... though we try to avoid that or work around it.
>
> The sort of dependencies that we see forming here would probably just make
> the problem worse.
>
> Not sure what to do about it though.... maybe just hope it isn't a problem.
>
> NeilBrown
>
>
>>
>> this works for just trying values until you get the error that tells you
>> there are no more options.
>>
>>
>> things can get very 'intersesting' if the different options below you have
>> different number of options (say a raid1 across a raid5 and a single disk)
>> but I can't think of any good way to figure this out and assemble a
>> sane order without doing an exaustive search down to find the number of
>> options for each layer (and since this can be different for different
>> blocks, you would have to do this each time you invoked this option)
>>
>> David Lang
>
>
