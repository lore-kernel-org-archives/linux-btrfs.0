Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47225 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754544AbaDKRg3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Apr 2014 13:36:29 -0400
Date: Fri, 11 Apr 2014 19:36:28 +0200
From: David Sterba <dsterba@suse.cz>
To: Marc MERLIN <marc@merlins.org>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs-progs: Add device management related paragraph.
Message-ID: <20140411173628.GG29256@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1397184233-18535-1-git-send-email-quwenruo@cn.fujitsu.com>
 <20140411061048.GD7322@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140411061048.GD7322@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 10, 2014 at 11:10:48PM -0700, Marc MERLIN wrote:
> > --- a/Documentation/btrfs-replace.txt
> > +++ b/Documentation/btrfs-replace.txt
> > @@ -13,6 +13,9 @@ DESCRIPTION
> >  -----------
> >  'btrfs replace' is used to replace btrfs managed devices with other device.
> 
> I would add a quick line here saying that it's not currently supported for
> RAID5/6, and to see btrfs-device for add/delete to get around the replace
> missing problem.

I've added the quick note when committing the patch.
