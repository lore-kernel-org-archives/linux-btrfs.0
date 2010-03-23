From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH] Btrfs: fix how we freeze
Date: Tue, 23 Mar 2010 11:03:57 -0400
Message-ID: <20100323150357.GE2381@localhost.localdomain>
References: <20100323142818.GB2381@localhost.localdomain> <20100323145408.GD2481@laptop.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org
To: Wengang Wang <wen.gang.wang@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100323145408.GD2481@laptop.oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 23, 2010 at 10:54:08PM +0800, Wengang Wang wrote:
> Hi,
> 
> If the only thing is returning 0 in the freeze/unfreeze member functions, why
> not just remove the two functions?
> 

Because if the fs doesn't provide a freeze/unfreeze function, trying to do a
freeze will return -EOPNOTSUPP, which is not what we want.  Thanks,

Josef
