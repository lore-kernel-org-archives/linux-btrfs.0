From: jim owens <jowens@hp.com>
Subject: Re: [RFC 11/12 PATCH] Btrfs: add direct I/O helper btrfs_lookup_one_csum().
Date: Tue, 19 Jan 2010 15:01:12 -0500
Message-ID: <4B560F88.7000207@hp.com>
References: <4B425A2D.5030207@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs <linux-btrfs@vger.kernel.org>, owens@ldl.fc.hp.com,
	Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4B425A2D.5030207@hp.com>
List-ID: <linux-btrfs.vger.kernel.org>

I am retracting this patch:

jim owens wrote:
> Direct I/O needs to fetch a single checksum based on the
> extent information instead of page struct content.
> 
> Signed-off-by: jim owens <jowens@hp.com>
> ---
>  fs/btrfs/ctree.h     |    2 ++
>  fs/btrfs/file-item.c |   45 +++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 47 insertions(+), 0 deletions(-)

This code will not be used now in directIO read.

jim
