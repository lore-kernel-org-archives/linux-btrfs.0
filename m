From: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: [PATCH V2 1/3] lib: introduce some memory copy macros and
     functions
Date: Wed, 8 Sep 2010 14:19:25 +0200 (CEST)
Message-ID: <46238.91.60.152.217.1283948365.squirrel@www.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: "Andi Kleen" <andi@firstfloor.org>,
	"Peter Zijlstra" <peterz@infradead.org>,
	"Ingo Molnar" <mingo@redhat.com>,
	"Andrew Morton" <akpm@linux-foundation.org>,
	"Theodore Ts'o" <tytso@mit.edu>,
	"Linux Kernel" <linux-kernel@vger.kernel.org>,
	"Linux Ext4" <linux-ext4@vger.kernel.org>,
	"Linux Btrfs" <linux-btrfs@vger.kernel.org>
To: miaox@cn.fujitsu.com
Return-path: <linux-ext4-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


> According to the data, the length of the most copies is >=128.

Thanks for the data. Large is easier to optimize than small, that's good.

Could you also measure how many memsets need the backwards copy?
(should be easy to add)

If the number is small that needs backwards then the easiest fix
would be to simply call the normal memcpy in the forward case.

That is for backward could also use a string instruction copy
of course, just have to set the direction flag.

That would be a very small code change.

-Andi


