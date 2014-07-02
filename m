Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43970 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753141AbaGBABX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 1 Jul 2014 20:01:23 -0400
Date: Wed, 2 Jul 2014 02:01:21 +0200
From: David Sterba <dsterba@suse.cz>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel@vger.kernel.org, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/1] FS/BTRFS: replace count*size kzalloc by kcalloc
Message-ID: <20140702000121.GW1553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1403721343-19383-1-git-send-email-fabf@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1403721343-19383-1-git-send-email-fabf@skynet.be>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 25, 2014 at 08:35:43PM +0200, Fabian Frederick wrote:
> kcalloc manages count*sizeof overflow.
> 
> Cc: Chris Mason <clm@fb.com>
> Cc: Josef Bacik <jbacik@fb.com>
> Cc: linux-btrfs@vger.kernel.org
> Signed-off-by: Fabian Frederick <fabf@skynet.be>

Reviewed-by: David Sterba <dsterba@suse.cz>
