From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: Why does stat() return invalid st_dev field for btrfs ??
Date: Tue, 18 Aug 2009 02:29:30 +0200
Message-ID: <ac3eb2510908171729k2e53914fu6ffe49483310aeba@mail.gmail.com>
References: <4A89C1DA.6040601@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
To: Mark Lord <lkml@rtr.ca>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4A89C1DA.6040601@rtr.ca>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 17, 2009 at 22:47, Mark Lord<lkml@rtr.ca> wrote:
> Chris / list,
>
> stat(2) seems to return invalid major/minor device info
> for btrfs filesystems.
>
> Why? =C2=A0Is this a bug?

This is not invalid and not a bug. It's a superblock without a device,
and expected behavior.

There is no one-to-one relation from a btrfs mountpoint to a device,
it's a tree, and therefore therefore there can not be a single
major/minor.

Kay
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
