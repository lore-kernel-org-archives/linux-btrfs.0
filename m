Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:57986 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754248Ab2FDSDs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Jun 2012 14:03:48 -0400
Received: by vbbff1 with SMTP id ff1so2633247vbb.19
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Jun 2012 11:03:47 -0700 (PDT)
Message-ID: <4FCCF882.5080500@gmail.com>
Date: Mon, 04 Jun 2012 14:03:46 -0400
From: Maxim Mikheev <mikhmv@gmail.com>
MIME-Version: 1.0
To: Michael <mike@draftx.net>
CC: Hugo Mills <hugo@carfax.org.uk>, Liu Bo <liubo2009@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: Help with data recovering
References: <4FCC9C63.7000605@gmail.com> <4FCC9CD5.2050309@gmx.net> <4FCC9F6C.5090305@gmail.com> <20120604114901.GA15986@carfax.org.uk> <4FCCA39C.8060409@gmail.com> <20120604121134.GB15986@carfax.org.uk> <4FCCA9E6.3030209@gmail.com> <20120604123431.GC15986@carfax.org.uk> <4FCCE125.7000004@gmail.com> <20120604170422.GD15986@carfax.org.uk> <20120604170936.GE15986@carfax.org.uk> <CAGJTRcg7bwR0ASCLshQYj42erPa5cLV5R3NvWe335m05_R7rJA@mail.gmail.com>
In-Reply-To: <CAGJTRcg7bwR0ASCLshQYj42erPa5cLV5R3NvWe335m05_R7rJA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It was a RAID0 unfortunately.

On 06/04/2012 02:02 PM, Michael wrote:
> If he has it in a RAID 1, could he manually fail the bad disk and try
> it from there? Obviously this could be harmful, so a dd copy would be
> a VERY good idea(truthfully, that should have been the first thing
> that was done).
> Michael
>
> On Mon, Jun 4, 2012 at 12:09 PM, Hugo Mills<hugo@carfax.org.uk>  wrote:
>> On Mon, Jun 04, 2012 at 06:04:22PM +0100, Hugo Mills wrote:
>>>     I'm out of ideas.
>>    ... but that's not to say that someone else may have some ideas. I
>> wouldn't get your hopes up too much, though.
>>
>>>     At this point, though, you're probably looking at somebody writing
>>> custom code to scan the FS and attempt to find and retrieve anything
>>> that's recoverable.
>>>
>>>     You might try writing a tool to scan all the disks for useful
>>> fragments of old trees, and see if you can find some of the tree roots
>>> independently of the tree of tree roots (which clearly isn't
>>> particularly functional right now). You might try simply scanning the
>>> disks looking for your lost data, and try to reconstruct as much of it
>>> as you can from that. You could try to find a company specialising in
>>> data recovery and pay them to try to get your data back. Or you might
>>> just have to accept that the data's gone and work on reconstructing
>>> it.
>>    Hugo.
>>
>> --
>> === Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
>>   PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
>>   --- A linked list is still a binary tree.  Just a very unbalanced ---
>>                              one.  -- dragon
