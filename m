Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f47.google.com ([209.85.214.47]:35112 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756587Ab3G3X1G (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Jul 2013 19:27:06 -0400
Received: by mail-bk0-f47.google.com with SMTP id jg9so8209bkc.20
        for <linux-btrfs@vger.kernel.org>; Tue, 30 Jul 2013 16:27:04 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <20130730230003.GJ32145@lenny.home.zabbo.net>
References: <1375210462-17820-1-git-send-email-fdmanana@gmail.com>
	<20130730230003.GJ32145@lenny.home.zabbo.net>
Date: Wed, 31 Jul 2013 00:27:04 +0100
Message-ID: <CAL3q7H5qLyNDcmV9Wp2JtBxgLWnrN5Om6um7WmKq+LSs37xTUw@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: add missing error check to find_parent_nodes
From: Filipe David Manana <fdmanana@gmail.com>
To: Zach Brown <zab@redhat.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 31, 2013 at 12:00 AM, Zach Brown <zab@redhat.com> wrote:
>> diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
>> index 8bc5e8c..1ba87c5 100644
>> --- a/fs/btrfs/backref.c
>> +++ b/fs/btrfs/backref.c
>> @@ -935,6 +935,8 @@ again:
>>                               }
>>                               ret = find_extent_in_eb(eb, bytenr,
>>                                                       *extent_item_pos, &eie);
>> +                             if (ret < 0)
>> +                                     goto out;
>>                               ref->inode_list = eie;
>>                               free_extent_buffer(eb);
>>                       }
>
> The eb needs to be freed before the goto.
>
> And that there's now *three* eb freeing paths in this block should be a
> hint that it should be refactored into a function that frees the eb
> before returning.

Thanks, missed that previously.

>
> - z



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
