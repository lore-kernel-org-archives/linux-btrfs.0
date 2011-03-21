From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH RFC] btrfs: Simplify locking
Date: Mon, 21 Mar 2011 18:11:33 +0100
Message-ID: <20110321171133.GH12003@htj.dyndns.org>
References: <20110320174433.GA12003@htj.dyndns.org>
 <1300665355-sup-1698@think>
 <20110321082942.GD12003@htj.dyndns.org>
 <20110321165955.GG12003@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110321165955.GG12003@htj.dyndns.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 21, 2011 at 05:59:55PM +0100, Tejun Heo wrote:
> I'm running DFL again just in case but SIMPLE or SPIN seems to be a
> much better choice.

Got 644.176 MB/sec, so yeah the custom locking is definitely worse
than just using mutex.

Thanks.

-- 
tejun
