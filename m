Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from wnls-smtp1.wa.co.za ([41.185.62.206]:59607 "EHLO
	wnls-smtp1.wa.co.za" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593Ab2L0W2r (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Dec 2012 17:28:47 -0500
Message-ID: <50DCCB85.9050309@swiftspirit.co.za>
Date: Fri, 28 Dec 2012 00:28:21 +0200
From: Brendan Hide <brendan@swiftspirit.co.za>
MIME-Version: 1.0
To: kreijack@inwind.it
CC: Goffredo Baroncelli <kreijack@gmail.com>,
        linux-btrfs Mailing list <linux-btrfs@vger.kernel.org>,
        Chris Mason <chris.mason@fusionio.com>
Subject: Re: btrfs df confusion
References: <50DC3807.9080605@swiftspirit.co.za> <50DC7F80.4060409@gmail.com>
In-Reply-To: <50DC7F80.4060409@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks, duplicate effort averted :)

On 2012/12/27 07:04 PM, Goffredo Baroncelli wrote:
> On 12/27/2012 12:59 PM, Brendan Hide wrote:
>> Hi
> Hi,
>
>> I've made some updates on the wiki and I'd like a technical review for
>> correctness. This particular topic is already confusing - some
>> unnecessary sarcasm made it even more so:
>> https://btrfs.wiki.kernel.org/index.php/FAQ#Why_does_df_show_incorrect_free_space_for_my_RAID_volume.3F
> I posted some patches in order to address this issue. However these
> aren't integrated (yet). At the end I think that I reached a general
> consensus about the wording. A general description is here [1]. The
> patch related to man page is here [2], which can help about the wording.
>
> I hope that it will help your work.
>
> BR
> G.Baroncelli
>
>
>>
>> Due to the terms "used" and "allocated" in the wiki, viric in #btrfs
>> made the good suggestion that we could adjust the show and df output
>> with more intuitive language:
>>
>> Before I git a patch together, please let me know if there are any good
>> reasons why we wouldn't want to make such a change.
>>
>> (13:31:29) viric: zatricky: "devid ... used" are allocated data, while
>> "FS bytes used" is the sum of used bytes, isn't it?
>> (13:33:28) zatricky: viric: correct
>> (13:33:52) viric: zatricky: maybe the devid lines could be changed
>> s/used/allocated/
>> (13:34:37) zatricky: viric: that's a good idea - would make it more
>> intuitive
>> (13:35:29) viric: the same way, 'btrfs fi df' could change
>> s/total/allocated
>> ^ GMT+2 ;)
>>
>> Thanks
>>
> [1] http://permalink.gmane.org/gmane.comp.file-systems.btrfs/21071
> [2]
> http://markmail.org/thread/nol2gcjky4cxndhv#query:+page:1+mid:xqnyqp7slb7rrach+state:results
>


-- 
Brendan Hide

083 448 3867
http://swiftspirit.co.za/

