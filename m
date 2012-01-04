From: Christoph Hellwig <hch@infradead.org>
Subject: Re: 276: fix up various issues
Date: Wed, 4 Jan 2012 13:42:42 -0500
Message-ID: <20120104184242.GD8131@infradead.org>
References: <1325699686-21851-1-git-send-email-list.btrfs@jan-o-sch.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: xfs@oss.sgi.com, hch@infradead.org, sandeen@sandeen.net,
	linux-btrfs@vger.kernel.org
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1325699686-21851-1-git-send-email-list.btrfs@jan-o-sch.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 04, 2012 at 06:54:46PM +0100, Jan Schmidt wrote:
> This commit fixes bd8ee45c. Changes:
> - added a _require_btrfs helper function
> - check for filefrag with _require_command
> - always use _fail in case of errors
> - added some comments
> - removed $fresh code
> - don't set FSTYP
> 
> Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>

Thanks, applied.
