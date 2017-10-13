Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55466 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753466AbdJMODL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 13 Oct 2017 10:03:11 -0400
Date: Fri, 13 Oct 2017 16:01:25 +0200
From: David Sterba <dsterba@suse.cz>
To: Josef Bacik <josef@toxicpanda.com>
Cc: kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 05/21] btrfs: pass root to various extent ref mod
 functions
Message-ID: <20171013140125.GR3521@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1506714245-23072-1-git-send-email-jbacik@fb.com>
 <1506714245-23072-6-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1506714245-23072-6-git-send-email-jbacik@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 29, 2017 at 03:43:49PM -0400, Josef Bacik wrote:
> We need the actual root for the ref verifier tool to work, so change
> these functions to pass the root around instead.  This will be used in
> a subsequent patch.
> 
> Signed-off-by: Josef Bacik <jbacik@fb.com>

Reviewed-by: David Sterba <dsterba@suse.com>
