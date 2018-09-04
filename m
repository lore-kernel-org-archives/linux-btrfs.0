Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51050 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726507AbeIDWtO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 4 Sep 2018 18:49:14 -0400
Subject: Re: [PATCH 12/35] btrfs: add ALLOC_CHUNK_FORCE to the flushing code
To: Josef Bacik <josef@toxicpanda.com>
Cc: linux-btrfs@vger.kernel.org
References: <20180830174225.2200-1-josef@toxicpanda.com>
 <20180830174225.2200-13-josef@toxicpanda.com>
 <c7905ccc-ba8c-fe9d-e6b7-fa44443a8984@suse.com>
 <20180904175755.3wyvm6psdsjgom4k@destiny>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <d7daa0e0-b54c-499a-c486-6b295867d938@suse.com>
Date: Tue, 4 Sep 2018 21:22:54 +0300
MIME-Version: 1.0
In-Reply-To: <20180904175755.3wyvm6psdsjgom4k@destiny>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On  4.09.2018 20:57, Josef Bacik wrote:
> On Mon, Sep 03, 2018 at 05:19:19PM +0300, Nikolay Borisov wrote:
>>
>>
>> On 30.08.2018 20:42, Josef Bacik wrote:
>>> +		if (flush_state == ALLOC_CHUNK_FORCE && !commit_cycles)
>>> +			flush_state++;
>>
>> This is a bit obscure. So if we allocated a chunk and !commit_cycles
>> just break from the loop? What's the reasoning behind this ?
> 
> I'll add a comment, but it doesn't break the loop, it just goes to COMMIT_TRANS.
> The idea is we don't want to force a chunk allocation if we're experiencing a
> little bit of pressure, because we could end up with a drive full of empty
> metadata chunks.  We want to try committing the transaction first, and then if
> we still have issues we can force a chunk allocation.  Thanks,

I think it will be better if this check is moved up somewhere before the
the if (flush_state > commit trans).

> 
> Josef
> 
