Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:55390 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754295Ab2LLXVP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Dec 2012 18:21:15 -0500
Received: by mail-qc0-f174.google.com with SMTP id o22so1085216qcr.19
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Dec 2012 15:21:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20121212225157.GD19051@carfax.org.uk>
References: <20121212224214.GA9195@lenny.home.zabbo.net> <20121212225157.GD19051@carfax.org.uk>
From: Nirbheek Chauhan <nirbheek.chauhan@gmail.com>
Date: Thu, 13 Dec 2012 04:50:54 +0530
Message-ID: <CADqQcK7OGPbj2CYwSwrk+1-GLfTJ1YYxh8eaDH3_1y+k_u1=2A@mail.gmail.com>
Subject: Re: no activity in kernel.org btrfs-progs git repo?
To: Hugo Mills <hugo@carfax.org.uk>, Zach Brown <zab@zabbo.net>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Dec 13, 2012 at 4:21 AM, Hugo Mills <hugo@carfax.org.uk> wrote:
>    Two things:
>
> 1) That tree is generally only ever updated for pull requests to Linus
>    during the merge window. Would that it were otherwise, but I
>    suspect that...
>
> 2) ... you may want to know about josef's btrfs-next tree:
>
> https://btrfs.wiki.kernel.org/index.php/Btrfs_source_repositories#Integration_repository_.28btrfs-next.29
>
>    It's regarded as fairly unstable, so only run it on systems for
> testing purposes (or if josef tells you it's OK and will fix one of
> your problems).
>

I think Zach was asking about the userspace tools, not the kernel
module. That link points to the kernel module integration branches,
and the link above that on the wiki page about btrfs-progs integration
hasn't had commits in the last 6 months, AFAICT.

I've been concerned about the status btrfs-progs maintenance myself.
I've seen quite a few obvious bugs about btrfs-progs on this list in
the past months—most of them with patches. However, I don't see them
enter any upstream git repositories.

Cheers,

--
~Nirbheek Chauhan
