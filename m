Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zaphod.cobb.me.uk ([213.138.97.131]:55388 "EHLO
        zaphod.cobb.me.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750948AbdISKYQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Sep 2017 06:24:16 -0400
Received: from black.home.cobb.me.uk (unknown [192.168.0.205])
        by zaphod.cobb.me.uk (Postfix) with ESMTP id 35EC89BA09
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Sep 2017 11:24:14 +0100 (BST)
Received: from [192.168.0.211] (novatech.home.cobb.me.uk [192.168.0.211])
        by black.home.cobb.me.uk (Postfix) with ESMTPS id 0CA8F5FAEB
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Sep 2017 11:24:14 +0100 (BST)
Subject: Re: difference between -c and -p for send-receive?
To: linux-btrfs@vger.kernel.org
References: <CAH=dxU5NfenfKfsuXuZ8uBYKBb5a0VOEqan6taAwZTT0oM8xcQ@mail.gmail.com>
From: Graham Cobb <g.btrfs@cobb.uk.net>
Message-ID: <caf3072a-0c70-7c1d-fe55-40f01d410464@cobb.uk.net>
Date: Tue, 19 Sep 2017 11:24:13 +0100
MIME-Version: 1.0
In-Reply-To: <CAH=dxU5NfenfKfsuXuZ8uBYKBb5a0VOEqan6taAwZTT0oM8xcQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 19/09/17 01:41, Dave wrote:
> Would it be correct to say the following?

Like Duncan, I am just a user, and I haven't checked the code. I
recommend Duncan's explanation, but in case you are looking for
something simpler, how about thinking with the following analogy...

Think of -p as like doing an incremental backup: it tells send to just
send the instructions for the changes to get from the "parent" subvolume
to the current subvolume. Without -p it is like a full backup:
everything in the current subvolume is sent.

-c is different: it says "and by the way, these files also already exist
on the destination so they might be useful to skip actually sending some
of the file contents". Imagine that whenever a file content is about to
be sent (whether incremental or full), btrfs-send checks to see if the
data is in one of the -c subvolumes and, if it is, it sends "get the
data by reflinking to this file over here" instead of sending the data
itself. -c is really just an optimisation to save sending data if you
know the data is already available somewhere else on the destination.

Be aware that this is really just an analogy (like "hard linking" is an
analogy for reflinking using the clone range ioctl). Duncan's email
provides more real details.

In particular, this analogy doesn't explain the original questioner's
problem. In the analogy, -c might work without the files actually being
present on the source (as long as they are on the destination). But, in
reality, because the underlying mechanism is extent range cloning, the
files have to be present on **both** the source and the destination in
order for btrfs-send to work out what commands to send.

By the way, like Duncan, I was surprised that the man page suggests that
-c without -p causes one of the clones to be treated as a parent. I have
not checked the code to see if that is actually how it works.

Graham
