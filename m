From: Ulrich Hecht <uli@suse.de>
Subject: Re: [PATCH] Btrfs: compressed file size ioctl
Date: Thu, 29 Jul 2010 13:26:17 +0200
Message-ID: <201007291326.17966.uli@suse.de>
References: <1280158253-10515-1-git-send-email-uli@suse.de> <4C4E3A10.8050204@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=gb2312
To: miaox@cn.fujitsu.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4C4E3A10.8050204@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tuesday 27 July 2010, Miao Xie wrote:
> Why don't you use btrfs_get_extent() to implement it?

Because I didn't know about it. :) Thanks, that simplifies things a lot=
=2E

CU
Uli

--=20
SUSE LINUX Products GmbH, GF: Markus Rex, HRB 16746 (AG N=A8=B9rnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
