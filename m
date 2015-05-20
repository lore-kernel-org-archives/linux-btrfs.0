Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34746 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751631AbbETQkl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 May 2015 12:40:41 -0400
Date: Wed, 20 May 2015 18:40:39 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <Anand.Jain@oracle.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 00/27 V5] provide framework so that sysfs attributs from
 the fs_devices can be added
Message-ID: <20150520164039.GK23255@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1426845702-6298-1-git-send-email-anand.jain@oracle.com>
 <55239094.2010109@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <55239094.2010109@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 07, 2015 at 04:08:52PM +0800, Anand Jain wrote:
>   Can I check if this patch set is lined up for the integration branch ?
>   Any comments ?

I've noticed that the proposal to add an extra directory to the seeding
uuid hasn't been implemented.

http://article.gmane.org/gmane.comp.file-systems.btrfs/43095

  "I'm thinking about a representation of the possible relations between
  the devices. Seems that the seeding hierarchy for one filesystem is
  always linear, so it's ok to represent it by the filesystem UUID chain.

  /sys/fs/btrfs/UUID1/UUID2/UUID3

  What I still find unsatisfying is lack of any explicit naming attached
  to the UUIDs. As we can use lots of types of UUID, saying that "if it
  looks like an uuid if the main filesystem directory in sysfs, then it's
  the seeding filesystem" is not the best we can come up with.

  I don't have a final idea, but at least

  /sys/fs/btrfs/UUID1/seeding/UUID2/seeding/UUID3

  would look more friendly to the user and also more accssible to
  scripting. We coud possibly add other files/dirs to the inserted
  directory."

I still think that the plain UUID1/UUID2/... naming scheme is not
acceptable. Yes it is redundant in some way but also more descriptive.
