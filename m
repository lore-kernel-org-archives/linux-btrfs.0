Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53197 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S966061AbcIHRD2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 8 Sep 2016 13:03:28 -0400
Date: Thu, 8 Sep 2016 19:01:52 +0200
From: David Sterba <dsterba@suse.cz>
To: Josef Bacik <jbacik@fb.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH 4/7] Btrfs: kill the start argument to
 read_extent_buffer_pages
Message-ID: <20160908170152.GN16983@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1472845206-22870-1-git-send-email-jbacik@fb.com>
 <1472845206-22870-5-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1472845206-22870-5-git-send-email-jbacik@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 02, 2016 at 03:40:03PM -0400, Josef Bacik wrote:
> Nobody uses this, it makes no sense to do partial reads of extent buffers.
> 
> Signed-off-by: Josef Bacik <jbacik@fb.com>

Reviewed-by: David Sterba <dsterba@suse.com>

Same here, picked to 4.9.
