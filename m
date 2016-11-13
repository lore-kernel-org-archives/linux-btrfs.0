Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from kiara-balancer-1.wellbehavedsoftware.com ([138.201.134.108]:39822
        "EHLO kiara-balancer-1.wellbehavedsoftware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933161AbcKMMp6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 13 Nov 2016 07:45:58 -0500
Subject: Re: Announcing btrfs-dedupe
To: Saint Germain <saintger@gmail.com>, linux-btrfs@vger.kernel.org
References: <2855552b-714c-d1de-08f9-89153c293772@wellbehavedsoftware.com>
 <20161108233625.1eff15df@system>
From: James Pharaoh <james@wellbehavedsoftware.com>
Message-ID: <c764e360-0be5-989c-b4f4-b560f2c7cb69@wellbehavedsoftware.com>
Date: Sun, 13 Nov 2016 13:45:53 +0100
MIME-Version: 1.0
In-Reply-To: <20161108233625.1eff15df@system>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I've updated the BTRFS wiki here with all the new tools people have 
mentioned:

https://btrfs.wiki.kernel.org/index.php/Deduplication#Other_tools

Please let me know if anyone who does not have access to the wiki has 
any additions, updates or corrections to what I've written here.

James

On 08/11/16 23:36, Saint Germain wrote:
> On Sun, 6 Nov 2016 14:30:52 +0100, James Pharaoh
> <james@wellbehavedsoftware.com> wrote :
>
>> Hi all,
>>
>> I'm pleased to announce my btrfs deduplication utility, written in
>> Rust. This operates on whole files, is fast, and I believe
>> complements the existing utilities (duperemove, bedup), which exist
>> currently.
>>
>> Please visit the homepage for more information:
>>
>> http://btrfs-dedupe.com
>>
>
> Thanks for having shared your work.
> Please be aware of these other similar softwares:
> - jdupes: https://github.com/jbruchon/jdupes
> - rmlint: https://github.com/sahib/rmlint
> And of course fdupes.
>
> Some intesting points I have seen in them:
> - use xxhash to identify potential duplicates (huge speedup)
> - ability to deduplicate read-only snapshots
> - identify potential reflinked files (see also my email here:
>   https://www.spinics.net/lists/linux-btrfs/msg60081.html)
> - ability to filter out hardlinks
> - triangle problem: see jdupes readme
> - jdupes has started the process to be included in Debian
>
> I hope that will help and that you can share some codes with them !
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
