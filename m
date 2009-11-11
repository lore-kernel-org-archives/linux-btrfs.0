From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [patch] avoid null deref in unpin_extent_cache()
Date: Wed, 11 Nov 2009 16:26:32 -0500
Message-ID: <20091111212632.GB2898@think>
References: <alpine.DEB.2.00.0911072313580.30287@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Dan Carpenter <error27@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.0911072313580.30287@bicker>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 10, 2009 at 11:01:43AM +0200, Dan Carpenter wrote:
> I re-orderred the checks to avoid dereferencing "em" if it was null.

Thanks, I've put this into the master branch of the btrfs unstable tree.

-chris
