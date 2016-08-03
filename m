Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:33135 "EHLO
	mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756455AbcHCFmw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Aug 2016 01:42:52 -0400
Received: by mail-lf0-f67.google.com with SMTP id f93so11365940lfi.0
        for <linux-btrfs@vger.kernel.org>; Tue, 02 Aug 2016 22:42:51 -0700 (PDT)
Date: Wed, 3 Aug 2016 01:28:22 -0400
From: Sanidhya Solanki <lkml.page@gmail.com>
To: David Sterba <dsterba@suse.cz>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Change RAID stripesize to a user-configurable
 option
Message-ID: <20160803012822.5ad2dcce@ad>
In-Reply-To: <20160728113227.GS30795@twin.jikos.cz>
References: <1469194967-27734-1-git-send-email-lkml.page@gmail.com>
	<20160728113227.GS30795@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Any comments?

On Thu, 28 Jul 2016 13:32:27 +0200
David Sterba <dsterba@suse.cz> wrote:

> I'll comment on the overall approach and skip code-specific comments.
> 
> The changelog does not explain why there's a need for a new blockgroup
> type and what's the relation to the existing types. It seems that it
> extends the data/metadata/system group, but I think this is totally
> wrong.  

I agree in principle, but I did not want to modify the existing balance
targets, but, instead, piggyback on the existing balance implementation
to re-balance the data.
This approach was recommended to be by an experienced BTrFS developer
on the IRC as the right way to implement the change. My previous
implementation before asking on the IRC used a new ioctl call to
change the hard coded values and then re-write the data (not a good
approach in hindsight.)
 
> The proposed changes modify part of the on-disk format, that would
> require a incompat bit and brings the usual load of unpleasant issues
> with backward compatibility. The current data structures should be
> enough for configurable stripe size.  If you want to make stripe size
> configurable, then replace all hardcoded values of BTRFS_STRIPE_LEN.  

No re-balance required after passing the stripe size change command?
What about the on-disk metadata, that relies on the "stripesize" and
"stripe_len" as variables for calculations and the basis of pre-set
metadata?

Thanks
Sanidhya
