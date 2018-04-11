Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:54916 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751734AbeDKXV1 (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Wed, 11 Apr 2018 19:21:27 -0400
Subject: Re: [PATCH v2] btrfs-progs: dump-super: Refactor print function and
 add extra check
To: kreijack@inwind.it, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        linux-btrfs@vger.kernel.org
References: <20180409091934.5429-1-wqu@suse.com>
 <9ca6c0f7-5bfb-6f9d-1882-f76619330e22@libero.it>
 <84880c72-3f76-99c8-6204-562ca4cee0a7@gmx.com>
 <2d59d411-d6a3-ed57-d087-63cefc7abf7f@inwind.it>
 <a3fa515e-263d-8466-29b8-542974a06b2d@gmx.com>
 <1b5512e9-8422-e520-63b4-401cb6cba8ba@inwind.it>
From: Qu Wenruo <wqu@suse.com>
Message-ID: <d3a54207-83a4-76a1-b564-8c373f5b739b@suse.com>
Date: Thu, 12 Apr 2018 07:21:10 +0800
MIME-Version: 1.0
In-Reply-To: <1b5512e9-8422-e520-63b4-401cb6cba8ba@inwind.it>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2018年04月12日 01:15, Goffredo Baroncelli wrote:
> On 04/11/2018 02:32 AM, Qu Wenruo wrote:
> [...]
>>>>> so to get rid  of generate_tab_indent and indent_str
>>>>
>>>> And we need to call such functions in each helper macros, with
>>>> duplicated codes.
>>>
>>> Please look at the asm generated: even if the "source generated" by the expansion of the macro is bigger, the binary code is smaller.
>>> E.g. the code below 
>>
>> No, I don't mean asm code, but C code.
> 
> May be that there is some misunderstanding: my code is about 20loc, your one is about 50loc... I am missing something ?

Loc is not the core factor, it's duplicated code.

> 
> [...]
>>>> When passing random stream to dump-super, such reason will make output
>>>> quite nasty.
>>>> So just INVALID to info the user that some of the members don't look
>>>> valid is good enough, as the tool is only to help guys who are going to
>>>> manually patching superblocks.
>>>
>>> I think that we should increase the possible target also to who want to make some debugging :-)
>>
>> There are several problems here to output the condition
>>
>> 1) Loose condition
>> for basic alignment check it may looks good to output the condition, but
>> the fact is, the condition is not 100% correct for 64K pages system.
>> So when output IS_ALIGN(value, SZ_4K), it's not 100% correct.
> 
> I don't understand your statement: does the alignment is the same for all the system ?.

As already mentioned by Nikolay, no.

> If not, this means that a filesystem created on a x86 might not work on a PPC64 (which IIRC is a 64k page hardware) ?

Yep, btrfs created on x86 will not work on any 64K page size system, and
vice verse.

IBM guy is working on such sub-page size support to allow PPC64 to mount
4K sector size btrfs, but I didn't see their update for a long time.

> 
> 
>>
>> 2) Too long condition for some case.
>> !(is_power_of_2(value) && value >= SZ_4K && value <= SZ_64K)
>> This seems pretty strange in fact.
> 
> I agree that this is quite verbose... however if this is the constraint, why not print it

Because when it's invalid, the constraint doesn't help much for
developer/user to patch the value.

Thanks,
Qu

> 
>>
>> 3) C macro usage
>>    Just a minor problem, macro usage such as SZ_4K/SZ_64K may not looks
>>    good for new developers.
> 
> I find it quite clear and intuitive even if this is the first time that I notice these macros
> 
> [...]
>>
>> Thanks,
>> Qu
> BR
> G.Baroncelli
> 
