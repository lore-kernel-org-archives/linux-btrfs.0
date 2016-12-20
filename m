Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48545 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934023AbcLTPcf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Dec 2016 10:32:35 -0500
Date: Tue, 20 Dec 2016 16:32:19 +0100
From: David Sterba <dsterba@suse.cz>
To: Josef Bacik <jbacik@fb.com>
Cc: Geliang Tang <geliangtang@gmail.com>, Chris Mason <clm@fb.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs: use rb_entry()
Message-ID: <20161220153218.GI3620@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <e7f25691fb620d01df75e3526897c7fb0e0ef6f8.1482158996.git.geliangtang@gmail.com>
 <1482165983.6766.0@smtp.office365.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1482165983.6766.0@smtp.office365.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 19, 2016 at 11:46:23AM -0500, Josef Bacik wrote:
> On Mon, Dec 19, 2016 at 9:53 AM, Geliang Tang <geliangtang@gmail.com> 
> wrote:
> > To make the code clearer, use rb_entry() instead of container_of() to
> > deal with rbtree.
> > 
> > Signed-off-by: Geliang Tang <geliangtang@gmail.com>
> 
> Reviewed-by: Josef Bacik <jbacik@fb.com>

Added to cleanups branch.
