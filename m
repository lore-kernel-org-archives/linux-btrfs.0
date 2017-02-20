Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f44.google.com ([209.85.214.44]:33950 "EHLO
        mail-it0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753010AbdBTRgm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 20 Feb 2017 12:36:42 -0500
Received: by mail-it0-f44.google.com with SMTP id k200so26292335itb.1
        for <linux-btrfs@vger.kernel.org>; Mon, 20 Feb 2017 09:36:41 -0800 (PST)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <f1156c2d-20d1-eb7c-6d48-207d22a34512@suse.de>
References: <f1156c2d-20d1-eb7c-6d48-207d22a34512@suse.de>
From: Filipe Manana <fdmanana@gmail.com>
Date: Mon, 20 Feb 2017 17:28:38 +0000
Message-ID: <CAL3q7H4+7iTC1toTBitaMZ8sbbgXF92z6nUMDu-4NvvhMP5N-Q@mail.gmail.com>
Subject: Re: Why is btrfs_run_delayed_refs() run multiple times
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 20, 2017 at 5:08 PM, Goldwyn Rodrigues <rgoldwyn@suse.de> wrote:
> Hi,
>
> Why do we call btrfs_run_delayed_refs multiple times in a function? Some
> of the examples are:
>
> btrfs_commit_transaction()
> commit_cowonly_roots()
>
> Is it because one call can generate more delayed refs and hence we need
> to run them again? Under what scenarios is this possible?

All extents, for both data and metadata, are reference counted and
have back references in the extent tree. Adding/updating/removing
things to/in/from a tree implies COWing metadata extents (tree nodes
and leaves), which implies generating more delayed references.
Eventually this loop stops, as metadata extents are COWed only once
per transaction or more times if writeback was triggered.
So it's possible in all scenarios.

>
> --
> Goldwyn
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

"People will forget what you said,
 people will forget what you did,
 but people will never forget how you made them feel."
