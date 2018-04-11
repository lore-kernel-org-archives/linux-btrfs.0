Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59248 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756906AbeDKTnJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 11 Apr 2018 15:43:09 -0400
Subject: Re: [PATCH v2] btrfs-progs: dump-super: Refactor print function and
 add extra check
To: kreijack@inwind.it, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20180409091934.5429-1-wqu@suse.com>
 <9ca6c0f7-5bfb-6f9d-1882-f76619330e22@libero.it>
 <84880c72-3f76-99c8-6204-562ca4cee0a7@gmx.com>
 <2d59d411-d6a3-ed57-d087-63cefc7abf7f@inwind.it>
 <a3fa515e-263d-8466-29b8-542974a06b2d@gmx.com>
 <1b5512e9-8422-e520-63b4-401cb6cba8ba@inwind.it>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <10abf73e-7f27-e684-3f6a-9eda0f3b68ed@suse.com>
Date: Wed, 11 Apr 2018 22:43:05 +0300
MIME-Version: 1.0
In-Reply-To: <1b5512e9-8422-e520-63b4-401cb6cba8ba@inwind.it>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 11.04.2018 20:15, Goffredo Baroncelli wrote:
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
> I don't understand your statement: does the alignment is the same for all the system ?. If not, this means that a filesystem created on a x86 might not work on a PPC64 (which IIRC is a 64k page hardware) ?
> 

That is true, since btrfs doesn't support subpage blocksizes you cannot
mount an fs created on a system with pagesize A, on a system with
pagesize B.
