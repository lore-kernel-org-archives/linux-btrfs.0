Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:42557 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S964844AbcBDBdR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Feb 2016 20:33:17 -0500
Subject: Re: btrfs-progs and btrfs(8) inconsistencies
To: Moviuro <moviuro@gmail.com>, <linux-btrfs@vger.kernel.org>
References: <CAM=f9=V-7hbjGLzWUxbynsoJdP-NexEoaTJ3GJJxn3gBYsW1BA@mail.gmail.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <56B2AA51.80908@cn.fujitsu.com>
Date: Thu, 4 Feb 2016 09:33:05 +0800
MIME-Version: 1.0
In-Reply-To: <CAM=f9=V-7hbjGLzWUxbynsoJdP-NexEoaTJ3GJJxn3gBYsW1BA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Moviuro wrote on 2016/02/03 22:54 +0100:
> Hi all,
>
> I should have done this a long time ago, so here goes.
>
> Btrfs is certainly the best FS out there but btrfs(8) is a pain to use in
> scripts. That is, it talks way too much, exposes unparseable outputs and
> has inconsistent behavior.
>
> I strongly believe that the CLI may use a complete revamp, that is: think
> of the needed/wanted output. I actually ran into this frustrating behavior
> while writing butter (https://github.com/moviuro/butter).
>
> Eg: # btrfs subvolume create foo
> Should be silent. I don't want btrfs(8) to bug me about successful
> commands. Everything that is a success is silent. In its current form,
> btrfs-subvolume(8) would spat out a complete sentence in English that we
> don't need, which however contains a tiny bit of useful info: the path
> (though relative) to the new subvolume. A -v/--verbose option might be here
> a good idea to implement and the following behavior (just thinking out
> loud, I'm sure there would be lots of things to think about more precisely):
>
> # btrfs subvolume create foo # should be silent
> # btrfs subvolume create -v foo
> /absolute/path/foo
> # btrfs subvolume create [--details|-vv] foo
> PATH:/absolute/path/foo
> UUID:082df386-98c2-44d9-9012-07fb2b22ea20
> [And whatnot]

The idea itself makes a lot of sense.
But I have at least two things to worry about:

1) Old scripts backward compatibility
    Especially xfstests. Maintainer will hate it a lot.
    As we have changed it several times and broken existing test cases.

    Although personally I like to let all the backward compatibility
    things go hell, but that's definitely not how things work. :(

2) End-user taste.
    Some end-users like such info as feedback of success.
    Of course other users like it act as silent as possible.

>
> That's a first example. Same should go for all the commands. I have no idea
> how/where we could share about good/bad outputs (Google Drive? Framapad?
> git[hub|lab]?)

Maybe it's overkilling, but I like the idea to have a good example about 
how CLI interface should be designed.
But it may be harder for all developer/reviewer to follow that restrict 
example.

And even more, I hope there will be a nice btrfs-progs CLI design 
guideline. (Although it's surely overkilling)

Thanks,
Qu

>
> Then come inconsistencies: compare the outputs of
> # btrfs sub create foo
> # btrfs sub delete foo
>
> This also needs to be taken care of, but it should be a by-product of
> thinking the outputs all over again.
>
> Behavior inconsistencies: some seemingly valid commands fail, because of
> some code that can be easily changed (I'm working on it in my spare time
> already, see https://github.com/moviuro/btrfs-progs/tree/getopts):
>
> The valid '--' doesn't work on every command, see
> 0aa796cad7ed3fce9d5964646a8f1f5a142b4989 here:
> https://github.com/kdave/btrfs-progs/commit/0aa796cad7ed3fce9d5964646a8f1f5a142b4989
>
>
> That's it. And since AFAICT btrfs is FLOSS, I'm sharing about my experience
> as user and hope my opinion will change btrfs(8) for the better.
>
> Cheers,
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>


