Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f176.google.com ([209.85.213.176]:34902 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752009AbcCMTnv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 13 Mar 2016 15:43:51 -0400
Received: by mail-ig0-f176.google.com with SMTP id vf5so46599753igb.0
        for <linux-btrfs@vger.kernel.org>; Sun, 13 Mar 2016 12:43:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160312195746.GJ2334@torres.zugschlus.de>
References: <20160227211450.GS26042@torres.zugschlus.de>
	<CAOE4rSyPvkzjKDVoQ-7U8ay5t7Pp2qeaCqh-tFg-etmgHGEOJQ@mail.gmail.com>
	<20160305143934.GE1902@torres.zugschlus.de>
	<CAJCQCtTw1+E=X1bbGgSB-fPHDtEPUO5amFUEs4fyPmTfK4QaGw@mail.gmail.com>
	<20160312195746.GJ2334@torres.zugschlus.de>
Date: Sun, 13 Mar 2016 13:43:50 -0600
Message-ID: <CAJCQCtSmHAs_zMt3kHdCL9Nd+aAMW-2nDSNYXhizwan8OL3mGw@mail.gmail.com>
Subject: Re: Again, no space left on device while rebalancing and recipe
 doesnt work
From: Chris Murphy <lists@colorremedies.com>
To: Marc Haber <mh+linux-btrfs@zugschlus.de>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Mar 12, 2016 at 12:57 PM, Marc Haber
<mh+linux-btrfs@zugschlus.de> wrote:
> On Sat, Mar 05, 2016 at 12:34:09PM -0700, Chris Murphy wrote:
>> Something is happening with the usage of this file system that's out
>> of the ordinary. This is the first time I've seen such a large amount
>> of unused metadata allocation. And then for it not only fail to
>> balance, but for the allocation amount to increase is a first. So
>> understanding the usage is important to figuring out what's happening.
>> I'd file a bug and include as much information on how the fs got into
>> this state as possible. And also if possible make a btrfs-image using
>> the proper flags to blot out the filenames for privacy. And what
>> btrfs-progs tools were used to create this file system. Etc.
>
> https://bugzilla.kernel.org/show_bug.cgi?id=114451
>
> Please advise if there is something missing.

No enospc_debug mount option used for kernel messages. And no
indication you applied Qu's patch mentioned on March 1 to get more
info with enospc_debug mount:

>Oh, I'm sorry that the output is not necessary, it's better to use the newer patch:
>https://patchwork.kernel.org/patch/8462881/
>With the newer patch, you will need to use enospc_debug mount option to get the debug information.



-- 
Chris Murphy
