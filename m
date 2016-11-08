Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from kiara-balancer-1.wellbehavedsoftware.com ([138.201.134.108]:42732
        "EHLO kiara-balancer-1.wellbehavedsoftware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753284AbcKHLix (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 8 Nov 2016 06:38:53 -0500
Subject: Re: Announcing btrfs-dedupe
To: =?UTF-8?Q?Niccol=c3=b2_Belli?= <darkbasic@linuxsystems.it>
References: <2855552b-714c-d1de-08f9-89153c293772@wellbehavedsoftware.com>
 <e9a425e6-0f1a-42ca-8200-1cad1193f048@linuxsystems.it>
Cc: linux-btrfs@vger.kernel.org
From: James Pharaoh <james@wellbehavedsoftware.com>
Message-ID: <7c1d65d8-3a95-1a1b-761f-8d765ed4e3e3@wellbehavedsoftware.com>
Date: Tue, 8 Nov 2016 12:38:48 +0100
MIME-Version: 1.0
In-Reply-To: <e9a425e6-0f1a-42ca-8200-1cad1193f048@linuxsystems.it>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 08/11/16 12:06, Niccolò Belli wrote:
> Nice, you should probably update the btrfs wiki as well, because there
> is no mention of btrfs-dedupe.

I am planning to, I had to apply for an account, which has now been 
approved.

> First question, why this name? Don't you plan to support xfs as well?

It didn't occur to me, to be honest. I might support XFS as well, but I 
don't use it, and will possibly be adding other btrfs-specific stuff to 
it. You'll notice it's part of a bigger wbs-backup repo, with other 
tools, which I'm developing to manage my storage and backup requirements.

I'll take a look at it, and certainly see if it works out of the box.

> Second question, I'm trying deduplication tools for the very first time
> and I still have to figure out how to handle snapper snapshots, which
> are read only. I currently tried duperemove 0.11 git and I get tons of
> "Error 30: Read-only file system while opening
> "/.../@snapshots/4385/...". How am I supposed to handle snapper snapshots?

 > Is btrfs-dedupe able to handle snapper snapshots?

You can't deduplicate a read-only snapshot, but you can create 
read-write snapshots from them, deduplicate those, and then recreate the 
read-only ones. This is what I've done.

In theory, once this has been done once, it shouldn't have to be done 
again, at least for those snapshots, unless you want to modify the 
deduplication. It's probably a good idea to defragment files and 
directories first, as well.

It should be possible to deduplicate a read-only file to a read-write 
one, but that's probably not worth the effort in many real-world use cases.

James
