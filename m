Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56366 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731711AbeGSQwW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Jul 2018 12:52:22 -0400
Date: Thu, 19 Jul 2018 18:08:21 +0200
From: David Sterba <dsterba@suse.cz>
To: Josef Bacik <josef@toxicpanda.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        Josef Bacik <jbacik@fb.com>
Subject: Re: [PATCH 01/22] btrfs: add btrfs_delete_ref_head helper
Message-ID: <20180719160821.GW26141@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180719145006.17532-1-josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180719145006.17532-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Please send cover letter for patchsets with more than 1 patch.
Especially for a patchset with 20+ patches that does not seem to be
doing anything trivial.

What problem does this fix, what's the overall idea behind the approach,
what workload can trigger that etc.

Thanks.
