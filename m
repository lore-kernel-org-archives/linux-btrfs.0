Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f178.google.com ([209.85.223.178]:35181 "EHLO
	mail-io0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785AbcEPLgZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 May 2016 07:36:25 -0400
Received: by mail-io0-f178.google.com with SMTP id d62so205783583iof.2
        for <linux-btrfs@vger.kernel.org>; Mon, 16 May 2016 04:36:24 -0700 (PDT)
Subject: Re: problems with free space cache
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, Duncan <1i5t5.duncan@cox.net>,
        linux-btrfs@vger.kernel.org
References: <CAD=QJKjop2j+K16nPcAU-bXiCVqm_aGK0g7WxjvTpBvXar+fQQ@mail.gmail.com>
 <85030f6b-b149-ccd2-ea87-42135b9ccd46@cn.fujitsu.com>
 <pan$d4fda$1f29731$4540c768$ab93bd6f@cox.net>
 <03a7da5b-e1e2-81a6-9d0c-ca80c1f52a63@cn.fujitsu.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <9c5605c0-1382-334b-3b6e-9c87b6738164@gmail.com>
Date: Mon, 16 May 2016 07:36:21 -0400
MIME-Version: 1.0
In-Reply-To: <03a7da5b-e1e2-81a6-9d0c-ca80c1f52a63@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-05-16 02:20, Qu Wenruo wrote:
>
>
> Duncan wrote on 2016/05/16 05:59 +0000:
>> Qu Wenruo posted on Mon, 16 May 2016 10:24:23 +0800 as excerpted:
>>
>>> IIRC clear_cache option is fs level option.
>>> So the first mount with clear_cache, then all subvolume will have
>>> clear_cache.
>>
>> Question:  Does clear_cache work with a read-only mount?
> Good question.
>
> But easy to check.
> I just checked it and found even that's possible, it doesn't work.
>
> Free space cache inode bytenr doesn't change and no generation change.
> While without ro, it did rebuild free space cache for *SOME* chunks, not
> *ALL* chunks.
>
> And that's the problem I'm just chasing today.
>
>
> Short conclude: clear_cache mount option will only rebuild free space
> cache for chunks which we allocated space from, during the mount time of
> clear_cache.
> (Maybe I'm just out-of-date and some other devs may already know that)
>
> And kernel fix for that is a little tricky, as we don't really read out
> all free space cache, but only when we are going to allocate space from
> them.
> For any free space cache we didn't read out, they won't be rebuilt.
>
> You can find my reproducer in my just submitted
> patch(https://patchwork.kernel.org/patch/9098431/).
>
> That behavior makes things a little confusing, which users may continue
> hitting annoying free space cache warning from kernel, even they try to
> use clear_cache mount option.
>
>
> Anyway, I'll add ability for manually wipe out all/given free space
> cache to btrfsck, at least creating a solution to really rebuild all v1
> free space cache.
>
FWIW, I think it's possible to do this by mounting with clear_cache and 
then running a full balance on the filesystem.  Having an option to do 
this on an unmounted FS would be preferred of course, as that would 
almost certainly be more efficient on any reasonably sized filesystem.

