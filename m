From: Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/3] Add the snappy-c compressor to lib v2
Date: Tue, 14 Feb 2012 11:52:06 -0800
Message-ID: <4F3ABB66.1040202@linux.intel.com>
References: <1326414530-10789-1-git-send-email-andi@firstfloor.org>	<1326414530-10789-2-git-send-email-andi@firstfloor.org> <CAKcLGm8u9oKEBjFW3VpLZDUd=56mRRrr-_zjf-M7Hf5NpTTM8Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: Andi Kleen <andi@firstfloor.org>, chris.mason@oracle.com,
	linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
To: Mitch Harder <mitch.harder@sabayonlinux.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAKcLGm8u9oKEBjFW3VpLZDUd=56mRRrr-_zjf-M7Hf5NpTTM8Q@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>


> (BTW:  If you're ever reworking this patch set, I'd like to make an ad
> hoc request for slightly different names for fs/btrfs/snappy.c and
> lib/snappy.c)

Why?

> When building a x86 kernel, I get the following errors:
>    CC [M]  lib/snappy.o
> lib/snappy.c: In function 'snappy_init_env':
> lib/snappy.c:1268:2: error: implicit declaration of function 'vmalloc'
>    CC [M]  fs/btrfs/free-space-cache.o
> lib/snappy.c:1268:18: warning: assignment makes pointer from integer
> without a cast
> lib/snappy.c: In function 'snappy_free_env':
> lib/snappy.c:1293:2: error: implicit declaration of function 'vfree'
> make[1]: *** [lib/snappy.o] Error 1
> make: *** [lib] Error 2
>
> The error clears with this patch:

Added thanks.

-Andi

