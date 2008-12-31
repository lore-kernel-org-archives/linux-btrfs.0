From: Zach Brown <zach.brown@oracle.com>
Subject: Re: [PATCH] Btrfs-progs: btrfs file system size should be bigger
 then 256m
Date: Wed, 31 Dec 2008 09:49:32 -0800
Message-ID: <495BB0AC.5070607@oracle.com>
References: <495B0D54.7060806@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Shen Feng <shen@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <495B0D54.7060806@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>


> +				if (block_count < 256*1024*1024) {
> +					fprintf(stderr, "File system size is too small\n");
> +					exit(1);
> +				}

And please, if you could, include both the size that is too small and
the size that is required in the message.

- z
