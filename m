From: Yan Zheng <yanzheng@21cn.com>
Subject: Re: New experimental btrfs branch ready for testing
Date: Mon, 8 Jun 2009 20:33:28 +0800
Message-ID: <3d0408630906080533n3c9c6f75sd80f47b568b99e2c@mail.gmail.com>
References: <20090601210447.GC3890@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090601210447.GC3890@think>
List-ID: <linux-btrfs.vger.kernel.org>

2009/6/2 Chris Mason <chris.mason@oracle.com>
>
> Hello everyone,
>
> Yan Zheng has been doing some major surgery to the back references an=
d
> extent allocation code, tackling bottlenecks in the code that tracks
> extents. =A0It scales better with many snapshots and performs better =
in
> the common case of no snapshots at all.
>
> THE NEW CODE IS A FORWARD ROLLING DISK FORMAT CHANGE. =A0This means i=
t is
> compatible with the current btrfs disk format, but once you mount a
> filesystem with the new code, it WILL NO LONGER BE MOUNTABLE FROM OLD
> KERNELS. =A0Old kernels spit out an error message when you try them o=
n new
> format filesystems.
>

Hello, everyone

I have a minor disk format change for the new format. The disk format c=
hange
makes snapshot dropping more efficient. The format change only affects =
=46S
has been balanced. If you are testing the new format, please don't use
btrfs-vol -b or btrfs-vol -r. If you have already used btrfs-vol -b or
btrfs-vol -r,
please backup your data.

Regards
Yan Zheng
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
