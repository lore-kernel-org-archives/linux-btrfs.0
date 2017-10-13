Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46041 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753320AbdJMMJx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 13 Oct 2017 08:09:53 -0400
Date: Fri, 13 Oct 2017 14:08:07 +0200
From: David Sterba <dsterba@suse.cz>
To: Omar Sandoval <osandov@osandov.com>
Cc: Christos Gkekas <chris.gekas@gmail.com>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs: Clean up unused variables in free-space-tree.c
Message-ID: <20171013120806.GI3521@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1507844442-26013-1-git-send-email-chris.gekas@gmail.com>
 <20171012214327.GA16154@vader.DHCP.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171012214327.GA16154@vader.DHCP.thefacebook.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 12, 2017 at 02:43:27PM -0700, Omar Sandoval wrote:
> On Thu, Oct 12, 2017 at 10:40:42PM +0100, Christos Gkekas wrote:
> > Remove variables 'start' and 'end', which are set but never used.
> 
> Oops.
> 
> Reviewed-by: Omar Sandoval <osandov@fb.com>

Thanks, added to the queue.
