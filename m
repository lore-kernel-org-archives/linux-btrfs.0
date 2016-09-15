Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:48794 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751975AbcIOQFa (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Sep 2016 12:05:30 -0400
Subject: Re: unable to handle kernel paging request
To: Mark Gavalda <markgavalda@kinsta.com>, <linux-btrfs@vger.kernel.org>
References: <CAAwVk4ny29d5qEAEvv=ydGN9DudUpWDQxzusmW1FpdBpLeVDYA@mail.gmail.com>
From: Chris Mason <clm@fb.com>
Message-ID: <6059ae41-ce19-e75f-dbb2-e606d9c8fa7d@fb.com>
Date: Thu, 15 Sep 2016 12:05:16 -0400
MIME-Version: 1.0
In-Reply-To: <CAAwVk4ny29d5qEAEvv=ydGN9DudUpWDQxzusmW1FpdBpLeVDYA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/15/2016 10:08 AM, Mark Gavalda wrote:
> Hi,
>
> Bumped into the following one today; kernel 4.4.0-36-generic Ubuntu
> 16.4.1; CPU went to 100% and only a hard restart solved the issue.
> Since then everything's back to normal.
>
> Please let me know how can I help get to the bottom of this?

I saw similar traces when tracking down this bug:

https://git.kernel.org/cgit/linux/kernel/git/mason/linux-btrfs.git/commit/?h=for-linus-4.8&id=cbd60aa7cd17d81a434234268c55192862147439

It's flagged for stable, so you'll get it with the next stable update, 
or you can apply it by hand and rebuild.

-chris
