From: Shaohua Li <shaohua.li@intel.com>
Subject: Re: [PATCH] Btrfs: kill max_extent mount option
Date: Mon, 22 Mar 2010 09:33:04 +0800
Message-ID: <20100322013304.GA30742@sli10-desk.sh.intel.com>
References: <20100319180722.GC2314@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100319180722.GC2314@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Mar 20, 2010 at 02:07:23AM +0800, Josef Bacik wrote:
> As Yan pointed out, theres not much reason for all this complicated math to
> account for file extents being split up into max_extent chunks, since they are
> likely to all end up in the same leaf anyway.  Since there isn't much reason to
> use max_extent, just remove the option altogether so we have one less thing we
> need to test.  Thanks,
Since we sometimes have very big extents like several hundered mega bytes, just
curious could removing max_extent limit cause more lock contentation for extent locks?

Thanks,
Shaohua
