Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f177.google.com ([209.85.214.177]:64098 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753035AbaCJQBT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Mar 2014 12:01:19 -0400
Received: by mail-ob0-f177.google.com with SMTP id wo20so6805950obc.8
        for <linux-btrfs@vger.kernel.org>; Mon, 10 Mar 2014 09:01:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <531DDF7E.305@fb.com>
References: <1392608637-24756-1-git-send-email-sachin.kamat@linaro.org>
	<CAK9yfHyz66Zt5ZdKy1LYfE1skh-Z5Qx9p6y5Agg1EtKzof0jYg@mail.gmail.com>
	<531DDF7E.305@fb.com>
Date: Mon, 10 Mar 2014 21:31:18 +0530
Message-ID: <CAK9yfHw0Xi4WXbJ24JqfSOzZ8=3hRP6X+niTvbbb9sz6vVjtvg@mail.gmail.com>
Subject: Re: [PATCH Resend] btrfs: Use PTR_ERR_OR_ZERO
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Josef Bacik <jbacik@fb.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>, clm <clm@fb.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10 March 2014 21:21, Josef Bacik <jbacik@fb.com> wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> On 03/10/2014 11:25 AM, Sachin Kamat wrote:
>> On 17 February 2014 09:13, Sachin Kamat <sachin.kamat@linaro.org>
>> wrote:
>>> PTR_RET is deprecated. Use PTR_ERR_OR_ZERO instead. While at it
>>> also include missing err.h header.
>>>
>>> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org> ---
>>> fs/btrfs/root-tree.c |    3 ++- 1 file changed, 2 insertions(+),
>>> 1 deletion(-)
>>>
>>> diff --git a/fs/btrfs/root-tree.c b/fs/btrfs/root-tree.c index
>>> 1389b69059de..38bb47e7d6b1 100644 --- a/fs/btrfs/root-tree.c +++
>>> b/fs/btrfs/root-tree.c @@ -16,6 +16,7 @@ * Boston, MA
>>> 021110-1307, USA. */
>>>
>>> +#include <linux/err.h> #include <linux/uuid.h> #include
>>> "ctree.h" #include "transaction.h" @@ -271,7 +272,7 @@ int
>>> btrfs_find_orphan_roots(struct btrfs_root *tree_root)
>>> key.offset++;
>>>
>>> root = btrfs_read_fs_root(tree_root, &root_key); -
>>> err = PTR_RET(root); +               err =
>>> PTR_ERR_OR_ZERO(root); if (err && err != -ENOENT) { break; } else
>>> if (err == -ENOENT) { -- 1.7.9.5
>>>
>>
>> Ping..
>>
>
> It's in my current batch, I'm just tracking down problems with other
> patches in this batch, it should be pushed out in the next day or two.

Thanks Josef.


-- 
With warm regards,
Sachin
