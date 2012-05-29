Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from brockman.in8.de ([85.214.220.56]:35873 "EHLO mail.in8.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751161Ab2E2JNi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 May 2012 05:13:38 -0400
Message-ID: <4FC49341.5020104@jan-o-sch.net>
Date: Tue, 29 May 2012 11:13:37 +0200
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
MIME-Version: 1.0
To: Alex Lyakas <alex.bolshoy.btrfs@gmail.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: Newbie questions on some of btrfs code...
References: <CAHf9xvbp=FQwY1Pn9FDaMPdGqe-G4aSMeBK8kUAq-5Kry0YaTA@mail.gmail.com>	<4FBA1C7B.8000308@jan-o-sch.net>	<CAHf9xvbdcp1VRny+Pc0q8nxXYqZ3e5OkKC4MCGXqO-HyLnd5cA@mail.gmail.com>	<4FBC0E6A.3070101@jan-o-sch.net> <CAHf9xvafYj-zuUhUUha6=Jm+aYaEz32dcpikS9xExt1VER18_w@mail.gmail.com>
In-Reply-To: <CAHf9xvafYj-zuUhUUha6=Jm+aYaEz32dcpikS9xExt1VER18_w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 28, 2012 at 20:45 (+0200), Alex Lyakas wrote:
> I have re-looked at btrfs_search_slot, and don't see how it would end
> up in leaf B. The bin_search() function will clearly return the slot
> *after* the slot of N that has key==5 (which is the parent slot of A).
> So then the following code:
> 		if (level != 0) {
> 			int dec = 0;
> 			if (ret && slot > 0) {
> 				dec = 1;
> 				slot -= 1;
> 			}
> will bring us back into the slot of N with key=5. And we will go to
> leaf A. While if key(N) of that slot was 10, we would never have ended
> up in that slot, unless there is no lesser key in the tree.

Yes, that's right. As already said in my previous mail (in the paragraph
you didn't quote), the key in the leaf must be an exact match. The key
in N pointing to A will be 10.

> Actually, it looks like "no lesser key" is the only case when we can
> get ret==1 and slot==0.

Correct.

> Except perhaps an empty leaf, which I am not sure can happen.

It can't.

-Jan
