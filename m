Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:65499 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753551AbcBGKIB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 7 Feb 2016 05:08:01 -0500
Subject: Re: btrfs-progs and btrfs(8) inconsistencies
To: Anand Jain <anand.jain@oracle.com>, Moviuro <moviuro@gmail.com>,
        linux-btrfs@vger.kernel.org
References: <CAM=f9=V-7hbjGLzWUxbynsoJdP-NexEoaTJ3GJJxn3gBYsW1BA@mail.gmail.com>
 <56B412FC.8060007@oracle.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <56B71777.7050609@gmx.com>
Date: Sun, 7 Feb 2016 18:07:51 +0800
MIME-Version: 1.0
In-Reply-To: <56B412FC.8060007@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 02/05/2016 11:11 AM, Anand Jain wrote:
>
>
>   If you look critically we have been using UI/CLI as API,
>   IMO these two class of interfaces be distinct clearly.
>
>   Btrfs needs library functions/APIs which is callable in
>   popular scripting language like python.
>
> Thanks, Anand
>
+1 too.

But first in C, then python wrapper.

Not sure why there is no such libbtrfs for C wrapper of btrfs ioctls.

Maybe just because current btrfs ioctl is too easy to use?

AFAIK, systemd (container storage part) calls btrfs ioctl directly, 
especially for subvolume/snapshot creation mainly because the design of 
them are quite easy.

Thanks,
Qu

>
> On 02/04/2016 05:54 AM, Moviuro wrote:
>> Hi all,
>>
>> I should have done this a long time ago, so here goes.
>>
>> Btrfs is certainly the best FS out there but btrfs(8) is a pain to use in
>> scripts. That is, it talks way too much, exposes unparseable outputs and
>> has inconsistent behavior.
>>
>> I strongly believe that the CLI may use a complete revamp, that is: think
>> of the needed/wanted output. I actually ran into this frustrating
>> behavior
>> while writing butter (https://github.com/moviuro/butter).
>>
>> Eg: # btrfs subvolume create foo
>> Should be silent. I don't want btrfs(8) to bug me about successful
>> commands. Everything that is a success is silent. In its current form,
>> btrfs-subvolume(8) would spat out a complete sentence in English that we
>> don't need, which however contains a tiny bit of useful info: the path
>> (though relative) to the new subvolume. A -v/--verbose option might be
>> here
>> a good idea to implement and the following behavior (just thinking out
>> loud, I'm sure there would be lots of things to think about more
>> precisely):
>>
>> # btrfs subvolume create foo # should be silent
>> # btrfs subvolume create -v foo
>> /absolute/path/foo
>> # btrfs subvolume create [--details|-vv] foo
>> PATH:/absolute/path/foo
>> UUID:082df386-98c2-44d9-9012-07fb2b22ea20
>> [And whatnot]
>>
>> That's a first example. Same should go for all the commands. I have no
>> idea
>> how/where we could share about good/bad outputs (Google Drive? Framapad?
>> git[hub|lab]?)
>>
>> Then come inconsistencies: compare the outputs of
>> # btrfs sub create foo
>> # btrfs sub delete foo
>>
>> This also needs to be taken care of, but it should be a by-product of
>> thinking the outputs all over again.
>>
>> Behavior inconsistencies: some seemingly valid commands fail, because of
>> some code that can be easily changed (I'm working on it in my spare time
>> already, see https://github.com/moviuro/btrfs-progs/tree/getopts):
>>
>> The valid '--' doesn't work on every command, see
>> 0aa796cad7ed3fce9d5964646a8f1f5a142b4989 here:
>> https://github.com/kdave/btrfs-progs/commit/0aa796cad7ed3fce9d5964646a8f1f5a142b4989
>>
>>
>>
>> That's it. And since AFAICT btrfs is FLOSS, I'm sharing about my
>> experience
>> as user and hope my opinion will change btrfs(8) for the better.
>>
>> Cheers,
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
