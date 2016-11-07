Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f171.google.com ([209.85.161.171]:34279 "EHLO
        mail-yw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932380AbcKGRsm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Nov 2016 12:48:42 -0500
Received: by mail-yw0-f171.google.com with SMTP id t125so148255134ywc.1
        for <linux-btrfs@vger.kernel.org>; Mon, 07 Nov 2016 09:48:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20161107140200.GM12522@suse.cz>
References: <2855552b-714c-d1de-08f9-89153c293772@wellbehavedsoftware.com> <20161107140200.GM12522@suse.cz>
From: Mark Fasheh <mark@fasheh.com>
Date: Mon, 7 Nov 2016 09:48:41 -0800
Message-ID: <CAGe7X7n=xkveD4TS2cyfXx5-hydOCHTh=tjDK54h8HWpnK5NqQ@mail.gmail.com>
Subject: Re: Announcing btrfs-dedupe
To: dsterba@suse.cz, James Pharaoh <james@wellbehavedsoftware.com>,
        linux-btrfs@vger.kernel.org, Mark Fasheh <mark@fasheh.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi David and James,

On Mon, Nov 7, 2016 at 6:02 AM, David Sterba <dsterba@suse.cz> wrote:
> On Sun, Nov 06, 2016 at 02:30:52PM +0100, James Pharaoh wrote:
>> I'm pleased to announce my btrfs deduplication utility, written in Rust.
>> This operates on whole files, is fast, and I believe complements the
>> existing utilities (duperemove, bedup), which exist currently.
>
> Mark can correct me if I'm wrong, but AFAIK, duperemove can consume
> output of fdupes, which does the whole file scanning for duplicates. And
> I think adding a whole-file dedup mode to duperemove would be better
> (from user's POV) than writing a whole new tool, eg. because of existing
> availability of duperemove in the distros.

Yeah you are correct - fdupes -r /foo | duperemove --fdupes  will get
you the same effect.

There's been a request for us to do all of that internally so that the
whole file dedupe works with the mtime checking code. This is entirely
doable. I would probably either add a field to the files table or add
a new table to hold whole-file hashes. We can then squeeze down our
existing block hashes into one big one or just rehash the whole file.


> Also looking to your roadmap, some of the items are implemented in
> duperemove: database of existing csums, cross filesystem boundary,
> mtime-based speedups).

Yeah, rescanning based on mtime was a huge speedup for Duperemove as
was keeping checksums in a db. We do all this today, also on XFS with
the dedupe ioctl (I believe this should be out with Linux-4.9).

Btw, there's lots of little details and bug fixes which I feel add up
to a relatively complete (though far from perfect!) tool. For example,
the dedupe code can handle multiple kernel versions including old
kernels which couldn't dedupe on non aligned block boundaries. Every
major step in duperemove is threaded at this point too which has also
been an enormous performance increase (which new features benefit
from).

Thanks,
    --Mark

-- 
"When the going gets weird, the weird turn pro."
Hunter S. Thompson
