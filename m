Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44833 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750725AbdEBPqw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 2 May 2017 11:46:52 -0400
Date: Tue, 2 May 2017 17:46:44 +0200
From: David Sterba <dsterba@suse.cz>
To: Fabian Frederick <fabf@skynet.be>
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
        Josef Bacik <jbacik@fb.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1 linux-next] btrfs: kmap() can't fail
Message-ID: <20170502154644.GO23260@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170425181102.2326-1-fabf@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170425181102.2326-1-fabf@skynet.be>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 25, 2017 at 08:11:02PM +0200, Fabian Frederick wrote:
> Remove NULL test on kmap()
> 
> Signed-off-by: Fabian Frederick <fabf@skynet.be>

Reviewed-by: David Sterba <dsterba@suse.com>
