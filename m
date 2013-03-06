Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54302 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754005Ab3CFSdR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 6 Mar 2013 13:33:17 -0500
Date: Wed, 6 Mar 2013 19:33:15 +0100
From: David Sterba <dsterba@suse.cz>
To: Blair Zajac <blair@orcaware.com>
Cc: David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: enhance superblock checks
Message-ID: <20130306183315.GE21081@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1362585400-13379-1-git-send-email-dsterba@suse.cz>
 <51377985.603@orcaware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <51377985.603@orcaware.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 06, 2013 at 09:14:45AM -0800, Blair Zajac wrote:
> On 03/06/2013 07:56 AM, David Sterba wrote:
> >  /*
> >+ * Return 0 if the superblock checksum type matches the checksum value of that
> >+ * alghorithm. Pass the raw disk superblock data.
> 
> I'm not familiar with the review policy on this list, but here's a minor
> one:
> 
> s/alghorithm/algorithm/

Thanks, review(er)s are always welcome.

Josef, I'll not resend the patch, please pull it from branch
dev/check-super in my git repo.

david
