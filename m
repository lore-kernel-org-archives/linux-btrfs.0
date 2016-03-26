Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f169.google.com ([209.85.213.169]:36398 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753404AbcCZVPR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 26 Mar 2016 17:15:17 -0400
Received: by mail-ig0-f169.google.com with SMTP id nk17so30878452igb.1
        for <linux-btrfs@vger.kernel.org>; Sat, 26 Mar 2016 14:15:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAAafysHw3ws3HVgyfN6YVwFN5pru_kuajKev6sQN6+_uprGiRQ@mail.gmail.com>
References: <CAAafysGTQucscr-8sTuT2c4BpdAovq0w9UbehRYDrSH71CLF-A@mail.gmail.com>
	<CAPmG0jbXcqfB1jG7WFriMhicdsoZ+pbD_uUBu7v9YiD-ey=jDw@mail.gmail.com>
	<CAAafysEhGJi5jYxHooV4h1tD3pqnc-brbB9k4prS9yK0P5PGdg@mail.gmail.com>
	<CAAafysEuE0CXZ2fyY2ybnff3=XLEdGirCU9BJf9mhLE0xFTTrQ@mail.gmail.com>
	<CAJCQCtQcX+U1cWz1j3Re5E-=ruPBY+zj0SFqB1jDibgeQniSVw@mail.gmail.com>
	<CAAafysE+5tS=k9GFoKyqwK6dJtR4g3Eqairt1cGatCfCxooXeg@mail.gmail.com>
	<CAJCQCtTURu4OJbTfpKzQGAz4g32yaxToPaE9r8+xWt19AYJUig@mail.gmail.com>
	<CAAafysFa8XZgKvKXQqcnZYR8DLbFe3STQA3Y++Wb71PPdf+iuw@mail.gmail.com>
	<CAJCQCtQwc4FDcTPq2mfN7wfUNp9QWEq+XTJA+FEyY4hWrHvHQQ@mail.gmail.com>
	<CAAafysHw3ws3HVgyfN6YVwFN5pru_kuajKev6sQN6+_uprGiRQ@mail.gmail.com>
Date: Sat, 26 Mar 2016 15:15:16 -0600
Message-ID: <CAJCQCtQzu2X16L_jp7k-Sy8=+ScCekoHEACajcATX_-vMvDwUA@mail.gmail.com>
Subject: Re: RAID Assembly with Missing Empty Drive
From: Chris Murphy <lists@colorremedies.com>
To: John Marrett <johnf@zioncluster.ca>
Cc: Chris Murphy <lists@colorremedies.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Mar 26, 2016 at 3:01 PM, John Marrett <johnf@zioncluster.ca> wrote:
>> Well off hand it seems like the missing 2.73TB has nothing on it at
>> all, and doesn't need to be counted as missing. The other missing is
>> counted, and should have all of its data replicated elsewhere. But
>> then you're running into csum errors. So something still isn't right,
>> we just don't understand what it is.
>
> I'm not sure what we can do to get a better understanding of these
> errors, that said it may not be necessary if replace helps, more
> below.
>
>> Btrfs replace has been around for a while. 'man btrfs replace' the
>> command takes the form 'btrfs replace start' plus three required
>> pieces of information. You should be able to infer the missing devid
>> using 'btrfs show' looks like it's 6.
>
> I was looking under btrfs device, sorry about that. I do have the
> command. I tried replace and it seemed more promising than the last
> attempt, it wrote enough data to the new drive to overflow and break
> my overlay. I'm trying it without the overlay on the destination
> device, I'll report back later with the results.
>
> I'm running ubuntu linux-image-4.2.0-34-generic with a patch to remove
> this check:
>
> https://github.com/torvalds/linux/blob/master/fs/btrfs/super.c#L1770
>
> I can switch to whatever kernel though as desired. Would you prefer a
> mainline ubuntu packaged kernel? Straight from kernel.org?

Things are a lot more deterministic for developers and testers if
you're using something current. It might not matter in this case that
you're using 4.2 but all you have to do is look at the git pulls in
the list archives to see many hundreds, often over 1000, btrfs changes
per kernel cycle. So, lots and lots of fixes have happened since 4.2.
And any bugs found in 4.2 don't really matter, because you'd have to
try to reproduce in 4.4.6 or 4.5, and then the fix would go into 4.6
before it'd get backported, and then 4.2 won't be getting backports
done by upstream. That's why list folks always suggest using something
so recent. Again, in this case it might not matter, I don't read or
understand every single commit.

If you do want to use a newer one, I'd build against kernel.org, just
because the developers only use that base. And use 4.4.6 or 4.5.

It's reasonable to keep the overlay on the existing devices, but
remove the overlay for the replacement so that you're directly writing
to it. If that blows up with 4.2 you can still start over with a newer
kernel. *shrug*


-- 
Chris Murphy
