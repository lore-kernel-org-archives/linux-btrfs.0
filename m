From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 1/3] lib: introduce some memory copy macros and
 functions
Date: Wed, 01 Sep 2010 17:25:36 +0200
Message-ID: <1283354736.2059.1206.camel@laptop>
References: <4C7E2CA9.9060702@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Ingo Molnar <mingo@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Mason <chris.mason@oracle.com>,
	Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>,
	Linux Ext4 <linux-ext4@vger.kernel.org>
To: miaox@cn.fujitsu.com
Return-path: <linux-ext4-owner@vger.kernel.org>
In-Reply-To: <4C7E2CA9.9060702@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 2010-09-01 at 18:36 +0800, Miao Xie wrote:
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License as published by the Free
> + * Software Foundation; either version 2.1 of the License, or (at your option)
> + * any later version. 

The kernel is GPL v2, see COPYING. GPL v2.1 is not a suitable license.
