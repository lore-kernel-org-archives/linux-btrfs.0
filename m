Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:32874 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750989AbdBHSNm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 8 Feb 2017 13:13:42 -0500
Date: Wed, 8 Feb 2017 16:22:23 +0100
From: David Sterba <dsterba@suse.cz>
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        linux-block@vger.kernel.org, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 08/24] btrfs: Convert to separately allocated bdi
Message-ID: <20170208152223.GH3366@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170202173422.3240-1-jack@suse.cz>
 <20170202173422.3240-9-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170202173422.3240-9-jack@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 02, 2017 at 06:34:06PM +0100, Jan Kara wrote:
> Allocate struct backing_dev_info separately instead of embedding it
> inside superblock. This unifies handling of bdi among users.
> 
> CC: Chris Mason <clm@fb.com>
> CC: Josef Bacik <jbacik@fb.com>
> CC: David Sterba <dsterba@suse.com>
> CC: linux-btrfs@vger.kernel.org
> Signed-off-by: Jan Kara <jack@suse.cz>

Reviewed-by: David Sterba <dsterba@suse.com>
