From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH] Btrfs: use checksums_len instead of first_page_offset
Date: Wed, 19 Jan 2011 15:55:38 -0500
Message-ID: <20110119205537.GC4050@localhost.localdomain>
References: <20110119191924.GC1358@kwango.lan.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org, Josef Bacik <josef@redhat.com>,
	Chris Mason <chris.mason@oracle.com>,
	linux-kernel@vger.kernel.org
To: Ilya Dryomov <idryomov@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110119191924.GC1358@kwango.lan.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 19, 2011 at 09:19:24PM +0200, Ilya Dryomov wrote:
> Minimizes the number of (sizeof(u32) * num_checksums) we have to do,
> removes now useless first_page_offset variable.
> 
> Signed-off-by: Ilya Dryomov <idryomov@gmail.com>

Reviewed-by: Josef Bacik <josef@redhat.com

Thanks,

Josef
