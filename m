Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.linuxsystems.it ([79.7.78.67]:50658 "EHLO
        mail.linuxsystems.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750975AbeERQhC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 May 2018 12:37:02 -0400
From: =?iso-8859-1?Q?Niccol=F2_Belli?= <darkbasic@linuxsystems.it>
To: David Sterba <dsterba@suse.cz>
Cc: <linux-btrfs@vger.kernel.org>
Subject: Re: Any chance to get snapshot-aware =?iso-8859-1?Q?defragmentation=3F?=
Date: Fri, 18 May 2018 18:36:59 +0200
MIME-Version: 1.0
Message-ID: <99d57070-a1df-45ef-8f7e-df832bd7ad92@linuxsystems.it>
In-Reply-To: <20180518162051.GS6649@twin.jikos.cz>
References: <4428b2eb-796a-4c1b-8527-a05532436da4@linuxsystems.it>
 <20180518162051.GS6649@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On venerdì 18 maggio 2018 18:20:51 CEST, David Sterba wrote:
> Josef started working on that in 2014 and did not finish it. The patches
> can be still found in his tree. The problem is in excessive memory
> consumption when there are many snapshots that need to be tracked during
> the defragmentation, so there are measures to avoid OOM. There's
> infrastructure ready for use (shrinkers), there are maybe some problems
> but fundamentally is should work.
>
> I'd like to get the snapshot-aware working again too, we'd need to find
> a volunteer to resume the work on the patchset.

Yeah I know of Josef's work, but 4 years had passed since then without any 
news on this front.

What I would really like to know is why nobody resumed his work: is it 
because it's impossible to implement snapshot-aware degram without 
excessive ram usage or is it simply because nobody is interested?

Niccolò
