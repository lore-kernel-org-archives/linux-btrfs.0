Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:64982 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753974Ab2IFX5q (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 6 Sep 2012 19:57:46 -0400
Received: by obbuo13 with SMTP id uo13so3692731obb.19
        for <linux-btrfs@vger.kernel.org>; Thu, 06 Sep 2012 16:57:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1346964716-12070-1-git-send-email-jbacik@fusionio.com>
References: <1346964716-12070-1-git-send-email-jbacik@fusionio.com>
Date: Thu, 6 Sep 2012 18:57:42 -0500
Message-ID: <CAKcLGm_oTktZjCDOQsEe0Wke1TinikCqP786Z=73vD4m9o39HQ@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: wait on async pages when shrinking delalloc
From: Mitch Harder <mitch.harder@sabayonlinux.org>
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 6, 2012 at 3:51 PM, Josef Bacik <jbacik@fusionio.com> wrote:
> Mitch reported a problem where you could get an ENOSPC error when untarring
> a kernel git tree onto a 16gb file system with compress-force=zlib.  This is
> because compression is a huge pain, it will return from ->writepages()
> without having actually created any ordered extents.  To get around this we
> check to see if the async submit counter is up, and if it is wait until it
> drops to 0 before doing our normal ordered wait dance.  With this patch I
> can now untar a kernel git tree onto a 16gb file system without getting
> ENOSPC errors.  Thanks,
>
> Signed-off-by: Josef Bacik <jbacik@fusionio.com>

Thanks, this patch fixes the issues I was seeing with ENOSPC on zlib
compression.

I also did some rough testing for any performance regressions on lzo
and with no compression, and my benchmarks were all in the same range.
 I don't have any comparisons available for zlib since my benchmark
tests would always trigger ENOSPC errors.

I also checked Zach Brown's suggestion of dropping:

> +               if (atomic_read(&root->fs_info->async_delalloc_pages))

and just leaving:

> +                       wait_event(root->fs_info->async_submit_wait,
> +                         !atomic_read(&root->fs_info->async_delalloc_pages));

This is because the wait_event macro should perform the same test
(although it will start a 'do' loop before making the same test).

This change also worked in my tests.

For reference, I pulled up the wait_event macro according to the Linux
Cross Reference site:

http://lxr.free-electrons.com/source/include/linux/wait.h#L205

205 /**
206  * wait_event - sleep until a condition gets true
207  * @wq: the waitqueue to wait on
208  * @condition: a C expression for the event to wait for
209  *
210  * The process is put to sleep (TASK_UNINTERRUPTIBLE) until the
211  * @condition evaluates to true. The @condition is checked each time
212  * the waitqueue @wq is woken up.
213  *
214  * wake_up() has to be called after changing any variable that could
215  * change the result of the wait condition.
216  */
217 #define wait_event(wq, condition)                                       \
218 do {                                                                    \
219         if (condition)                                                  \
220                 break;                                                  \
221         __wait_event(wq, condition);                                    \
222 } while (0)

Tested-by: Mitch Harder <mitch.harder@sabayonlinux.org>
