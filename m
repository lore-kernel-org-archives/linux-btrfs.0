Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58646 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726876AbeHURLd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 21 Aug 2018 13:11:33 -0400
Date: Tue, 21 Aug 2018 15:51:06 +0200
From: David Sterba <dsterba@suse.cz>
To: Josef Bacik <josef@toxicpanda.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH 15/22] btrfs: run delayed iputs before committing
Message-ID: <20180821135106.GB24025@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180719145006.17532-1-josef@toxicpanda.com>
 <20180719145006.17532-15-josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180719145006.17532-15-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 19, 2018 at 10:49:59AM -0400, Josef Bacik wrote:
> We want to have a complete picture of any delayed inode updates before
> we make the decision to commit or not, so make sure we run delayed iputs
> before making the decision to commit or not.

This basically says "we need to do X, so we do X", lacking the
explanation why.
