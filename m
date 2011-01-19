From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH v2] Btrfs: remove unneeded allocation in
	load_free_space_cache()
Date: Wed, 19 Jan 2011 13:51:21 -0500
Message-ID: <20110119185120.GA4050@localhost.localdomain>
References: <20110119153436.GA1358@kwango.lan.net> <20110119165836.GB1358@kwango.lan.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org, Josef Bacik <josef@redhat.com>,
	Chris Mason <chris.mason@oracle.com>,
	linux-kernel@vger.kernel.org
To: Ilya Dryomov <idryomov@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110119165836.GB1358@kwango.lan.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 19, 2011 at 06:58:37PM +0200, Ilya Dryomov wrote:
> I messed up size argument of kzalloc() and consequently memcpy().  Here
> is an updated version.
> 
> 
> The checksums array is unused, remove it.  We only need disk_crcs array
> to verify checksums.
> 
> There is no need to allocate first_page_offset bytes for disk_crcs
> array.  It's enough to allocate (sizeof(u32) * num_checksums) bytes
> because disk_crcs should only hold checksums.  gen is fetched
> directly from the page.
> 
> cur_crc is initialized later in the code.  Don't initialize it in a
> declaration.
> 
> Signed-off-by: Ilya Dryomov <idryomov@gmail.com>

Reviewed-by: Josef Bacik <josef@redhat.com>

Thanks,

Josef
