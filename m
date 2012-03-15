From: Andrea Gelmini <andrea.gelmini@gmail.com>
Subject: Re: [PATCH] btrfs/ulist: replace the magic number 128 with macro
 definition ULIST_SIZE_INCREMENT
Date: Thu, 15 Mar 2012 16:01:12 +0100
Message-ID: <20120315150112.GC6474@pambianco.com>
References: <4F5837B9.6000006@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: sensille@gmx.net, Chris Mason <chris.mason@oracle.com>,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
To: Wang Sheng-Hui <shhuiw@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4F5837B9.6000006@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 08, 2012 at 12:38:17PM +0800, Wang Sheng-Hui wrote:
> Remove the magic number 128 in btrfs/ulist.c.
> Introduce the macro definition ULIST_SIZE_INCREMENT in btrfs/ulist.h.


I'm using this patch without problem since you published it (compressed
/home with hourly snapshot delete/creation).

Thanks a lot for your work,
Andrea
