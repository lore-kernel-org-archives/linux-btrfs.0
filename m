Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:35819 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751410Ab2FFJYq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 6 Jun 2012 05:24:46 -0400
Date: Wed, 6 Jun 2012 11:24:28 +0200
From: David Sterba <dave@jikos.cz>
To: Asias He <asias@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        Chris Mason <chris.mason@oracle.com>, Jens Axboe <axboe@kernel.dk>,
        jeffm@suse.com
Subject: Re: [PATCH 1/2] btrfs: Drop unused function btrfs_abort_devices()
Message-ID: <20120606092427.GD32402@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <1337915422-24988-1-git-send-email-asias@redhat.com>
 <20120528134159.GT24394@twin.jikos.cz>
 <4FCEBDB8.800@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4FCEBDB8.800@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 06, 2012 at 10:17:28AM +0800, Asias He wrote:
> Hello, Jeff
> >This was added in 49b25e0540904be0bf558b84475c69d72e4de66e adding a
> >transaction abort infrastructure.  I'm not sure if Jeff had some
> >intentions with it or whether it got obsolete during the patchset long
> >evolution, CCed.
> 
> Any comments?

Has been merged via the 3.5 -rc1 pull, commit
d07eb9117050c9ed3f78296ebcc06128b52693be

david
