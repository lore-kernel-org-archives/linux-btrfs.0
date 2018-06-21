Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45358 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932666AbeFUJY4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 21 Jun 2018 05:24:56 -0400
Received: from relay1.suse.de (charybdis-ext-too.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 59BACAB46
        for <linux-btrfs@vger.kernel.org>; Thu, 21 Jun 2018 09:24:55 +0000 (UTC)
Date: Thu, 21 Jun 2018 11:22:05 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [RFC PATCH] btrfs: Remove V0 extent support
Message-ID: <20180621092205.GJ24375@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1529563500-1714-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1529563500-1714-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 21, 2018 at 09:45:00AM +0300, Nikolay Borisov wrote:
> The v0 compat code was introduced in commit 5d4f98a28c7d
> ("Btrfs: Mixed back reference  (FORWARD ROLLING FORMAT CHANGE)") 9
> years ago, which was merged in 2.6.31. This means that the code is
> there to support filesystems which are _VERY_ old and if you are using
> btrfs on such an old kernel, you have much bigger problems. This coupled
> with the fact that no one is likely testing/maintining this code likely
> means it has bugs lurking. All things considered I think 43 kernel
> releases later it's high time this remnant of the past got removed.

Ack. Given the age of the format and nearly zero chance of such
filesystem to be still in use it should be ok to remove it directly and
not add some sort of warning when such filesystem is found.

> This patch removes all code wrapped in #ifdefs but leaves the BUG_ONs in case
> we have a v0 with no support intact as a sort of safety-net. 

I think there should be some verbose way to report what happened and
possibly do proper error handling and go to read-only eventually.
The type of checks for v0 do not seem to be something that could be done
at mount time.
