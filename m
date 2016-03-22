Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f174.google.com ([209.85.223.174]:33740 "EHLO
	mail-io0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932238AbcCVCie (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Mar 2016 22:38:34 -0400
MIME-Version: 1.0
In-Reply-To: <20160322022412.zpsdrxiocoivcnwg@floor.thefacebook.com>
References: <20160322002436.angclbg3eg6c65ik@floor.thefacebook.com>
	<CA+55aFzkbk=EVjqp6cx+OQXPadFGfFvaHHV59+CZFStFB8gGvQ@mail.gmail.com>
	<20160322021533.xqalzzk5itglqu3x@floor.thefacebook.com>
	<20160322022412.zpsdrxiocoivcnwg@floor.thefacebook.com>
Date: Mon, 21 Mar 2016 19:38:33 -0700
Message-ID: <CA+55aFwe58WRAYC_+rhkGRPmS5FjdckxHa1KS0kpqv8RYbb9eg@mail.gmail.com>
Subject: Re: [GIT PULL] Btrfs
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Chris Mason <clm@fb.com>, Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 21, 2016 at 7:24 PM, Chris Mason <clm@fb.com> wrote:
>
> Hmmm, rereading my answer I realized I didn't actually answer.  I really
> think this is fixed.  I left the warning only because I originally
> expected something much more exotic.

Ok. It's more that you said the top commit fixes a problem, and the
only case where the top commit makes a difference it will also do that
WARN_ON_ONCE.

But it's pulled, test-built, and pushed out now.

              Linus
