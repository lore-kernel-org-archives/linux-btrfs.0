Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53507 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932886AbbIVNGH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Sep 2015 09:06:07 -0400
Date: Tue, 22 Sep 2015 15:05:11 +0200
From: David Sterba <dsterba@suse.cz>
To: Alexandru Moise <00moses.alexander00@gmail.com>
Cc: clm@fb.com, jbacik@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs: use a single if() statement for one outcome in
 get_block_rsv()
Message-ID: <20150922130511.GC12815@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20150909001850.GA892@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150909001850.GA892@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 09, 2015 at 12:18:50AM +0000, Alexandru Moise wrote:
> Rather than have three separate if() statements for the same outcome
> we should just OR them together in the same if() statement.
> 
> Signed-off-by: Alexandru Moise <00moses.alexander00@gmail.com>

Reviewed-by: David Sterba <dsterba@suse.com>
