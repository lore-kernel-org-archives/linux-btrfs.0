Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50621 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758402AbdJMM57 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 13 Oct 2017 08:57:59 -0400
Date: Fri, 13 Oct 2017 14:56:13 +0200
From: David Sterba <dsterba@suse.cz>
To: Josef Bacik <josef@toxicpanda.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH][v2] btrfs: fix send ioctl on 32bit with 64bit kernel
Message-ID: <20171013125613.GM3521@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1506523393-9542-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1506523393-9542-1-git-send-email-jbacik@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 27, 2017 at 10:43:13AM -0400, Josef Bacik wrote:
> We pass in a pointer in our send arg struct, this means the struct size doesn't
> match with 32bit user space and 64bit kernel space.  Fix this by adding a compat
> mode and doing the appropriate conversion.
> 
> Signed-off-by: Josef Bacik <jbacik@fb.com>

Reviewed-by: David Sterba <dsterba@suse.com>

I've moved the structure declaration next to the one for receive on 32/64,
the comment applies to both.
