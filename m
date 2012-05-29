Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:53720 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041Ab2E2L1u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 May 2012 07:27:50 -0400
Received: by gglu4 with SMTP id u4so2370650ggl.19
        for <linux-btrfs@vger.kernel.org>; Tue, 29 May 2012 04:27:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FC49341.5020104@jan-o-sch.net>
References: <CAHf9xvbp=FQwY1Pn9FDaMPdGqe-G4aSMeBK8kUAq-5Kry0YaTA@mail.gmail.com>
	<4FBA1C7B.8000308@jan-o-sch.net>
	<CAHf9xvbdcp1VRny+Pc0q8nxXYqZ3e5OkKC4MCGXqO-HyLnd5cA@mail.gmail.com>
	<4FBC0E6A.3070101@jan-o-sch.net>
	<CAHf9xvafYj-zuUhUUha6=Jm+aYaEz32dcpikS9xExt1VER18_w@mail.gmail.com>
	<4FC49341.5020104@jan-o-sch.net>
Date: Tue, 29 May 2012 14:27:49 +0300
Message-ID: <CAHf9xvbGwLRxyY2w97af4zG9VPowg9rVJQmfC2TVdM5am_91ug@mail.gmail.com>
Subject: Re: Newbie questions on some of btrfs code...
From: Alex Lyakas <alex.bolshoy.btrfs@gmail.com>
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thank you Jan, Hugo & Lio,
for taking time answering my questions.

Alex.
P.S.: I have dug in some more, so probably more questions will arrive:)


On Tue, May 29, 2012 at 12:13 PM, Jan Schmidt <list.btrfs@jan-o-sch.net> wrote:
> On Mon, May 28, 2012 at 20:45 (+0200), Alex Lyakas wrote:
>> I have re-looked at btrfs_search_slot, and don't see how it would end
>> up in leaf B. The bin_search() function will clearly return the slot
>> *after* the slot of N that has key==5 (which is the parent slot of A).
>> So then the following code:
>>               if (level != 0) {
>>                       int dec = 0;
>>                       if (ret && slot > 0) {
>>                               dec = 1;
>>                               slot -= 1;
>>                       }
>> will bring us back into the slot of N with key=5. And we will go to
>> leaf A. While if key(N) of that slot was 10, we would never have ended
>> up in that slot, unless there is no lesser key in the tree.
>
> Yes, that's right. As already said in my previous mail (in the paragraph
> you didn't quote), the key in the leaf must be an exact match. The key
> in N pointing to A will be 10.
>
>> Actually, it looks like "no lesser key" is the only case when we can
>> get ret==1 and slot==0.
>
> Correct.
>
>> Except perhaps an empty leaf, which I am not sure can happen.
>
> It can't.
>
> -Jan
