Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36321 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751975AbdI2RBM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Sep 2017 13:01:12 -0400
Date: Fri, 29 Sep 2017 18:59:37 +0200
From: David Sterba <dsterba@suse.cz>
To: Josef Bacik <josef@toxicpanda.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com, dsterba@suse.cz,
        jeffm@suse.com
Subject: Re: [PATCH] btrfs-progs: fix invalid assert in backref.c
Message-ID: <20170929165937.GQ31640@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1506632100-6293-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1506632100-6293-1-git-send-email-jbacik@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 28, 2017 at 04:55:00PM -0400, Josef Bacik wrote:
> This should be verify'ing that we have an empty key, not that we have a
> filled out key.
> 
> Signed-off-by: Josef Bacik <jbacik@fb.com>
> ---
> Dave this is on top of your ext/jeffm/extent-cache branch and fixes the segfault
> you reported.

Great, thanks for the fix. I'll fold it to the original patch so the
branches remain bisectable.
