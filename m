Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f177.google.com ([209.85.213.177]:34365 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756633AbbDYSQx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 25 Apr 2015 14:16:53 -0400
Received: by iget9 with SMTP id t9so46323235ige.1
        for <linux-btrfs@vger.kernel.org>; Sat, 25 Apr 2015 11:16:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <pan$e7045$f8d3aef7$794e780e$da3a4c69@cox.net>
References: <55392221.6090502@gmail.com>
	<pan$e7045$f8d3aef7$794e780e$da3a4c69@cox.net>
Date: Sat, 25 Apr 2015 14:16:52 -0400
Message-ID: <CAPL5yKcZyku16OGjW9c+P3F-+yKP2vriFsoexjKR_mBiWzTp-A@mail.gmail.com>
Subject: Re: [PATCH 0/3] btrfs-progs: restore symlinks
From: Dan Merillat <dan.merillat@gmail.com>
To: Duncan <1i5t5.duncan@cox.net>
Cc: BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

At this point I I'm done - after writing the symlink patch I restored
everything of importance off my array to a scratch disk, wiped the
array and am in the process of copying everything back.  I'll keep an
eye on this thread if changes need to be made to my patches, but
hopefully I won't be needing btrfs restore for a few more years!


On Fri, Apr 24, 2015 at 12:38 AM, Duncan <1i5t5.duncan@cox.net> wrote:
> Dan Merillat posted on Thu, 23 Apr 2015 12:47:29 -0400 as excerpted:
>
>> Hopefully this is sufficiently paranoid, tested with PATH_MAX length
>> symlinks, existing files, insufficient permissions, dangling symlinks. I
>> think I got the coding style correct this time, I'll fix and resend if
>> not.
>>
>> Includes a trivial fix from my metadata patch, the documentation got
>> lost in the merge.
>
> Thanks for all this.  I've only had to use restore once and hopefully
> won't be using it again in the near future, but having it restore the
> metadata and symlinks as well would surely have made the experience
> easier.  There's a lot of people going to benefit from these patches over
> time as btrfs gains usage and the inevitable breakage happens to some of
> those filesystems. =:^/
>
> --
> Duncan - List replies preferred.   No HTML msgs.
> "Every nonfree program has a lord, a master --
> and if you use the program, he is your master."  Richard Stallman
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
