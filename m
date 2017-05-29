Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-34.italiaonline.it ([212.48.25.162]:33285 "EHLO libero.it"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750947AbdE2Qw5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 29 May 2017 12:52:57 -0400
Reply-To: kreijack@inwind.it
Subject: Re: [PATCH v4 00/20] Btrfs-progs offline scrub
References: <20170525062205.11660-1-quwenruo@cn.fujitsu.com>
 <e4e15f16-c6b7-a18a-57df-7f404d38107b@inwind.it>
 <ee9f0a45-bd92-e534-c98f-a9bb398e10f2@cn.fujitsu.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, lakshmipathi.g@gmail.com
From: Goffredo Baroncelli <kreijack@inwind.it>
Message-ID: <8f06d043-6b53-57f9-adb6-bf949501e8a3@inwind.it>
Date: Mon, 29 May 2017 18:52:54 +0200
MIME-Version: 1.0
In-Reply-To: <ee9f0a45-bd92-e534-c98f-a9bb398e10f2@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-05-29 02:21, Qu Wenruo wrote:
> 
> 
> At 05/27/2017 02:37 AM, Goffredo Baroncelli wrote:
>> Hi Qu,
>>
>> On 2017-05-25 08:21, Qu Wenruo wrote:
>>
>>> And since kernel scrub won't account P/Q corruption, it makes us quite
>>> hard to detect error like kernel screwing up P/Q when scrubbing.
>>
>> could you elaborate the above sentence: in my test the kernel-scrub (4.12.0-rc2) is able to correct a wrong 'P' parity; am I missing something ?
> 
> That's because Liu Bo and I exposed and fixed the bug.
> 
> Or the case will still be the same.
> 
> Thanks,
> Qu
Ok, thank for your clarification.
BR
G.Baroncelli

> 
>>
>> BR
>> G.Baroncelli
>> [...]
>>
> 
> 
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
