Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:56058 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752827AbeFTAVv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Jun 2018 20:21:51 -0400
Subject: Re: About more loose parameter sequence requirement
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, dsterba@suse.cz,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <dbd36f90-fb00-0da1-b38f-567575c5b02f@gmx.com>
 <20180618113432.GJ24375@twin.jikos.cz>
 <f746bf72-148d-9fc3-6d0d-c7e07f00c099@gmx.com>
 <20180618120200.GK24375@twin.jikos.cz>
 <48a89b08-3859-e635-1da2-ce7c9e842d8a@gmx.com>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <25cb6b53-758e-6ca2-4cc1-13b31e06e4ee@mendix.com>
Date: Wed, 20 Jun 2018 02:21:49 +0200
MIME-Version: 1.0
In-Reply-To: <48a89b08-3859-e635-1da2-ce7c9e842d8a@gmx.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/18/2018 03:05 PM, Qu Wenruo wrote:
> 
> 
> On 2018年06月18日 20:02, David Sterba wrote:
>> On Mon, Jun 18, 2018 at 07:40:44PM +0800, Qu Wenruo wrote:
>>>
>>>
>>> On 2018年06月18日 19:34, David Sterba wrote:
>>>> On Thu, Jun 14, 2018 at 03:17:45PM +0800, Qu Wenruo wrote:
>>>>> I understand that btrfs-progs introduced restrict parameter/option order
>>>>> to distinguish global and sub-command parameter/option.
>>>>>
>>>>> However it's really annoying if one just want to append some new options
>>>>> to previous command:
>>>>>
>>>>> E.g.
>>>>> # btrfs check /dev/data/btrfs
>>>>> # !! --check-data-csum
>>>>>
>>>>> The last command will fail as current btrfs-progs doesn't allow any
>>>>> option after parameter.
>>>>>
>>>>>
>>>>> Despite the requirement to distinguish global and subcommand
>>>>> option/parameter, is there any other requirement for such restrict
>>>>> option-first-parameter-last policy?
>>>>
>>>> I'd say that it's a common and recommended pattern. Getopt is able to
>>>> reorder the parameters so mixed options and non-options are accepted,
>>>> unless POSIXLY_CORRECT (see man getopt(3)) is not set. With the more
>>>> strict requirement, 'btrfs' option parser works the same regardless of
>>>> that.
>>>
>>> But currently it doesn't work.
>>> Just as the example, btrfs check /dev/data/btrfs --check-data-sum won't
>>> work.
>>> It's different from a lot of other common programs.
>>
>> With POSIXLY_CORRECT set, it expectedly won't work. With POSIXLY_CORRECT
>> unset, it would work in general, but not for 'btrfs'.
>>
>> As this is per-application decision I find it ok, besides that I also
>> find the 'options anywhere' pattern bad. Does it really save you that
>> much time while typing the commands with new arguments?
> 
> Personally speaking, yes.
> 
>> There are
>> movement shortcuts to jump by words, you get the previous command by
>> up-arrow. About the same number of keystrokes.
> 
> Not really, normally just "!! <new options>", where I don't even need to
> move my fingers to arrow keys.
> (I'm all ears about extra bash shortcuts on this)

It's called `set -o vi` ;-]

If you remap capslock to be escape, there's not much moving around of
fingers going on. CAPS-k-b-b-a and type your new option. No reaching to
shift and 1 necessary at all.

:]

>>
>> New code needs to be tested, documented and maintained, that's the cost
>> I find too high for something that's convenience for people who are used
>> to some shell builtins.
> 
> The biggest problem is, the behavior isn't even consistent across
> btrfs-progs.
> mkfs.btrfs accept such out-of-order parameters while btrfs not.
> 
> And most common tools, like commands provided by coretutil, they don't
> care about the order.
> The only daily exception is 'scp', which I found it pretty unhandy.
> 
> And just as Paul and Hugo, I think there are quite some users preferring
> out-of-order parameter/options.
> 
> 
> I also understand the maintenance burden, but at least let's try if
> there are better solution for this.
> 
> Thanks,
> Qu
> 


-- 
Hans van Kranenburg
