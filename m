Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f42.google.com ([209.85.215.42]:56720 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754079AbaDFQ5j (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 6 Apr 2014 12:57:39 -0400
Received: by mail-la0-f42.google.com with SMTP id ec20so4060405lab.1
        for <linux-btrfs@vger.kernel.org>; Sun, 06 Apr 2014 09:57:38 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <20140406001838.GA9485@merlins.org>
References: <1396624841-1363-1-git-send-email-fdmanana@gmail.com>
	<20140406001838.GA9485@merlins.org>
Date: Sun, 6 Apr 2014 17:57:38 +0100
Message-ID: <CAL3q7H7Em8hX1CeARSjoZHwjvEjiQNs9Ni_ofH5aVbjQ04j0fQ@mail.gmail.com>
Subject: Re: [RFC PATCH] Btrfs: send, add calculate data size flag to allow
 for progress estimation
From: Filipe David Manana <fdmanana@gmail.com>
To: Marc MERLIN <marc@merlins.org>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Apr 6, 2014 at 1:18 AM, Marc MERLIN <marc@merlins.org> wrote:
> On Fri, Apr 04, 2014 at 04:20:41PM +0100, Filipe David Borba Manana wrote:
>> This new send flag makes send calculate first the amount of new file data (in bytes)
>> the send root has relatively to the parent root, or for the case of a non-incremental
>> send, the total amount of file data we will send through the send stream. In other words,
>> it computes the sum of the lengths of all write and clone operations that will be sent
>> through the send stream.
>
> Thanks for this patch, much appreciated.
>
> A few questions:
> 1) I tried to apply to 3.14.0, and it all applied except one line:
> --- fs/btrfs/send.c
> +++ fs/btrfs/send.c
> @@ -3091,6 +3121,8 @@
>         int ret;
>         u64 ancestor = 0;
>
> +       ASSERT(sctx->phase != SEND_PHASE_COMPUTE_DATA_SIZE);
> +
>         name = fs_path_alloc();
>         from_path = fs_path_alloc();
>         if (!name || !from_path) {
>
> I looked around and found nothing that looked similar enough.
> Obviously it's an assert, so I can run without it, but my source being
> very different from yours just made me want to check that this was most
> likely ok to run with 3.14.0.

This is based on top of btrfs-next plus previous send patches sent to
this list but not yet in btrfs-next.

>
> 2) I saw the concerns about protocol incompatibility. Is it an issue if you run without -o
> too?

No. See the discussion above. Using a send stream created with the new
flag won't work with an old btrfs receive. But to be able to get a
send stream with the new flag you need the patched btrfs receive
(unless you plan to write your own code to call the send ioctl
directly).

>
> 3) Do you have a patch for btrfs-tools so that I can try it, or a git
> tree of btrfs-tools with this that I should pull?

Yes, without it I couldn't test it and it would be pointless. There's
a patch in the list for btrfs-progs.  I've also pasted a link to it
(and this one too) in reply to the thread you started days ago.

>
> 4) Can I run btrfs send -o snap1 snap2 >/dev/null to get quick stats
> on the changes between the 2 snapshots, or is it still going to walk
> through all the data blocks and send them to /dev/null afterwards?

No, but it's doable and implies only extending the user space tools.
What is implemented is explained in the commit log for the btrfs-progs
patch.

Thanks

>
> Thanks,
> Marc
> --
> "A mouse is a device used to point at the xterm you want to type in" - A.S.R.
> Microsoft is to operating systems ....
>                                       .... what McDonalds is to gourmet cooking
> Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
