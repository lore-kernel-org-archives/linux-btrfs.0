From: David Sterba <dave@jikos.cz>
Subject: Re: [patch 1/2] Btrfs: double unlock bug in error handling
Date: Wed, 18 Apr 2012 12:14:07 +0200
Message-ID: <20120418101407.GG20982@twin.jikos.cz>
References: <20120418065903.GE12831@elgon.mountain>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Mason <chris.mason@oracle.com>,
	Jeff Mahoney <jeffm@suse.com>, linux-btrfs@vger.kernel.org,
	kernel-janitors@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120418065903.GE12831@elgon.mountain>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 18, 2012 at 09:59:03AM +0300, Dan Carpenter wrote:
> The caller expects this function to return with the lock held and
> releases it immediately on error.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: David Sterba <dsterba@suse.cz>

Good catch, thanks.
