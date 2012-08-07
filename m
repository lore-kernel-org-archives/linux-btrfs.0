Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:34625 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750752Ab2HGF2d (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Aug 2012 01:28:33 -0400
Message-ID: <5020A797.6010108@gmx.net>
Date: Tue, 07 Aug 2012 07:28:55 +0200
From: Arne Jansen <sensille@gmx.net>
MIME-Version: 1.0
To: Mitch Harder <mitch.harder@sabayonlinux.org>
CC: chris.mason@oracle.com, linux-btrfs@vger.kernel.org,
        list.btrfs@jan-o-sch.net
Subject: Re: [PATCH] Btrfs: fix deadlock in wait_for_more_refs
References: <1344284331-24328-1-git-send-email-sensille@gmx.net> <CAKcLGm-GOA-XpNwyYCNYb3cXeDkzmd1KyYRg=6MJuoe7EhAR+A@mail.gmail.com>
In-Reply-To: <CAKcLGm-GOA-XpNwyYCNYb3cXeDkzmd1KyYRg=6MJuoe7EhAR+A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 08/07/2012 07:03 AM, Mitch Harder wrote:
> On Mon, Aug 6, 2012 at 3:18 PM, Arne Jansen <sensille@gmx.net> wrote:
>> Commit a168650c introduced a waiting mechanism to prevent busy waiting in
>> btrfs_run_delayed_refs. This can deadlock with btrfs_run_ordered_operations,
>> where a tree_mod_seq is held while waiting for the io to complete, while
>> the end_io calls btrfs_run_delayed_refs.
>> This whole mechanism is unnecessary. If not enough runnable refs are
>> available to satisfy count, just return as count is more like a guideline
>> than a strict requirement.
>> In case we have to run all refs, commit transaction makes sure that no
>> other threads are working in the transaction anymore, so we just assert
>> here that no refs are blocked.
>>
> 
> I've been testing this patch after manually merging on top of Josef's
> "Btrfs: barrier before waitqueue_active V2" patch.
> 
> With that arrangement, I've been unable to reproduce the deadlock on my system.
> 
> I'll continue banging away on it tomorrow, and let you know if I
> attain a deadlock.
> 
> Also, let me know if you need me to test without including Josef's
> added barriers.

The problem at hand hadn't had anything to do with barriers, so Josef's
patch shouldn't be necessary for this particular problem. If it fixes
other ones I can't tell.

> 

