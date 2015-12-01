Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45988 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750795AbbLAPOz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 1 Dec 2015 10:14:55 -0500
Date: Tue, 1 Dec 2015 16:13:05 +0100
From: David Sterba <dsterba@suse.cz>
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 05/10] btrfs: Use xattr handler infrastructure
Message-ID: <20151201151305.GB31035@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1448919823-27103-1-git-send-email-agruenba@redhat.com>
 <1448919823-27103-6-git-send-email-agruenba@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1448919823-27103-6-git-send-email-agruenba@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 30, 2015 at 10:43:38PM +0100, Andreas Gruenbacher wrote:
> Use the VFS xattr handler infrastructure and get rid of similar code in
> the filesystem.
> 
> Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
> Cc: Chris Mason <clm@fb.com>
> Cc: Josef Bacik <jbacik@fb.com>
> Cc: David Sterba <dsterba@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>
