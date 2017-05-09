Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52315 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752369AbdEIPA1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 9 May 2017 11:00:27 -0400
Date: Tue, 9 May 2017 17:00:18 +0200
From: David Sterba <dsterba@suse.cz>
To: Josef Bacik <josef@toxicpanda.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH 3/3] Btrfs: don't pass the inode through clean_io_failure
Message-ID: <20170509150018.GD5491@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1493999835-26731-1-git-send-email-jbacik@fb.com>
 <1493999835-26731-4-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1493999835-26731-4-git-send-email-jbacik@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 05, 2017 at 11:57:15AM -0400, Josef Bacik wrote:
> Instead pass around the failure tree and the io tree.
> 
> Signed-off-by: Josef Bacik <jbacik@fb.com>

Reviewed-by: David Sterba <dsterba@suse.com>
