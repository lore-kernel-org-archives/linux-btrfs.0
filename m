Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60389 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754344AbdEQRpA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 May 2017 13:45:00 -0400
Date: Wed, 17 May 2017 19:44:02 +0200
From: David Sterba <dsterba@suse.cz>
To: Josef Bacik <josef@toxicpanda.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        chandan@linux.vnet.ibm.com
Subject: Re: [PATCH 0/3] Kill btree inode prep patches
Message-ID: <20170517174402.GJ4065@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1493999835-26731-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1493999835-26731-1-git-send-email-jbacik@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 05, 2017 at 11:57:12AM -0400, Josef Bacik wrote:
> These three patches are just prep patches for the kill btree inode patch, they
> just move some stuff around so we don't depend on struct inode in places where
> we won't have one.  Once the other supporting generic code goes in I'll submit
> the kill btree inode patch as well.  Thanks,

I've fixed up patch 1, patchset added to 4.13 queue.
