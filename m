Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43747 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751339AbeEVORV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 May 2018 10:17:21 -0400
Date: Tue, 22 May 2018 16:14:38 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
        jamespharvey20@gmail.com
Subject: Re: [PATCH 3/4] btrfs: lzo: Add header length check to avoid slab
 out of bounds access
Message-ID: <20180522141438.GM6649@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180517062753.25973-1-wqu@suse.com>
 <20180517062753.25973-4-wqu@suse.com>
 <fb4e4d06-81c1-1e1d-d8b6-c2b249fb2750@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <fb4e4d06-81c1-1e1d-d8b6-c2b249fb2750@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 17, 2018 at 11:14:46AM +0300, Nikolay Borisov wrote:
> srclen  comes from the async_extent struct, which in turns is
> initialized in compress_file_range with the value of "total_compressed",
> and the value there is actually initialized by
> btrfs_compress_pages->lzo_compress_pages (that code makes me wanna sing
> "You spin me right round, baby Right round like a record, baby").

I have a dusted patch that reworks the whole loop to something more
understandable, I can post it with some other pending compression
updates.
