Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f179.google.com ([209.85.223.179]:34436 "EHLO
	mail-io0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758026AbcCVBQz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Mar 2016 21:16:55 -0400
MIME-Version: 1.0
In-Reply-To: <20160322002436.angclbg3eg6c65ik@floor.thefacebook.com>
References: <20160322002436.angclbg3eg6c65ik@floor.thefacebook.com>
Date: Mon, 21 Mar 2016 18:16:54 -0700
Message-ID: <CA+55aFzkbk=EVjqp6cx+OQXPadFGfFvaHHV59+CZFStFB8gGvQ@mail.gmail.com>
Subject: Re: [GIT PULL] Btrfs
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Chris Mason <clm@fb.com>, Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 21, 2016 at 5:24 PM, Chris Mason <clm@fb.com> wrote:
>
> I waited an extra day to send this one out because I hit a crash late
> last week with CONFIG_DEBUG_PAGEALLOC enabled (fixed in the top commit).

Hmm. If that commit helps, it will spit out a warning.

So is it actually fixed, or just hacked around to the point where you
don't get a page fault?

That WARN_ON_ONCE kind of implies it's a "this happens, but we don't know why".

                  Linus
