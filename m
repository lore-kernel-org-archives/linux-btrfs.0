Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:36153 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751478AbdBXA1B (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 23 Feb 2017 19:27:01 -0500
Subject: Re: BTRFS critical: corrupt leaf, slot offset bad; then read-only
To: Lukas Tribus <lukyt@gmx.net>, linux-btrfs@vger.kernel.org
References: <7d3cccae-4761-4799-9ceb-2735519bee8f@gmx.net>
 <0d721199-9407-ff6b-7a31-4dc5dae08e7b@gmx.net>
 <1774ecd3-a28c-908a-ec3b-bc98db36f34e@mendix.com>
 <f805f57f-eecb-03da-e480-5aed4474cdf5@gmx.net>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <c08d6121-6cb7-ad9a-5d71-cd93d2f49196@mendix.com>
Date: Fri, 24 Feb 2017 01:26:31 +0100
MIME-Version: 1.0
In-Reply-To: <f805f57f-eecb-03da-e480-5aed4474cdf5@gmx.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02/24/2017 12:47 AM, Lukas Tribus wrote:
> Hello Hans,
> 
> 
> Am 22.02.2017 um 20:40 schrieb Hans van Kranenburg:
>>
>> Question here is... is it easier for you to nuke the filesystem and
>> restore the files from somewhere else, or do you want to figure out
>> manually if it's recoverable, and spend some time with dd, hexedit,
>> reading struct definitions in btrfs kernel C code etc...
>>
>> If the regular --repair can't fix it (and it can't do magic if you shoot
>> a hole in it with a shotgun), then there's no automated other tool that
>> can do it now.
>>
>> Since it's block 5242107641856 all the time, it might be worthwhile to
>> have a look at it. Either it's that block, or there's a bigger mess
>> hidden behind it.
>>
> 
> Thanks for all the inputs here and on IRC. I now have a good
> understanding of what can
> and what cannot be done realistically.
> 
> The files are still fully readable and I'm going to backup as much data
> as I can over the
> next few days.
> 
> Once that is done, I would like to go over the "btrfs recovery" thread
> and see if it can
> be applied for my case as well. I will certainly need your help when
> that time comes...

We can take a stab at it.

-- 
Hans van Kranenburg
