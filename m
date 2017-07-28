Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54051 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752370AbdG1P2c (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Jul 2017 11:28:32 -0400
Date: Fri, 28 Jul 2017 17:27:13 +0200
From: David Sterba <dsterba@suse.cz>
To: josef@toxicpanda.com
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        Josef Bacik <jbacik@fb.com>
Subject: Re: [PATCH 1/2][v2] btrfs: fix readdir deadlock with pagefault
Message-ID: <20170728152713.GR2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1500923666-29670-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1500923666-29670-1-git-send-email-jbacik@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 24, 2017 at 03:14:25PM -0400, josef@toxicpanda.com wrote:
> From: Josef Bacik <jbacik@fb.com>
> 
> Readdir does dir_emit while under the btree lock.  dir_emit can trigger
> the page fault which means we can deadlock.  Fix this by allocating a
> buffer on opening a directory and copying the readdir into this buffer
> and doing dir_emit from outside of the tree lock.
> 
> Signed-off-by: Josef Bacik <jbacik@fb.com>

Reviewed-by: David Sterba <dsterba@suse.com>
