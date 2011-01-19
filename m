From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH] Avoid a NULL pointer in btrfs
Date: Wed, 19 Jan 2011 09:14:02 -0500
Message-ID: <20110119141334.GA2544@localhost.localdomain>
References: <4D36F04D.70505@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: strongzgy@gmail.com, onlyflyer@gmail.com,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	ak@linux.intel.com, akpm@linux-foundation.org,
	miaox@cn.fujitsu.com, josef@redhat.com, chris.mason@oracle.com,
	Yang Ruirui <ruirui.r.yang@tieto.com>, meego-kernel@meego.com
To: Liuwenyi <qingshenlwy@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4D36F04D.70505@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 19, 2011 at 10:08:13PM +0800, Liuwenyi wrote:
> In Yang Ruirui's mail, the btrfs will create a oops. This is caused by a
> null pointer in test_range_bit() while lock the spinlock.
> 
> So, It is necessary to add a pointer check into test_range_bit()
> 


NAK, the tree shouldn't be null coming into this function, something else is
going wrong.  What oops is this?  Thanks,

Josef
