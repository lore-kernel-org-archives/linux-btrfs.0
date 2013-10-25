Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from y235201.ppp.asahi-net.or.jp ([118.243.235.201]:56238 "EHLO
	mactop" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751610Ab3JYJot (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Oct 2013 05:44:49 -0400
Received: from [10.81.1.3] (mydomain.com [10.81.1.3])
	by mactop (Postfix) with ESMTP id 540D65FA44
	for <linux-btrfs@vger.kernel.org>; Fri, 25 Oct 2013 18:36:46 +0900 (JST)
Message-ID: <526A3BAD.3010202@parallels.com>
Date: Fri, 25 Oct 2013 18:36:45 +0900
From: dima <dolenin@parallels.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: swapfile on btrfs, temporary solution for wiki
References: <CAGqmi74OvQ=BFroP+QCf6eUtc61__LYRGtZJNcPz1XrSWX-q_w@mail.gmail.com> <CAGqmi74F9GurJL73qtU4JG+Fi4RbXE7tiaO1uEQqEY2ym278eA@mail.gmail.com>
In-Reply-To: <CAGqmi74F9GurJL73qtU4JG+Fi4RbXE7tiaO1uEQqEY2ym278eA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/25/2013 05:52 AM, Timofey Titovets wrote:
> Hello, i suggest temporary solution to use swap file under btrfs.
> I test it, and it work good.
>
> I invent simple the way, how create and using swap file, just see
> following sh code:
>
> swapfile=$(losetup -f) #free loop device
> truncate -s 8G /swap   #create 8G sparse swap file
> losetup $swapfile /swap #mount file to loop
> mkswap  $swapfile
> swapon  $swapfile
>
> i just adding this to rc.local and this work good.
> May be, add it to btrfs Wiki as temporary solution to using swap file?
>
> Timofey

Hi,
Yes, Timofey, it does work. I tested the same over a year ago. And it 
does say briefly about this option in wiki

https://btrfs.wiki.kernel.org/index.php/FAQ#Does_btrfs_support_swap_files.3F
"A workaround, albeit with poor performance, is to mount a swap file via 
a loop device."

best
