Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from brockman.in8.de ([85.214.220.56]:34295 "EHLO mail.in8.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752629Ab2EVWIq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 May 2012 18:08:46 -0400
Message-ID: <4FBC0E6A.3070101@jan-o-sch.net>
Date: Wed, 23 May 2012 00:08:42 +0200
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
MIME-Version: 1.0
To: Alex Lyakas <alex.bolshoy.btrfs@gmail.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: Newbie questions on some of btrfs code...
References: <CAHf9xvbp=FQwY1Pn9FDaMPdGqe-G4aSMeBK8kUAq-5Kry0YaTA@mail.gmail.com>	<4FBA1C7B.8000308@jan-o-sch.net> <CAHf9xvbdcp1VRny+Pc0q8nxXYqZ3e5OkKC4MCGXqO-HyLnd5cA@mail.gmail.com>
In-Reply-To: <CAHf9xvbdcp1VRny+Pc0q8nxXYqZ3e5OkKC4MCGXqO-HyLnd5cA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 22.05.2012 10:07, Alex Lyakas wrote:
>>> # If my understanding in the previous bullet is correct: Is that the
>>> reason that in btrfs_prev_leaf() it is assumed that if there is a
>>> lesser key, btrfs_search_slot() will never bring us to the slot==0 of
>>> the current leaf?
>>
>> It's quite straight: We look for a key smaller than the first (slot 0)
>> of the current leaf. If we find the current leaf again (because
>> btrfs_search_slot returns the place where such a key would have be
>> inserted), then there's no previous leaf. No preconditions or
>> assumptions on nodes in levels needed.
> 
> Let's say that slot[0] of the current leaf (A) has key=10. And let's
> say that its parent node (N) has key=5 (and not 10). Let's say we have
> a previous leaf (B), whose last slot has key=2.
> If such tree is valid, then: btrfs_prev_leaf() will search for key==9.
> Then btrfs_search_slot() would bring us node N and leaf A again,
> wouldn't it? Because key(N)<=9. So we will receive leaf A back, and
> will think that there is no previous leaf, while there is.
> What am I missing here?

It wouldn't. btrfs_search_slot always sets up the path such that it
points to the position where such an key would be inserted. And we never
insert at the beginning of a leaf. So in your example, this would be at
the end of leaf B: your path object will have nodes[1] = N, nodes[0] = B
and slots[0] = number_of_slots_used_in_B + 1.

Your example sounds like a good explanation why the key in the parent
node should really be an exact match. It sounds reasonable that it's not
allowed to be <= than the first key of its child. If it was, extra
lookups would be required to setup the path correctly for your example
above (which I haven't seen so far).

-Jan
