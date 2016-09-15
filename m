Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f42.google.com ([209.85.218.42]:36519 "EHLO
        mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752280AbcIOUM6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Sep 2016 16:12:58 -0400
Received: by mail-oi0-f42.google.com with SMTP id q188so85957368oia.3
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Sep 2016 13:12:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <6059ae41-ce19-e75f-dbb2-e606d9c8fa7d@fb.com>
References: <CAAwVk4ny29d5qEAEvv=ydGN9DudUpWDQxzusmW1FpdBpLeVDYA@mail.gmail.com>
 <6059ae41-ce19-e75f-dbb2-e606d9c8fa7d@fb.com>
From: Mark Gavalda <markgavalda@kinsta.com>
Date: Thu, 15 Sep 2016 22:12:57 +0200
Message-ID: <CAAwVk4kBfG6_A9J8Kc9rFY_CXcekdRyDK37EYe-XqPo6DKwqMw@mail.gmail.com>
Subject: Re: unable to handle kernel paging request
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks, I can see it included in 4.8-rc6 but not the other branches.
Will it get pulled later or is this a 4.8 only fix?

Mark

On Thu, Sep 15, 2016 at 6:05 PM, Chris Mason <clm@fb.com> wrote:
> On 09/15/2016 10:08 AM, Mark Gavalda wrote:
>>
>> Hi,
>>
>> Bumped into the following one today; kernel 4.4.0-36-generic Ubuntu
>> 16.4.1; CPU went to 100% and only a hard restart solved the issue.
>> Since then everything's back to normal.
>>
>> Please let me know how can I help get to the bottom of this?
>
>
> I saw similar traces when tracking down this bug:
>
> https://git.kernel.org/cgit/linux/kernel/git/mason/linux-btrfs.git/commit/?h=for-linus-4.8&id=cbd60aa7cd17d81a434234268c55192862147439
>
> It's flagged for stable, so you'll get it with the next stable update, or
> you can apply it by hand and rebuild.
>
> -chris
