Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:40483 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434AbcAEORV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Jan 2016 09:17:21 -0500
Date: Tue, 5 Jan 2016 09:17:10 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org, Josef Bacik <jbacik@fb.com>
Subject: Re: [PATCH] btrfs: only free root_path if it was allocated from the
 heap
Message-ID: <20160105141710.GA6607@hmsreliant.think-freely.org>
References: <1449168344-5803-1-git-send-email-nhorman@tuxdriver.com>
 <20160105140138.GA4227@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160105140138.GA4227@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 05, 2016 at 03:01:38PM +0100, David Sterba wrote:
> On Thu, Dec 03, 2015 at 01:45:44PM -0500, Neil Horman wrote:
> > Noticed this while doing some snapshots in a chroot environment
> > 
> > btrfs receive can set root_path to either realmnt, which is passed in from the
> > command line, or to a heap allocated via find_mount_root  in do_receive.  We
> > should only free the later, not the former, as the former results in an invalid
> > pointer warning from glibc during free.
> > 
> > Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
> 
> Sorry, I missed this patch, now applied, thanks.
> 

Thanks!
Neil

