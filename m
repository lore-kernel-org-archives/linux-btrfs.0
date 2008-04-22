From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [Btrfs-devel][PATCH] Updates for ext3 converter.
Date: Tue, 22 Apr 2008 14:30:16 -0400
Message-ID: <200804221430.17152.chris.mason@oracle.com>
References: <480D87EA.8080800@21cn.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Cc: linux-btrfs@vger.kernel.org, btrfs-devel@oss.oracle.com
To: Yan Zheng <yanzheng@21cn.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <480D87EA.8080800@21cn.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tuesday 22 April 2008, Yan Zheng wrote:
> Hello,
>
> This patch updates the ext3 converter. The main changes in this patch
> are adding chunk handing and data relocation ability. In the last step
> of conversion, the converter relocates data in system chunk and move
> chunk tree into system chunk. In the rollback process, the converter
> remove chunk tree from system chunk and copy data back.

Great, I've pushed this out to the unstable trees, along with a btrfs-show 
command to give a summary of all the btrfs filesystems on the box.

-chris
