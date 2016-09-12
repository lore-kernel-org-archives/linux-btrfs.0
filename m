Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from nmsh1.e.nsc.no ([193.213.121.72]:49111 "EHLO nmsh1.e.nsc.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752736AbcILUsq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Sep 2016 16:48:46 -0400
Subject: Re: Is stability a joke? (wiki updated)
To: =?UTF-8?B?UGFzaSBLw6Rya2vDpGluZW4=?= <pasik@iki.fi>,
        Martin Steigerwald <martin@lichtvoll.de>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <57D51BF9.2010907@online.no>
 <20160912142714.GE16983@twin.jikos.cz> <20160912162747.GF16983@twin.jikos.cz>
 <6762481.5JxuKd9axT@merkaba> <20160912202109.GL28465@reaktio.net>
From: Waxhead <waxhead@online.no>
Message-ID: <57D714A2.5040904@online.no>
Date: Mon, 12 Sep 2016 22:48:34 +0200
MIME-Version: 1.0
In-Reply-To: <20160912202109.GL28465@reaktio.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Pasi Kärkkäinen wrote:
> On Mon, Sep 12, 2016 at 09:57:17PM +0200, Martin Steigerwald wrote:
>>
>> Great.
>>
>> I made to minor adaption. I added a link to the Status page to my warning in
>> before the kernel log by feature page. And I also mentioned that at the time
>> the page was last updated the latest kernel version was 4.7. Yes, thats some
>> extra work to update the kernel version, but I think its beneficial to
>> explicitely mention the kernel version the page talks about. Everyone who
>> updates the page can update the version within a second.
>>
> Hmm.. that will still leave people wondering "but I'm running Linux 4.4, not 4.7, I wonder what the status of feature X is.."
>
> Should we also add a column for kernel version, so we can add "feature X is known to be OK on Linux 3.18 and later"..  ?
> Or add those to "notes" field, where applicable?
>
>
> -- Pasi
>
I think a separate column would be the best solution. For example 
archiving the status page pr. kernel version (as I suggested) will lead 
to issues too. For example if something appears to be just fine in 4.6 
is found to be horribly broken in for example 4.10 the archive would 
still indicate that it WAS ok at that time even if it perhaps was not. 
Then you have regressions - something that worked in 4.4 may not work in 
4.9, but I still think the best idea is to simply label the status as ok 
/ broken since 4.x as those who really want to use a broken feature 
probably would to research to see if this used to work , besides if 
something that used to work goes haywire it should be fixed quickly :)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>

