From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH v6 2/8] btrfs scrub: added unverified_errors
Date: Mon, 25 Jul 2011 15:11:55 +0800
Message-ID: <4E2D173B.4040302@cn.fujitsu.com>
References: <cover.1311332399.git.list.btrfs@jan-o-sch.net> <a0d21041d2cdeb4960e800fa015c616cd9853790.1311332399.git.list.btrfs@jan-o-sch.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <a0d21041d2cdeb4960e800fa015c616cd9853790.1311332399.git.list.btrfs@jan-o-sch.net>
List-ID: <linux-btrfs.vger.kernel.org>

> +	spin_lock(&sdev->stat_lock);
> +	++sdev->stat.read_errors;
> +	spin_unlock(&sdev->stat_lock);

Normally we write "i++" instead of "++i" if the return value is
ignored.
