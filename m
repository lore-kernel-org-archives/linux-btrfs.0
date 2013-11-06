Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40585 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750841Ab3KFRJa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 6 Nov 2013 12:09:30 -0500
Date: Wed, 6 Nov 2013 18:09:25 +0100
From: David Sterba <dsterba@suse.cz>
To: dsterba@suse.cz, Jeff Mahoney <jeffm@suse.com>,
        linux-btrfs@vger.kernel.org, Josef Bacik <jbacik@fusionio.com>
Subject: Re: [PATCH 00/13] [PATCH 00/13] sysfs publishing patchset (v2)
Message-ID: <20131106170925.GZ16662@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20131101170654.164867629@suse.com>
 <20131106170226.GY16662@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20131106170226.GY16662@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 06, 2013 at 06:02:26PM +0100, David Sterba wrote:
> How is the mixed blockgroup setup presented? I guess that the values
> from used_bytes, total_bytes etc would be the same for data and metadata
> and the flags would denote that it's mixed.

Found, patch [10/13], it's 'mixed', no separate data or metadata
directories. All the combinations of BG types and raid profiles seem to
be covered.

david
