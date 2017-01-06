Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44463 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1162965AbdAFMSX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 6 Jan 2017 07:18:23 -0500
Date: Fri, 6 Jan 2017 13:18:06 +0100
From: David Sterba <dsterba@suse.cz>
To: Filipe Manana <fdmanana@gmail.com>
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Filipe David Borba Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>, Josef Bacik <jbacik@fb.com>
Subject: Re: [PATCH] Btrfs: Fix deadlock between direct IO and fast fsync
Message-ID: <20170106121806.GB12081@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1482485418-4190-1-git-send-email-chandan@linux.vnet.ibm.com>
 <CAL3q7H4PgaJFnZPkgMMS5_9V3=3EJ8j1hbPZbBp+AcpYWQs2ww@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAL3q7H4PgaJFnZPkgMMS5_9V3=3EJ8j1hbPZbBp+AcpYWQs2ww@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 06, 2017 at 11:45:46AM +0000, Filipe Manana wrote:
> >From my point of view, it's ok and you can have:
> 
> Reviewed-by: Filipe Manana <fdmanana@suse.com>

Added to next and queued for 4.10, thanks.
