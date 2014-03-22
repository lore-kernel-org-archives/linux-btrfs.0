Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f173.google.com ([209.85.213.173]:38398 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066AbaCVViX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 22 Mar 2014 17:38:23 -0400
Received: by mail-ig0-f173.google.com with SMTP id t19so4628490igi.0
        for <linux-btrfs@vger.kernel.org>; Sat, 22 Mar 2014 14:38:23 -0700 (PDT)
Message-ID: <532E02CC.8040008@gmail.com>
Date: Sat, 22 Mar 2014 16:38:20 -0500
From: Andrew Skretvedt <andrew.skretvedt@gmail.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org, 1i5t5.duncan@cox.net
Subject: Re: fresh btrfs filesystem, out of disk space, hundreds of gigs free
References: <CAKuK5J0LyagDYro6Yq7h-p-VjbwrbeuFf9AdNwRNg0jv3bq9QQ@mail.gmail.com> <pan$54504$c9b05495$fa56905f$67202842@cox.net>
In-Reply-To: <pan$54504$c9b05495$fa56905f$67202842@cox.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is just a rave-post to praise Duncan for his excellent post back to 
Jon!

This will surely help a good number of new btrfs users who have the good 
sense to watch this mailing list. Your exposition on the balance command 
helped to clarify in my mind exactly why someone might want to use the 
usage= filter with a given figure (it looked like black magic to me 
before, and its usefulness still wasn't completely clear to me after 
reading the wiki). You had a lot of practical advice for making and 
maintaining a new btrfs filesystem. I run a btrfs as my root as well, 
created under kernel 3.2 and purring right along while I've since moved 
the kernel to 3.9. I recently updated the userspace tools to 3.12 (from 
the distro-provided 0.19+something), so I'll be sure to move the kernel 
up to 3.12 as well before trying anything complex.

Thanks for the effort.

-Andrew
-----
On 2014-Mar-22 03:28, Duncan wrote:> Jon Nelson posted on Fri, 21 Mar 
2014 19:00:51 -0500 as excerpted:
>
-----(snip)-----
> Meanwhile, I strongly urge you to read up on the btrfs wiki.  The
> following is easy to remember and bookmark:
>
> https://btrfs.wiki.kernel.org
>
> Here's the documentation link (alternate bookmarking candidate):
>
> https://btrfs.wiki.kernel.org/index.php/Main_Page#Documentation
>
> Here's the discussion that would have gotten you out of this specific
> bind (long link, watch the wrap):
>
> https://btrfs.wiki.kernel.org/index.php/
> FAQ#if_your_device_is_large_.28.3E16GiB.29
>
> And here's the balance-filters page, which can be a bit hard to find altho
> it's linked on the FAQ page under the balance discussion:
>
> https://btrfs.wiki.kernel.org/index.php/Balance_Filters
>
