Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35997 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753801Ab3CKSQh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Mar 2013 14:16:37 -0400
Date: Mon, 11 Mar 2013 19:16:35 +0100
From: David Sterba <dsterba@suse.cz>
To: Eric Sandeen <sandeen@redhat.com>
Cc: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/3] btrfs-progs: use BTRFS_SCAN_BACKUP_SB flag in
 btrfs_scan_one_device
Message-ID: <20130311181635.GH7229@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1362756300-30212-1-git-send-email-anand.jain@oracle.com>
 <1362756300-30212-4-git-send-email-anand.jain@oracle.com>
 <513DF252.8070109@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <513DF252.8070109@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 11, 2013 at 10:03:46AM -0500, Eric Sandeen wrote:
> IMHO, nothing should be checking the backup superblocks unless explicitly
> told to.

That's the whole point I believe.

update the infrastructure, every SB access looks to the first copy
unless told by command line options.


david
