From: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH V2 0/3] improve the performance of some memory copy
 functions
Date: Thu, 2 Sep 2010 08:53:47 +0200
Message-ID: <20100902065347.GA29972@elte.hu>
References: <4C7F3A26.6020607@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Chris Mason <chris.mason@oracle.com>,
	Yan Zheng <zheng.yan@oracle.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>,
	Linux Ext4 <linux-ext4@vger.kernel.org>
To: Miao Xie <miaox@cn.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
In-Reply-To: <4C7F3A26.6020607@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>


* Miao Xie <miaox@cn.fujitsu.com> wrote:

> - change the version of GPL from version 2.1 to version 2

How were you able to do this? If the code derives from glibc (as your 
comments in the patches suggest), and if glibc is under the GPL v2.1, 
then you probably cannot simply change the license to v2.

	Ingo
