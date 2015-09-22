Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:33258 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757787AbbIVNWT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Sep 2015 09:22:19 -0400
Date: Tue, 22 Sep 2015 16:19:36 +0300
From: Alexandru Moise <00moses.alexander00@gmail.com>
To: David Sterba <dsterba@suse.cz>
Cc: clm@fb.com, jbacik@fb.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs: memset cur_trans->delayed_refs to zero
Message-ID: <20150922131936.GA1757@gmail.com>
References: <20150907142437.GA21090@gmail.com>
 <20150922130454.GB12815@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150922130454.GB12815@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 22, 2015 at 03:04:54PM +0200, David Sterba wrote:
> On Mon, Sep 07, 2015 at 05:24:37PM +0300, Alexandru Moise wrote:
> > Use memset() to null out the btrfs_delayed_ref_root of
> > btrfs_transaction instead of setting all the members to 0 by hand.
> > 
> > Signed-off-by: Alexandru Moise <00moses.alexander00@gmail.com>
> 
> Reviewed-by: David Sterba <dsterba@suse.com>
> 
> Please use the versioning in patch subject so we know which version is
> the latest, like
> 
> [PATCH v4] btrfs: memset cur_trans->delayed_refs to zero

Alright, do you want me to resend it with the different subject tag
or shall I just keep that in mind for future patches?
