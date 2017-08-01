Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail02.iobjects.de ([188.40.134.68]:56084 "EHLO
        mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751761AbdHASPp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Aug 2017 14:15:45 -0400
Subject: Re: Odd fallocate behavior on BTRFS.
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>
References: <80c607b1-8798-8b86-8657-df2c1992186c@gmail.com>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Message-ID: <91e33876-8f21-cd92-6b52-84dd2fb085b7@applied-asynchrony.com>
Date: Tue, 1 Aug 2017 20:15:43 +0200
MIME-Version: 1.0
In-Reply-To: <80c607b1-8798-8b86-8657-df2c1992186c@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 08/01/17 19:34, Austin S. Hemmelgarn wrote:
[..]
> Apparently, if you call fallocate() on a file with an offset of 0 and
> a length longer than the length of the file itself, BTRFS will
> allocate that exact amount of space, instead of just filling in holes
> in the file and allocating space to extend it.  If there isn't enough
> space on the filesystem for this, then it will fail, even though it
> would succeed on ext4, XFS, and F2FS.
[..]
> I'm curious to hear anybody's thoughts on this, namely: 1. Is this
> behavior that should be considered implementation defined? 2. If not,
> is my assessment that BTRFS is behaving incorrectly in this case
> accurate?

IMHO no and yes, respectively. Both fallocate(2) and posix_fallocate(3)
make it very clear that the expected default behaviour is to extend.
I don't think this can be interpreted in any other way than incorrect
behaviour on behalf of btrfs.

Your script reproduces for me, so that's a start.

-h
