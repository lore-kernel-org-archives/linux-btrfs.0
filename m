Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:37847 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752866Ab2EVIHq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 May 2012 04:07:46 -0400
Received: by obbtb18 with SMTP id tb18so9287985obb.19
        for <linux-btrfs@vger.kernel.org>; Tue, 22 May 2012 01:07:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FBA1C7B.8000308@jan-o-sch.net>
References: <CAHf9xvbp=FQwY1Pn9FDaMPdGqe-G4aSMeBK8kUAq-5Kry0YaTA@mail.gmail.com>
	<4FBA1C7B.8000308@jan-o-sch.net>
Date: Tue, 22 May 2012 11:07:46 +0300
Message-ID: <CAHf9xvbdcp1VRny+Pc0q8nxXYqZ3e5OkKC4MCGXqO-HyLnd5cA@mail.gmail.com>
Subject: Re: Newbie questions on some of btrfs code...
From: Alex Lyakas <alex.bolshoy.btrfs@gmail.com>
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Jan,

>> # I saw that slot==0 is special. My understanding is that btrfs
>> maintains the property that the parent of each node/leaf has a key
>> pointing to that node/leaf, which must be equal to the key in the
>> slot==0 of this node/leaf. That's what fixup_low_keys() tries to
>> maintain. Is this correct?
>
> Yes. I'm not 100% sure if the key in the parent node must match exactly
> the first key of the child node. It is probably allowed that it's less
> or equal than the first key. It is guaranteed to be larger than the
> largest of the previous (left) node, though.
>
> And yes, that's what fixup_low_keys is correcting.
>
>> # If my understanding in the previous bullet is correct: Is that the
>> reason that in btrfs_prev_leaf() it is assumed that if there is a
>> lesser key, btrfs_search_slot() will never bring us to the slot==0 of
>> the current leaf?
>
> It's quite straight: We look for a key smaller than the first (slot 0)
> of the current leaf. If we find the current leaf again (because
> btrfs_search_slot returns the place where such a key would have be
> inserted), then there's no previous leaf. No preconditions or
> assumptions on nodes in levels needed.

Let's say that slot[0] of the current leaf (A) has key=10. And let's
say that its parent node (N) has key=5 (and not 10). Let's say we have
a previous leaf (B), whose last slot has key=2.
If such tree is valid, then: btrfs_prev_leaf() will search for key==9.
Then btrfs_search_slot() would bring us node N and leaf A again,
wouldn't it? Because key(N)<=9. So we will receive leaf A back, and
will think that there is no previous leaf, while there is.
What am I missing here?

Thanks for your help,
Alex.
