Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f182.google.com ([209.85.216.182]:33183 "EHLO
        mail-qt0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S941610AbcJEWZZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 5 Oct 2016 18:25:25 -0400
Received: by mail-qt0-f182.google.com with SMTP id s49so819962qta.0
        for <linux-btrfs@vger.kernel.org>; Wed, 05 Oct 2016 15:25:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20161005133346.GF6576@twin.jikos.cz>
References: <20161005112949.8086-1-dsterba@suse.com> <20161005133346.GF6576@twin.jikos.cz>
From: Justin Maggard <jmaggard10@gmail.com>
Date: Wed, 5 Oct 2016 15:25:23 -0700
Message-ID: <CAKgsxVTmdkXjOaVA_Ch9iX-61ckri99vQgafKx8nby87_LST3A@mail.gmail.com>
Subject: Re: Btrfs progs release 4.8 (32bit builds broken)
To: dsterba@suse.cz, David Sterba <dsterba@suse.com>,
        BTRFS <linux-btrfs@vger.kernel.org>, Chris Mason <clm@fb.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I saw a 32-bit build failure, but it looked like a legitimate bug,
unrelated to the compiler version.  Here's the trivial fix:

diff --git a/ioctl.h b/ioctl.h
index a7235c0..26a3a5a 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -606,7 +606,7 @@ struct btrfs_ioctl_send_args {
  * Size of structure depends on pointer width, was not caught.  Kernel handles
  * pointer width differences transparently
  */
-BUILD_ASSERT(sizeof(__u64 *) == 8
+BUILD_ASSERT(sizeof(__u64) == 8
             ? sizeof(struct btrfs_ioctl_send_args) == 72
             : (sizeof(void *) == 4
                ? sizeof(struct btrfs_ioctl_send_args) == 68

-Justin

On Wed, Oct 5, 2016 at 6:33 AM, David Sterba <dsterba@suse.cz> wrote:
> I got a report that the 32bit builds are broken. This seems to be caused
> by padding inserted (or not) into the structures and depends on a
> compiler version. The error messages may look cryptic, but if you see
> something like
>
> ioctl.h:570:1: note: in expansion of macro 'BUILD_ASSERT'
>  BUILD_ASSERT(sizeof(struct btrfs_ioctl_received_subvol_args) == 200);
>
> that means that the given structure has an unexpected size. Fixing that
> properly will probably lead to some tricks to force the exact size
> regardless of arch bits and compiler.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
