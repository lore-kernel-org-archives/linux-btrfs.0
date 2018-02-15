Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-dm3nam03on0055.outbound.protection.outlook.com ([104.47.41.55]:7336
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1423598AbeBOQ6r (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Feb 2018 11:58:47 -0500
Subject: Re: Status of FST and mount times
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>, linux-btrfs@vger.kernel.org
References: <4d705301-c3a1-baaa-3eb8-f7b92f12f505@panasas.com>
 <pan$1e47d$b81e6870$8ea78200$5b24ec4@cox.net>
 <a344bfd4-51c3-334a-1f79-7ffe9e875128@panasas.com>
 <77826af0-594a-01c9-35fa-1511364f0489@gmail.com>
From: "Ellis H. Wilson III" <ellisw@panasas.com>
Message-ID: <39aa2851-2c0a-d6c4-6ccf-d364c4aacbf4@panasas.com>
Date: Thu, 15 Feb 2018 11:58:36 -0500
MIME-Version: 1.0
In-Reply-To: <77826af0-594a-01c9-35fa-1511364f0489@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02/15/2018 11:51 AM, Austin S. Hemmelgarn wrote:
> There are scaling performance issues with directory listings on BTRFS 
> for directories with more than a few thousand files, but they're not 
> well documented (most people don't hit them because most applications 
> are designed around the expectation that directory listings will be slow 
> in big directories), and I would not expect them to be much of an issue 
> unless you're dealing with tens of thousands of files and particularly 
> slow storage.

Understood -- thanks.  Then plan is to keep it to around 1k entries per 
directory.  We've done some fairly concrete testing here to find the 
fall-off point for dirent caching in BTRFS, and the sweet-spot between 
having a large number of small directories cached vs. a few massive 
directories cached.  ~1k seems most palatable for our use-case and 
directory tree structure.

> I've only ever lost a BTRFS volume to a power failure _once_ in the 
> multiple years I've been using it, and that ended up being because the 
> power failure trashed the storage device pretty severely (it was 
> super-cheap flash storage).  I do know however that there are people who 
> have had much worse results than me.

Good to know.  We'll be running power-fail testing over the next couple 
months.  I'm waiting for some hardware to arrive presently.  We'll 
power-cycle fairly large filesystems a few thousand times before we deem 
it safe to ship.  If there are latent bugs in BTRFS still w.r.t. 
power-fail, I can guarantee we'll trip over them...

> It's not exactly a 'general sense' or a hunch, issues with BTRFS on SMR 
> drives have been pretty well demonstrated in practice, hence Duncan 
> making this statement despite the fact that it most likely did not apply 
> to you.

Ah, ok, thanks for clarifying.  I appreciate the forewarning regardless.

Best,

ellis
