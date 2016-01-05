Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35353 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751472AbcAEOEA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 5 Jan 2016 09:04:00 -0500
Date: Tue, 5 Jan 2016 15:01:38 +0100
From: David Sterba <dsterba@suse.cz>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: linux-btrfs@vger.kernel.org, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH] btrfs: only free root_path if it was allocated from the
 heap
Message-ID: <20160105140138.GA4227@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1449168344-5803-1-git-send-email-nhorman@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1449168344-5803-1-git-send-email-nhorman@tuxdriver.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Dec 03, 2015 at 01:45:44PM -0500, Neil Horman wrote:
> Noticed this while doing some snapshots in a chroot environment
> 
> btrfs receive can set root_path to either realmnt, which is passed in from the
> command line, or to a heap allocated via find_mount_root  in do_receive.  We
> should only free the later, not the former, as the former results in an invalid
> pointer warning from glibc during free.
> 
> Signed-off-by: Neil Horman <nhorman@tuxdriver.com>

Sorry, I missed this patch, now applied, thanks.
