Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55190 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751694AbdJTPhf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 Oct 2017 11:37:35 -0400
Date: Fri, 20 Oct 2017 17:35:46 +0200
From: David Sterba <dsterba@suse.cz>
To: Josef Bacik <josef@toxicpanda.com>
Cc: kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/8] Remaining queue
Message-ID: <20171020153546.GS3521@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1508436962-6851-1-git-send-email-josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1508436962-6851-1-git-send-email-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 19, 2017 at 02:15:54PM -0400, Josef Bacik wrote:
> Here's the updated batch of the remaining queue of patches from me.  I've
> addressed all of the outstanding review feedback for everything and they've been
> pretty thoroughly tested.  Most of the changes are around changelogs and adding
> comments, as well as switching to lockdep_assert_held from whatever crap I was
> using before.  Thanks,

Thanks. I've replaced the patches and moved them to the main 4.15 pile.
If anybody wants to do a final review and have the tag added, there's
still time.
