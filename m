Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59191 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751039AbdIAPa4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 1 Sep 2017 11:30:56 -0400
Date: Fri, 1 Sep 2017 17:29:28 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: josef@toxicpanda.com, linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        Josef Bacik <jbacik@fb.com>
Subject: Re: [PATCH][v2] btrfs-progs: print the csum length in debug-tree
Message-ID: <20170901152928.GS2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1503673906-14342-1-git-send-email-jbacik@fb.com>
 <55179339-8ff5-34fe-ff87-801c492f2edd@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <55179339-8ff5-34fe-ff87-801c492f2edd@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 25, 2017 at 06:17:23PM +0300, Nikolay Borisov wrote:
> 
> 
> On 25.08.2017 18:11, josef@toxicpanda.com wrote:
> > From: Josef Bacik <jbacik@fb.com>
> > 
> > While looking at a log of a corrupted fs I needed to verify we were
> > missing csums for a given range.  Make this easier by printing out the
> > range of bytes a csum item covers.
> > 
> > Signed-off-by: Josef Bacik <jbacik@fb.com>
> 
> Reviewed-by: Nikolay Borisov <nborisov@suse.com>

v2 applied, thanks.
