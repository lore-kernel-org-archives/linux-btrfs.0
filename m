From: Ulrich Hecht <uli@suse.de>
Subject: Re: [PATCH] Btrfs: compressed file size ioctl
Date: Fri, 6 Aug 2010 14:22:13 +0200
Message-ID: <201008061422.13800.uli@suse.de>
References: <1280402829-28109-1-git-send-email-uli@suse.de> <4C561C3E.8030609@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=gb2312
Cc: linux-btrfs@vger.kernel.org
To: miaox@cn.fujitsu.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4C561C3E.8030609@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Monday 02 August 2010, Miao Xie wrote:
> I think you need use lock_extent()/unlock_extent() to enclose
> btrfs_get_extent(), but I didn't find lock_extent().

Yeah, I think that was missing in the original patch as well. Hope the=20
latest iteration is OK.

CU
Uli

--=20
SUSE LINUX Products GmbH, GF: Markus Rex, HRB 16746 (AG N=A8=B9rnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
