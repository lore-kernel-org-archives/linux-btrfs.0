From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] new dir format take 3
Date: Tue, 22 Jul 2008 15:54:47 -0400
Message-ID: <1216756487.6932.133.camel@think.oraclecorp.com>
References: <20080722184404.GB8960@unused.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: Josef Bacik <jbacik@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20080722184404.GB8960@unused.rdu.redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 2008-07-22 at 14:44 -0400, Josef Bacik wrote:
> +
> +       if (BTRFS_I(dir)->index_cnt == (u64)-1)
> +               btrfs_get_index_count(dir);
> +       BTRFS_I(inode)->index = BTRFS_I(dir)->index_cnt;
> +       BTRFS_I(dir)->index_cnt++;

I'll test this one in a little bit, but could you please factor this out
into a small function?

-chris


