Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42996 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750732AbdEBPgD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 2 May 2017 11:36:03 -0400
Date: Tue, 2 May 2017 17:35:56 +0200
From: David Sterba <dsterba@suse.cz>
To: dsterba@suse.cz, "Lakshmipathi.G" <Lakshmipathi.G@giis.co.in>,
        quwenruo@cn.fujitsu.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: btrfs-convert: Add larger device support
Message-ID: <20170502153556.GM23260@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170427100534.GA10404@giis.co.in>
 <20170502150601.GK23260@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170502150601.GK23260@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 02, 2017 at 05:06:01PM +0200, David Sterba wrote:
> On Thu, Apr 27, 2017 at 03:35:34PM +0530, Lakshmipathi.G wrote:
> > Bug: Fail to convert 22TB EXT4 to BTRFS
> > https://bugzilla.kernel.org/show_bug.cgi?id=194795
> 
> Thanks for working on the bug, the proposed fix looks good to me judging
> by the use of extended API. This would need a test though. I'm trying
> this on a sparse file, 3TB occupies 50G and is slow to create.
> Conversion works and hasn't finished yet, so this is not suitable for
> tests run by default.

So it took a few more minutes. I'm testing it again, not on NFS,  and
now the creation of empty filesystem took just a few seconds and empty
file is ~160MB. This sounds much better. So please write a test, using
something like

truncate -s3T image
mkfs.ext4 image
mount && write some data
convert && rollback

Thanks.  Later we might need to add some mkfs.ext4 option coverage.
