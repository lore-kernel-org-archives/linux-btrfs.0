Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39116 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751411AbeA3OMe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 30 Jan 2018 09:12:34 -0500
Date: Tue, 30 Jan 2018 15:10:21 +0100
From: David Sterba <dsterba@suse.cz>
To: Josef Bacik <josef@toxicpanda.com>
Cc: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Use schedule_timeout_interruptible
Message-ID: <20180130141021.GH19355@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1516711613-18533-1-git-send-email-nborisov@suse.com>
 <20180124153850.4qhg32efy73x5cfj@destiny>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180124153850.4qhg32efy73x5cfj@destiny>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 24, 2018 at 10:38:51AM -0500, Josef Bacik wrote:
> On Tue, Jan 23, 2018 at 02:46:53PM +0200, Nikolay Borisov wrote:
> > Instead of manually fiddling with the state of the task
> > (RUNNING->INTERRUPTIBLE->RUNNING) again just use schedule_timeout_interruptible
> > which adjusts the task state as needed. No functional changes.
> > 
> > Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> 
> Reviewed-by: Josef Bacik <jbacik@fb.com>

Added to next, thanks.
