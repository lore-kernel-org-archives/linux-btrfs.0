From: Christian Hesse <mail@earthworm.de>
Subject: Re: build error on 2.6.27
Date: Mon, 12 Jan 2009 11:31:28 +0100
Message-ID: <200901121131.30372.mail@earthworm.de>
References: <1231752518.6435.205.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Cc: Gabor MICSKO <gmicsko@gmail.com>, linux-btrfs@vger.kernel.org
To: btrfs-devel@oss.oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1231752518.6435.205.camel@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

On Monday 12 January 2009, Gabor MICSKO wrote:
> Hi,
>
> Since commit eecac8a148137ec5c519fc536effce8d6be89ec8
>
> ( HEAD is now at eecac8a... Btrfs: drop remaining LINUX_KERNEL_VERSION
> checks and compat code )
>
> btrfs kernel module failed to compile on 2.6.27. Older kernel versions not
> supported anymore?

No, older kernel versions are not supported at the moment. This was nessecary 
for the mainline merge. But as older kernels are planned to be supported down 
to 2.6.18 (to get btrfs support in Debian Etch and RHEL) there will be a 
solution soon I think.
-- 
Regards,
Chris
