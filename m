Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60452 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751558AbbFYQKK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Jun 2015 12:10:10 -0400
Date: Thu, 25 Jun 2015 18:10:08 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org, fdmanana@suse.com
Subject: Re: [RFC PATCH v2 2/2] Btrfs: improve fsync for nocow file
Message-ID: <20150625161008.GL726@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1434527672-5762-1-git-send-email-bo.li.liu@oracle.com>
 <1434527672-5762-2-git-send-email-bo.li.liu@oracle.com>
 <20150617155836.GZ6761@twin.jikos.cz>
 <20150618032722.GB8530@localhost.localdomain>
 <20150624182130.GD726@suse.cz>
 <20150625022424.GA23794@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150625022424.GA23794@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 25, 2015 at 10:24:25AM +0800, Liu Bo wrote:
> > I'm not sure I understand, you mean split the NOISIZE into two bits and
> > use NOISIZE just for inode size change and the other one for the
> > cow_file_range case?
> 
> Yes, for now it has mixed meanings, either changing i_size or doing Cow.
> But I think it'd better to leave it mixed if we document it well.

Agreed, please also comment the new fsync code that actually uses the
nocow + notimestamp + noisize bits.
