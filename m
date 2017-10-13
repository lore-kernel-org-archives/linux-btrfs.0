Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35759 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751660AbdJMQIU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 13 Oct 2017 12:08:20 -0400
Date: Fri, 13 Oct 2017 18:06:34 +0200
From: David Sterba <dsterba@suse.cz>
To: Josef Bacik <josef@toxicpanda.com>
Cc: kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 14/21] btrfs: remove type argument from comp_tree_refs
Message-ID: <20171013160634.GZ3521@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1506714245-23072-1-git-send-email-jbacik@fb.com>
 <1506714245-23072-15-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1506714245-23072-15-git-send-email-jbacik@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 29, 2017 at 03:43:58PM -0400, Josef Bacik wrote:
> We can get this from the ref we've passed in.
> 
> Signed-off-by: Josef Bacik <jbacik@fb.com>

Reviewed-by: David Sterba <dsterba@suse.com>
