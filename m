From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [RFC][PATCH] Fix nodatacow check
Date: Fri, 18 Jul 2008 15:15:44 -0400
Message-ID: <1216408544.6932.67.camel@think.oraclecorp.com>
References: <3d0408630807171913r29a1f24he69d80497cd374d7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: Yan Zheng <yanzheng@21cn.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <3d0408630807171913r29a1f24he69d80497cd374d7@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 2008-07-18 at 10:13 +0800, Yan Zheng wrote:
> Hello,
> 
> This patch fixes the nodatacow check. The new test function can always
> detect extents referenced by multiple snatshots. If a extent was
> allocated in recent two transactions and no snapshot happened in these
> two transactions, we can always avoid cow.

Thanks Yan, I think this should work.  Could you please update it to the
latest unstable tree and resend?

-chris


