Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:5648 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750729AbcEPGUP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 May 2016 02:20:15 -0400
Subject: Re: problems with free space cache
To: Duncan <1i5t5.duncan@cox.net>, <linux-btrfs@vger.kernel.org>
References: <CAD=QJKjop2j+K16nPcAU-bXiCVqm_aGK0g7WxjvTpBvXar+fQQ@mail.gmail.com>
 <85030f6b-b149-ccd2-ea87-42135b9ccd46@cn.fujitsu.com>
 <pan$d4fda$1f29731$4540c768$ab93bd6f@cox.net>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <03a7da5b-e1e2-81a6-9d0c-ca80c1f52a63@cn.fujitsu.com>
Date: Mon, 16 May 2016 14:20:01 +0800
MIME-Version: 1.0
In-Reply-To: <pan$d4fda$1f29731$4540c768$ab93bd6f@cox.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Duncan wrote on 2016/05/16 05:59 +0000:
> Qu Wenruo posted on Mon, 16 May 2016 10:24:23 +0800 as excerpted:
>
>> IIRC clear_cache option is fs level option.
>> So the first mount with clear_cache, then all subvolume will have
>> clear_cache.
>
> Question:  Does clear_cache work with a read-only mount?
Good question.

But easy to check.
I just checked it and found even that's possible, it doesn't work.

Free space cache inode bytenr doesn't change and no generation change.
While without ro, it did rebuild free space cache for *SOME* chunks, not 
*ALL* chunks.

And that's the problem I'm just chasing today.


Short conclude: clear_cache mount option will only rebuild free space 
cache for chunks which we allocated space from, during the mount time of 
clear_cache.
(Maybe I'm just out-of-date and some other devs may already know that)

And kernel fix for that is a little tricky, as we don't really read out 
all free space cache, but only when we are going to allocate space from 
them.
For any free space cache we didn't read out, they won't be rebuilt.

You can find my reproducer in my just submitted 
patch(https://patchwork.kernel.org/patch/9098431/).

That behavior makes things a little confusing, which users may continue 
hitting annoying free space cache warning from kernel, even they try to 
use clear_cache mount option.


Anyway, I'll add ability for manually wipe out all/given free space 
cache to btrfsck, at least creating a solution to really rebuild all v1 
free space cache.

Thanks,
Qu
>
> I could see it being like the log replay and being done even on ro
> mounts, particularly since unlike the log replay, clear_cache is a
> specific mount option so could be seen as specifically requested even if
> otherwise ro.  Or not.  So I don't know.
>
> He mentioned root, which is normally mounted read-only first.  That's
> what got me thinking about it.  Does that complicate things?
>
> If root is mounted ro without clear_cache by the initr*, will a
> subsequent remount,rw,clear_cache do it?
>
> And for those like me who keep root mounted ro by default, would
> clear_cache work at all, or would it not work until such time as I
> mounted root, or some other subvolume (which I don't have here to worry
> about, but for those who do...) writable?
>


