Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56298 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753051AbaJFQmx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 6 Oct 2014 12:42:53 -0400
Date: Mon, 6 Oct 2014 18:42:51 +0200
From: David Sterba <dsterba@suse.cz>
To: Josef Bacik <jbacik@fb.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs-progs: make free space cache less noisy
Message-ID: <20141006164251.GB11436@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1412172669-1975-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1412172669-1975-1-git-send-email-jbacik@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 01, 2014 at 10:11:09AM -0400, Josef Bacik wrote:
> Fsck only cares if the cache is really broken, so don't be noisy if the
> generations don't match or other such errors.  Thanks,

Let's put the messages under a --verbose option if they're just noise.
I'll send a followup patch.
