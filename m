From: Christian Hesse <mail@earthworm.de>
Subject: Re: [PATCH] compile when posix acl's are disabled
Date: Tue, 12 Aug 2008 18:12:07 +0200
Message-ID: <200808121812.10945.mail__3142.5413130366$1218558873$gmane$org@earthworm.de>
References: <20080812143549.GG29623@unused.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Cc: Josef Bacik <jbacik@redhat.com>, linux-btrfs@vger.kernel.org
To: btrfs-devel@oss.oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20080812143549.GG29623@unused.rdu.redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tuesday 12 August 2008, Josef Bacik wrote:
> Hello,
>
> This patch makes btrfs so it will compile properly when acls are disabled. 
> I tested this and it worked with CONFIG_FS_POSIX_ACL off and on.  Thanks
> much,

Works perfectly. Thanks a lot!
-- 
Regards,
Chris
