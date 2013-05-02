Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:39432 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759287Ab3EBPck (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 May 2013 11:32:40 -0400
Received: by mail-lb0-f174.google.com with SMTP id r10so656933lbi.33
        for <linux-btrfs@vger.kernel.org>; Thu, 02 May 2013 08:32:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5181EC42.6090300@redhat.com>
References: <1367462803-6630-1-git-send-email-mlin@kernel.org>
	<5181EC42.6090300@redhat.com>
Date: Thu, 2 May 2013 11:32:38 -0400
Message-ID: <CAF1ivSaywbOyg4oW9hnHM8BGMc2ub+cgH16hOpDX8oBbirQ8Tw@mail.gmail.com>
Subject: Re: [PATCH] btrfs-progs: fix segfault in walk_down_tree
From: Lin Ming <mlin@kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 2, 2013 at 12:32 AM, Eric Sandeen <sandeen@redhat.com> wrote:
> On 5/1/13 9:46 PM, Lin Ming wrote:
>> walk_down_tree will fault when read_tree_block fails with NULL returned.
>>
>> Signed-off-by: Lin Ming <mlin@kernel.org>
>> ---
>>  cmds-check.c |    2 ++
>>  1 files changed, 2 insertions(+), 0 deletions(-)
>>
>> diff --git a/cmds-check.c b/cmds-check.c
>> index 12192fa..e4435d5 100644
>> --- a/cmds-check.c
>> +++ b/cmds-check.c
>> @@ -1256,6 +1256,8 @@ static int walk_down_tree(struct btrfs_root *root, struct btrfs_path *path,
>>                       reada_walk_down(root, cur, path->slots[*level]);
>>                       next = read_tree_block(root, bytenr, blocksize,
>>                                              ptr_gen);
>> +                     if (!next)
>> +                             goto out;
>>               }
>>
>>               *level = *level - 1;
>>
>
> I suppose that could fix a segfault . . . although, details
> would be nice.  next is only used as:
>
>         path->nodes[*level] = next;
>
> before it gets reassigned in the loop.  So I guess someone
> uses the path array and doesn't handle a NULL?

walk_down_tree():

        while (*level >= 0) {
                .....
                cur = path->nodes[*level];

                if (btrfs_header_level(cur) != *level)   <---- segfault here

                .....
                path->nodes[*level] = next;

>
> Ok, but if read_tree_block fails(), doesn't that mean some error
> occurred?  And if so, walk_down_tree would still return 0,
> which looks like success to the caller.  Then what?
>
> I guess that's what the other error returns in this function
> do as well.  :(
>
> But this seems like suboptimal behavior for a filesystem checker,
> doesn't it?  Just silently ignoring errors?
>
> And while this might fix the segfault I'm afraid it does so without
> really handling the problem, and it might never be noticed again.
>
> The caller looks like it might handle an error, if one were ever
> passed up (which it's not right now):
>
>                 wret = walk_down_tree(root, &path, wc, &level);
>                 if (wret < 0)
>                         ret = wret;
>                 if (wret != 0)
>                         break;
>
> Over on the kernel side, this commit at least catches the error
> and passes it up:
>
> commit 97d9a8a420444eb5b5c071d4b3b9c4100a7ae015
> Author: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
> Date:   Thu Mar 24 06:33:21 2011 +0000
>
>     Btrfs: check return value of read_tree_block()
>
>     This patch is checking return value of read_tree_block(),
>     and if it is NULL, error processing.
>
>     Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
>     Signed-off-by: Chris Mason <chris.mason@oracle.com>
>
> ...
>                 next = read_tree_block(root, bytenr, blocksize, generation);
> +               if (!next)
> +                       return -EIO;
> ...
>
> so that's probably a better way to go, though it might require some testing.

Agree, we should pass up the return value of walk_down_tree().

Lin Ming

>
> Another reason to get userspace caught up w/ kernelspace, argh.
>
> -Eric
