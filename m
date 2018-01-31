Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34679 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753639AbeAaOwu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 31 Jan 2018 09:52:50 -0500
Date: Wed, 31 Jan 2018 15:50:37 +0100
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: fdmanana@gmail.com, dsterba@suse.cz,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [RESEND PATCH] btrfs: Handle btrfs_set_extent_delalloc failure
 in relocate_file_extent_cluster
Message-ID: <20180131145037.GA18553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1516979117-15117-1-git-send-email-nborisov@suse.com>
 <1517322767-3044-1-git-send-email-nborisov@suse.com>
 <CAL3q7H7Zr=cOqw9ACLdT-YbAVkkoRCOkiQ1PQAoP5oxpKERnLA@mail.gmail.com>
 <f8066334-e24c-1dd8-0ca9-ff3e4958ed0f@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <f8066334-e24c-1dd8-0ca9-ff3e4958ed0f@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 31, 2018 at 12:53:38PM +0200, Nikolay Borisov wrote:
> > This is an unrelated change. Please don't mix pure white
> > space/indentation changes with functional changes.
> 
> David seems rather adamant in not accepting pure whitespace/indention
> changes on their own so I don't see a way to actually improve the code
> base in that regard unless i slip them up when modifying nearby code.

If it's an unrelated change, than it's wrong to slip it in just because
it's near. It's still an unrelated change. Other than that, and I think
I mentioned that in your previous attempts to add whitespace changes,
it just pollutes the commit history. Looking for a commit that
potentially broke some code and finding a whitespace change just makes
anybody grumpy. Maintaner should know and not let such changes in. I've
been on both sides, and based on this experience I will not let in such
changes.

The review process in the mailinglist is there to catch that and point
out, though pointing out just whitespace is kind of not welcome, unless
the real review is also done. If there are minor things to fix, I do
that at commit time, which means I edit majority of all patches or
changelogs. In some cases I will let the patch author know so I don't
have to fix that over and over again. (But it never lasts.)

> There are a couple of space with trailing whitespace which I constantly
> select out from my commits.
> 
> Given that you have now also expressed objection to such cleanups, how
> should they eventually be fixed?

They will be fixed once the code on those lines gets changed. Which may
not anytime soon.
