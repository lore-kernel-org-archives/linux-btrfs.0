From: Chris Mason <chris.mason@oracle.com>
Subject: Re: btrfs: readdir problem workaround for 32-bit off_t
Date: Sat, 17 Jan 2009 16:27:21 -0500
Message-ID: <1232227641.28343.3.camel@think.oraclecorp.com>
References: <alpine.LSU.2.00.0901172026180.14987@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org, bug-glibc@gnu.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <alpine.LSU.2.00.0901172026180.14987@fbirervta.pbzchgretzou.qr>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, 2009-01-17 at 20:39 +0100, Jan Engelhardt wrote:
> Hi,
> 
> 
> 
> I am seeing abnormal kernel<->userland interaction for range-exceeding 
> offsets during readdir.
> A suggested patch for btrfs is below, but I think there could also
> be involvement of (read: a bug in) Glibc.
> Would the copied parties please have a look, as it may spans both glibc 
> and btrfs.
> 

Thanks for looking into this.

Your patch is how the code originally looked, but it can lead to loops
in buggy userland (a git bug hit this).   My plan was to mask off the
limit the same way XFS now does.

This is a btrfs bug, not glibc.

-chris


