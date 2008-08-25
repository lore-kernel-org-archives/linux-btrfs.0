From: "Miguel Sousa Filipe" <miguel.filipe@gmail.com>
Subject: Re: Hi!
Date: Mon, 25 Aug 2008 22:56:50 +0100
Message-ID: <f058a9c30808251456h4b9df491o787f7305716008b1@mail.gmail.com>
References: <1219221805.15514.13.camel@telesto>
	 <1219256750.7854.7.camel@think.oraclecorp.com>
	 <f058a9c30808210347l3cd957f6lb518d884e479ad62@mail.gmail.com>
	 <200808240802.36586.slong@rathaus.eclipse.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: "Steve Long" <slong@rathaus.eclipse.co.uk>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <200808240802.36586.slong@rathaus.eclipse.co.uk>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Aug 24, 2008 at 8:02 AM, Steve Long <slong@rathaus.eclipse.co.uk> wrote:
> On Thursday 21 August 2008 11:47:03 Miguel Sousa Filipe wrote:
>> > Testing, discussing and reporting bugs are a great first step.
>>
>> One thing that I would like to see, is how btrfs behaves with eavy
>> uses of version control systems like:
>> - git
>> - hg
>>
>> big repos, greps, finds, and stuff like that.
>>
> How about kernel compiles (cf contest)? Perhaps with pull of the tree from
> cold cache or indeed several trees.

I believe Chris allready cover that workload in his tests.. but can't hurt. :D

>
> <snip good stuff>
>>    - DeviceKit.Disks support (the future is DeviceKit! :-p) ->
>
> Oh God does it have to be? Up to users what they install, but is it really the
> job of the fs to worry about a user layer on top of a lib on top of some
> other lib, one of which hasn't even got to 1.0 release, and whose author is
> apparently fine with changing everything around on distros (after all it
> hasn't got to 1.0..) but still insistent on how everyone else should be doing
> things? Not that it's anything to do with the FS, so why should we worry
> about it?
>
>>        -> http://hal.freedesktop.org/docs/DeviceKit/
>
> I couldn't find anything about "Disks", which may be down to my ignorance.
>
>>        -> http://lists.freedesktop.org/archives/hal/2008-May/011560.html
>>        ->
> *groan* "the way forward is the model where you have a policy-less privileged
> mechanism that can be controlled by an unprivileged GUI policy agent"
> Some of us quite like existing Unix permissions, especially on our 2 or 3 user
> desktops, and that kind of thing has been done, eg in mandriva, for quite a
> while now. Great if that's what people are happy with (personally I think
> scrapping dcop was a *huge* mistake) but I don't want it on my system any
> more than I _have_ to, to get apps to work (which is why I love Gentoo.)

even if I like the gentoo or openbsd way, that doesn't help having
good btrfs support on
all the other distros that use HAL or its descendants.

>
>> http://gitweb.freedesktop.org/?p=DeviceKit/DeviceKit.git;a=summary - grub
>> support for btrfs (read only..) :D
>
> Great, I see that's moving quickly, no code updates in 4 months. I'm guessing
> that's not because it's a stable and mature project that doesn't need any
> more work on it..
> Tell me again what this has to do with a FS in the kernel; are btrfs supposed
> to change their code in any way to work with DeviceKit?
>
> I agree with all the other stuff you posted, so please don't take my antipathy
> toward HAL and *Kit as criticism of you.

I share much of your opinions about hal and these new (leaky)
abstraction layers, but having a current/decent linux install without
all that hal stuff (with gnome or kde) is next to impossible.

My concearn is more of btrfs having equal support on those dandy
apps/layers, that will be used by fedora, ubuntu, opensuse, etc...
I want in a years time, have a "format with BTRFS" option on a regular
fedora/ubuntu install.



>
> Regards,
> steveL.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Miguel Sousa Filipe
