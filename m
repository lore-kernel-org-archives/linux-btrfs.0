Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56800 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753481AbdJMOZD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 13 Oct 2017 10:25:03 -0400
Date: Fri, 13 Oct 2017 16:23:17 +0200
From: David Sterba <dsterba@suse.cz>
To: Josef Bacik <josef@toxicpanda.com>
Cc: kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 06/21] Btrfs: add a extent ref verify tool
Message-ID: <20171013142317.GS3521@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1506714245-23072-1-git-send-email-jbacik@fb.com>
 <1506714245-23072-7-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1506714245-23072-7-git-send-email-jbacik@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 29, 2017 at 03:43:50PM -0400, Josef Bacik wrote:
> We were having corruption issues that were tied back to problems with the extent
> tree.  In order to track them down I built this tool to try and find the
> culprit, which was pretty successful.  If you compile with this tool on it will
> live verify every ref update that the fs makes and make sure it is consistent
> and valid.  I've run this through with xfstests and haven't gotten any false
> positives.  Thanks,
> 
> Signed-off-by: Josef Bacik <jbacik@fb.com>

Reviewed-by: David Sterba <dsterba@suse.com>

I've fixed the error messages, they should not start with an uppercase
letter and must not end with \n, and can be un-indented so they fit as
much as possible under 80.
