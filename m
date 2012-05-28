Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:60397 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753126Ab2E1Spp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 May 2012 14:45:45 -0400
Received: by obbtb18 with SMTP id tb18so5692796obb.19
        for <linux-btrfs@vger.kernel.org>; Mon, 28 May 2012 11:45:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FBC0E6A.3070101@jan-o-sch.net>
References: <CAHf9xvbp=FQwY1Pn9FDaMPdGqe-G4aSMeBK8kUAq-5Kry0YaTA@mail.gmail.com>
	<4FBA1C7B.8000308@jan-o-sch.net>
	<CAHf9xvbdcp1VRny+Pc0q8nxXYqZ3e5OkKC4MCGXqO-HyLnd5cA@mail.gmail.com>
	<4FBC0E6A.3070101@jan-o-sch.net>
Date: Mon, 28 May 2012 21:45:44 +0300
Message-ID: <CAHf9xvafYj-zuUhUUha6=Jm+aYaEz32dcpikS9xExt1VER18_w@mail.gmail.com>
Subject: Re: Newbie questions on some of btrfs code...
From: Alex Lyakas <alex.bolshoy.btrfs@gmail.com>
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Jan,

>> Let's say that slot[0] of the current leaf (A) has key=10. And let's
>> say that its parent node (N) has key=5 (and not 10). Let's say we have
>> a previous leaf (B), whose last slot has key=2.
>> If such tree is valid, then: btrfs_prev_leaf() will search for key==9.
>> Then btrfs_search_slot() would bring us node N and leaf A again,
>> wouldn't it? Because key(N)<=9. So we will receive leaf A back, and
>> will think that there is no previous leaf, while there is.
>> What am I missing here?
>
> It wouldn't. btrfs_search_slot always sets up the path such that it
> points to the position where such an key would be inserted. And we never
> insert at the beginning of a leaf. So in your example, this would be at
> the end of leaf B: your path object will have nodes[1] = N, nodes[0] = B
> and slots[0] = number_of_slots_used_in_B + 1.

I have re-looked at btrfs_search_slot, and don't see how it would end
up in leaf B. The bin_search() function will clearly return the slot
*after* the slot of N that has key==5 (which is the parent slot of A).
So then the following code:
		if (level != 0) {
			int dec = 0;
			if (ret && slot > 0) {
				dec = 1;
				slot -= 1;
			}
will bring us back into the slot of N with key=5. And we will go to
leaf A. While if key(N) of that slot was 10, we would never have ended
up in that slot, unless there is no lesser key in the tree. Actually,
it looks like "no lesser key" is the only case when we can get ret==1
and slot==0. Except perhaps an empty leaf, which I am not sure can
happen.
But I may be way off here, as my understanding is still pretty limited.

Thanks!
Alex.
