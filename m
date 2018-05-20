Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:38887 "EHLO
        mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751102AbeETTLO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 20 May 2018 15:11:14 -0400
MIME-Version: 1.0
References: <cover.1526826466.git.dsterba@suse.com>
In-Reply-To: <cover.1526826466.git.dsterba@suse.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 20 May 2018 12:11:02 -0700
Message-ID: <CA+55aFydwYk7OU7k4fzaVF1VNBEJ8a38uv86xQd7hvpD5FTYFA@mail.gmail.com>
Subject: Re: [GIT PULL] Btrfs fixes for 4.17-rc6
To: David Sterba <dsterba@suse.com>
Cc: Chris Mason <clm@fb.com>, linux-btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, May 20, 2018 at 8:21 AM David Sterba <dsterba@suse.com> wrote:

> They IMHO qualify for a late rc, though I did not expect that many.

Especially with the tree-log.c changes being fairly big, I took a look, and
I have to say that I appreciate (a) the warning in the pull request and (b)
the extensive log messages explaining the problems these patches fix.

I obviously still prefer to see only small and simple one-liners just
before I'm making ready to release rc6, but in the absence of oneliners I
do appreciate good explanations.

Thanks,

                   Linus
