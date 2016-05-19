Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53168 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751399AbcESMIQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 May 2016 08:08:16 -0400
Date: Thu, 19 May 2016 14:07:47 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH 0/3] btrfs-progs: fixes on top of latest integration
 branch
Message-ID: <20160519120747.GC29147@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1463634794-591-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1463634794-591-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 19, 2016 at 01:13:11PM +0800, Anand Jain wrote:
>   Your latest branch integration-20160517 is failing with
>   make install, 1/3 will fix it. While here can you also
>   apply 2/3 and 3/3 as below, however they aren't related
>   though.

>   btrfs-progs: fix make install failure
>   btrfs-progs: add clean-all to the usage
>   btrfs-progs: clean up commands.h

2 and 3 applied, thanks. It's absolutelly ok to group such small misc
fixups.
