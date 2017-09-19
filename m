Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f169.google.com ([209.85.220.169]:56365 "EHLO
        mail-qk0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750964AbdISLa7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Sep 2017 07:30:59 -0400
Received: by mail-qk0-f169.google.com with SMTP id u7so3209391qku.13
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Sep 2017 04:30:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <caf3072a-0c70-7c1d-fe55-40f01d410464@cobb.uk.net>
References: <CAH=dxU5NfenfKfsuXuZ8uBYKBb5a0VOEqan6taAwZTT0oM8xcQ@mail.gmail.com>
 <caf3072a-0c70-7c1d-fe55-40f01d410464@cobb.uk.net>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Date: Tue, 19 Sep 2017 14:30:57 +0300
Message-ID: <CAA91j0Ve_46RM6DFTqs52g=GK4+g7TgAbK8FYBskdEe4puYCjg@mail.gmail.com>
Subject: Re: difference between -c and -p for send-receive?
To: Graham Cobb <g.btrfs@cobb.uk.net>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 19, 2017 at 1:24 PM, Graham Cobb <g.btrfs@cobb.uk.net> wrote:
> On 19/09/17 01:41, Dave wrote:
>> Would it be correct to say the following?
>
> Like Duncan, I am just a user, and I haven't checked the code. I
> recommend Duncan's explanation, but in case you are looking for
> something simpler, how about thinking with the following analogy...
>
> Think of -p as like doing an incremental backup: it tells send to just
> send the instructions for the changes to get from the "parent" subvolume
> to the current subvolume. Without -p it is like a full backup:
> everything in the current subvolume is sent.
>
> -c is different:

It is not really different - it is extra. You have -p and optionally
-c which modifies its behavior.

> it says "and by the way, these files also already exist
> on the destination so they might be useful to skip actually sending some
> of the file contents". Imagine that whenever a file content is about to
> be sent (whether incremental or full), btrfs-send checks to see if the
> data is in one of the -c subvolumes and, if it is, it sends "get the
> data by reflinking to this file over here" instead of sending the data
> itself. -c is really just an optimisation to save sending data if you
> know the data is already available somewhere else on the destination.
>
> Be aware that this is really just an analogy (like "hard linking" is an
> analogy for reflinking using the clone range ioctl). Duncan's email
> provides more real details.
>
> In particular, this analogy doesn't explain the original questioner's
> problem. In the analogy, -c might work without the files actually being
> present on the source (as long as they are on the destination). But, in
> reality, because the underlying mechanism is extent range cloning, the
> files have to be present on **both** the source and the destination in
> order for btrfs-send to work out what commands to send.
>

Yes. Decision whether to send full data or reflink is taken on source,
so data must be present on source.

> By the way, like Duncan, I was surprised that the man page suggests that
> -c without -p causes one of the clones to be treated as a parent. I have
> not checked the code to see if that is actually how it works.
>

It is. As implemented, -c *requires* parent snapshot, either
explicitly via -p option or implicitly. What it does:

a) checks that both snapshot to transfer and all snapshots given as
arguments to -c have the same parent uuid;
b) selects "best match" by comparing how close snapshots from -c
option are to parent. As far as I can tell it chooses the oldest
snapshot (with minimal difference to the parent) as base (implicit
-p).

Which implies that "btrfs send -c foo bar" is entirely equivalent to
"btrfs send -p foo bar".

Which still does not explain why script fails. As mentioned, as
snapshots created by snapper should have the same parent uuid, which
leaves only possibility of non-existent subvolume, but then script
should have failed much earlier.
