From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [Btrfs-devel] [PATCH] Speed improvement and bug fixes for ext3 converter.
Date: Wed, 23 Apr 2008 10:21:18 -0400
Message-ID: <200804231021.20330.chris.mason__32435.4989374571$1208960679$gmane$org@oracle.com>
References: <480F4339.6050305@21cn.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Cc: Yan Zheng <yanzheng@21cn.com>, linux-btrfs@vger.kernel.org
To: btrfs-devel@oss.oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <480F4339.6050305@21cn.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wednesday 23 April 2008, Yan Zheng wrote:
> Hello,
>
> This patch improves converter's allocator and fixes a bug in data
> relocation function. The new allocator caches free blocks as Btrfs's
> default allocator. In testing here, the user CPU time reduced to half of
> the original when checksum and small file packing was disabled. This patch
> also enlarges the size of block groups created by the converter.

Fantastic, thanks

-chris
