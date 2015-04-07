Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49328 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753299AbbDGOU2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 7 Apr 2015 10:20:28 -0400
Date: Tue, 7 Apr 2015 16:20:26 +0200
From: David Sterba <dsterba@suse.cz>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel@vger.kernel.org, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH V2 linux-next] Btrfs: use BTRFS_COMPRESS_NONE instead of 0
Message-ID: <20150407142026.GA25622@suse.cz>
Reply-To: dsterba@suse.cz
References: <1428090634-21126-1-git-send-email-fabf@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1428090634-21126-1-git-send-email-fabf@skynet.be>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 03, 2015 at 09:50:34PM +0200, Fabian Frederick wrote:
> cow_file_range_inline() was called with 0 instead of actual definition.
> 
> btrfs_finish_ordered_io() initialized compress_type with 0 as well.
> (Thanks to David Sterba for suggesting this update).
> 
> Signed-off-by: Fabian Frederick <fabf@skynet.be>

Reviewed-by: David Sterba <dsterba@suse.cz>

Thanks.
