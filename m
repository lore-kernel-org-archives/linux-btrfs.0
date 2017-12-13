Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49497 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750751AbdLMHSP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 13 Dec 2017 02:18:15 -0500
Subject: Re: [PATCH] btrfs: Remove pair of bio_get/put in btrfs_schedule_bio
To: bo.li.liu@oracle.com, dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <1513003128-15489-1-git-send-email-nborisov@suse.com>
 <20171211225756.GA6827@lim.localdomain> <20171212185238.GR3553@twin.jikos.cz>
 <20171212220944.GA19371@lim.localdomain>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <f57db38f-02e0-9f10-d040-b2c60320439c@suse.com>
Date: Wed, 13 Dec 2017 09:18:12 +0200
MIME-Version: 1.0
In-Reply-To: <20171212220944.GA19371@lim.localdomain>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 13.12.2017 00:09, Liu Bo wrote:
> On Tue, Dec 12, 2017 at 07:52:38PM +0100, David Sterba wrote:
>> On Mon, Dec 11, 2017 at 02:57:56PM -0800, Liu Bo wrote:
>>> On Mon, Dec 11, 2017 at 04:38:48PM +0200, Nikolay Borisov wrote:
>>>> This code was added in 492bb6deee34 ("Btrfs: Hold a reference on bios
>>>> during submit_bio, add some extra bio checks"). However, holding a
>>>> reference on a bio is necessary only if it's going to be referenced
>>>> after the submit_bio returns and the bio is completed. In this
>>>> particular instance this is not the case so there is no need to hold
>>>> an extra reference since we directly return.
>>>>
>>>
>>> Looks good.  If possible, please also drop other unnecessary bio_get()
>>> in btrfs.
>>
>> You mean everywhere with similar context like in this patch?
>>
> 
> Right, there're several places where bio_get() is put before running
> functions but bio_put() is also put immediately without referencing
> bio.

I've already created patches for those and put them through fstests.
Will send them later

> 
> thanks,
> -liubo
> 
