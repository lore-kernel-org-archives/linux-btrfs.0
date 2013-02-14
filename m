Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34429 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755542Ab3BNMrV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Feb 2013 07:47:21 -0500
Date: Thu, 14 Feb 2013 13:47:20 +0100
From: David Sterba <dsterba@suse.cz>
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: place ordered operations on a per transaction list
Message-ID: <20130214124720.GK12339@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1360772002-8923-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1360772002-8923-1-git-send-email-jbacik@fusionio.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 13, 2013 at 11:13:22AM -0500, Josef Bacik wrote:
> Miao made the ordered operations stuff run async, which introduced a
> deadlock where we could get somebody (sync) racing in and committing the
> transaction while a commit was already happening.  The new committer would
> try and flush ordered operations which would hang waiting for the commit to
> finish because it is done asynchronously and no longer inherits the callers
> trans handle.  To fix this we need to make the ordered operations list a per
> transaction list.  We can get new inodes added to the ordered operation list
> by truncating them and then having another process writing to them, so this
> makes it so that anybody trying to add an ordered operation _must_ start a
> transaction in order to add itself to the list, which will keep new inodes
> from getting added to the ordered operations list after we start committing.
> This should fix the deadlock and also keeps us from doing a lot more work
> than we need to during commit.  Thanks,

No deadlock after several hours of xfstests with various mkfs and mount
options.

Tested-by: David Sterba <dsterba@suse.cz>
