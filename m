Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58914 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753170AbeBERzc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 5 Feb 2018 12:55:32 -0500
Date: Mon, 5 Feb 2018 18:53:17 +0100
From: David Sterba <dsterba@suse.cz>
To: Howard McLauchlan <hmclauchlan@fb.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        Omar Sandoval <osandov@osandov.com>, Josef Bacik <jbacik@fb.com>
Subject: Re: [PATCH v3] btrfs: print error if primary super block write fails
Message-ID: <20180205175317.GH18553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180202190901.10988-1-hmclauchlan@fb.com>
 <f3f85aff-7db1-a75b-31ca-69bc123795b6@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <f3f85aff-7db1-a75b-31ca-69bc123795b6@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 02, 2018 at 11:19:59AM -0800, Howard McLauchlan wrote:
> On 02/02/2018 11:09 AM, Howard McLauchlan wrote:
> > Presently, failing a primary super block write but succeeding in at
> > least one super block write in general will appear to users as if
> > nothing important went wrong. However, upon unmounting and re-mounting,
> > the file system will be in a rolled back state. This was discovered
> > with a BCC program that uses bpf_override_return() to fail super block
> > writes.
> > 
> > This patch outputs an error clarifying that the primary super block
> > write has failed, so users can expect potentially erroneous behaviour.
> > It also forces wait_dev_supers() to return an error to its caller if
> > the primary super block write fails.
> > 
> > Signed-off-by: Howard McLauchlan <hmclauchlan@fb.com>
> Reviewed-by: Qu Wenruo <wqu@suse.com>

Added to next, thanks.
