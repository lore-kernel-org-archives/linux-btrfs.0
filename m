From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATH]Some fix for batching extent insert.
Date: Tue, 18 Nov 2008 09:48:58 -0500
Message-ID: <1227019738.15917.5.camel@think.oraclecorp.com>
References: <2c3b11250811170748s508ec4ddlfce9ad80bb296d95@mail.gmail.com>
	 <1227010670.15917.2.camel@think.oraclecorp.com>
	 <1227011417.15917.3.camel@think.oraclecorp.com>
	 <977a2be20811180635u21f4dbbakd9dbc3a6665960d2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Liu Hui <onlyflyer@gmail.com>, linux-btrfs@vger.kernel.org
To: yanhai zhu <zhu.yanhai@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <977a2be20811180635u21f4dbbakd9dbc3a6665960d2@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 2008-11-18 at 22:35 +0800, yanhai zhu wrote:
> hello,
>    In fact, Before Liu's change, this function maybe don't wait and
> insert ALL extents when all=1 in some cases,
> please think about the following conditions:
> 

Ok, I see what you mean.  It turned out it was actually the other hunk
that was breaking things.  I think Liu is right about that bug as well,
but I changed it slightly to preserve the counter updating but avoid
touching the list if we're really done.

Thanks!

-chris


