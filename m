Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:54390 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388614AbeGXVno (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 24 Jul 2018 17:43:44 -0400
Date: Tue, 24 Jul 2018 22:35:28 +0200
From: Adam Borowski <kilobyte@angband.pl>
To: dsterba@suse.cz, Mark Fasheh <mfasheh@suse.de>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH resend 1/2] btrfs: allow defrag on a file opened ro that
 has rw permissions
Message-ID: <20180724203528.mr4exunw5ivjk7d7@angband.pl>
References: <20180717220357.hn7mvajicpy7hu3l@angband.pl>
 <20180717220900.3588-1-kilobyte@angband.pl>
 <20180723152624.GO26141@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180723152624.GO26141@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 23, 2018 at 05:26:24PM +0200, David Sterba wrote:
> On Wed, Jul 18, 2018 at 12:08:59AM +0200, Adam Borowski wrote:
(Combined with as-folded)

| | btrfs: allow defrag on a file opened read-only that has rw permissions
| |
> > Requiring a rw descriptor conflicts both ways with exec, returning ETXTBSY
> > whenever you try to defrag a program that's currently being run, or
> > causing intermittent exec failures on a live system being defragged.
> > 
> > As defrag doesn't change the file's contents in any way, there's no reason
> > to consider it a rw operation.  Thus, let's check only whether the file
> > could have been opened rw.  Such access control is still needed as
> > currently defrag can use extra disk space, and might trigger bugs.
<-----
| | We give EINVAL when the request is invalid; here it's ok but merely the
| | user has insufficient privileges.  Thus, this return value reflects the
| | error better -- as discussed in the identical case for dedupe.
| |
| | According to codesearch.debian.net, no userspace program distinguishes
| | these values beyond strerror().
| |
| | Signed-off-by: Adam Borowski <kilobyte@angband.pl>
| | Reviewed-by: David Sterba <dsterba@suse.com>
| | [ fold the EPERM patch from Adam ]
| | Signed-off-by: David Sterba <dsterba@suse.com>

[...]
> So, I'll add the patch to 4.19 queue. It's small and isolated change so
> a revert would be easy in case we find something bad. The 2nd patch
> should be IMHO part of this change as it's logical to return the error
> code in the patch that modifies the user visible behaviour.

A nitpick: the new commit message has a dangling pointer "this" to the title
of the commit that was squashed.  It was:

| btrfs: defrag: return EPERM not EINVAL when only permissions fail

It'd be nice if it could be inserted in some form in the place I marked with
an arrow.

But then, commit messages are not vital.  The actual functionality patch has
been applied correctly.  And thanks for adding the comment.


Meow!
-- 
// If you believe in so-called "intellectual property", please immediately
// cease using counterfeit alphabets.  Instead, contact the nearest temple
// of Amon, whose priests will provide you with scribal services for all
// your writing needs, for Reasonable And Non-Discriminatory prices.
