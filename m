Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f173.google.com ([209.85.216.173]:35789 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932531AbaLLTYh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Dec 2014 14:24:37 -0500
MIME-Version: 1.0
In-Reply-To: <20141212190731.GB23804@ret.masoncoding.com>
References: <20141212190731.GB23804@ret.masoncoding.com>
Date: Fri, 12 Dec 2014 11:24:36 -0800
Message-ID: <CA+55aFzWDZ+3sAHHhZ_iourYAmh_3rfEk-u8H4d4b9=KcJb2gg@mail.gmail.com>
Subject: Re: [GIT PULL] Btrfs for 3.19-rc
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Chris Mason <clm@fb.com>, Linus Torvalds <torvalds@linux-foundation.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Dec 12, 2014 at 11:07 AM, Chris Mason <clm@fb.com> wrote:
>
> From a feature point of view, most of the code here comes from Miao Xie
> and others at Fujitsu to implement scrubbing and replacing devices on
> raid56.  This has been in development for a while, and it's a big
> improvement.

So this has probably happened before, and I just haven't been looking,
but I thought I'd mention it.

There are merges from github for this feature, and those merges aren't
signed, and don't have merge messages. Maybe you actually verified all
of it other ways, but there's no sign of it. I generally push back on
merging unsigned stuff from random hosting places (to the point where
I just refuse to do it, although it's possible that some pass though
just due to inattention), and I think that's just good practice in
general. And merges that don't explain what the merge does are just
bad merges (they are extra annoying when they are back-merges, but
it's a problem even otherwise).

Now, sometimes the "why did you merge" is obvious in just the merge
itself (maybe the branch name is already sufficient to explain some
trivial pull). But I thought I'd mention this as an area where the
kernel development process can still improve. I strive to make sure
that my merge commits have good messages (generally by asking
submaintainers to explain things to me in email or in the signed tag),
and I'm starting to try to encourage others to the same.

Again, this is probably something you've done before without me ever
mentioning/noticing it, and I really don't think the btrfs tree is at
all alone in this, but I thought I'd mention it since I happened to
react to it this time.

Regardless - pulled,

                      Linus
