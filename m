Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-34.italiaonline.it ([212.48.25.162]:47053 "EHLO libero.it"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752194AbdBHTKf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 8 Feb 2017 14:10:35 -0500
Reply-To: kreijack@inwind.it
Subject: Re: BTRFS for OLTP Databases
References: <CA+RUij3aW1ZYyJPNRLzckwOCCmoWa15Eu4h142jB_-qKc49hBw@mail.gmail.com>
 <20170207140058.GA4249@carfax.org.uk>
 <CA+RUij02VMTa-L59AD9B3G+g_dS3HO7-Ttsz-qWgJtMyf58sPQ@mail.gmail.com>
 <20170207213614.5fd40981@jupiter.sol.kaishome.de>
 <7c1a67ce-a62c-36e1-d228-9a1e15e4d16c@gmail.com>
 <7204f2cf-bcb4-c943-b6d2-f9eb4b5b29cf@bouton.name>
 <20170207223538.3c37c840@jupiter.sol.kaishome.de>
To: Kai Krakow <hurikhan77@gmail.com>, linux-btrfs@vger.kernel.org
From: Goffredo Baroncelli <kreijack@inwind.it>
Message-ID: <2786041b-aab0-3fed-1044-1aeae8871a4b@inwind.it>
Date: Wed, 8 Feb 2017 20:08:17 +0100
MIME-Version: 1.0
In-Reply-To: <20170207223538.3c37c840@jupiter.sol.kaishome.de>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-02-07 22:35, Kai Krakow wrote:
[...]
>>
>> Atomicity can be a relative term. If the snapshot atomicity is
>> relative to barriers but not relative to individual writes between
>> barriers then AFAICT it's fine because the filesystem doesn't make
>> any promise it won't keep even in the context of its snapshots.
>> Consider a power loss : the filesystems atomicity guarantees can't go
>> beyond what the hardware guarantees which means not all current in fly
>> write will reach the disk and partial writes can happen. Modern
>> filesystems will remain consistent though and if an application using
>> them makes uses of f*sync it can provide its own guarantees too. The
>> same should apply to snapshots : all the writes in fly can complete or
>> not on disk before the snapshot what matters is that both the snapshot
>> and these writes will be completed after the next barrier (and any
>> robust application will ignore all the in fly writes it finds in the
>> snapshot if they were part of a batch that should be atomically
>> commited).
>>
>> This is why AFAIK PostgreSQL or MySQL with their default ACID
>> compliant configuration will recover from a BTRFS snapshot in the
>> same way they recover from a power loss.
> 
> This is what I meant in my other reply. But this is also why it should
> be documented. Wrongly implying that snapshots are single point in time
> snapshots is a wrong assumption with possibly horrible side effects one
> wouldn't expect.

I don't understand what are you saying. 
Until now, my understanding was that "all the writings which were passed to btrfs before the snapshot time are in the snapshot. The ones after not".
Am I wrong ? Which are the others possible interpretations ?


[..]

-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
