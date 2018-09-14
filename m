Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:42968 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727416AbeIOCOJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Sep 2018 22:14:09 -0400
Date: Fri, 14 Sep 2018 21:57:48 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Darren Hart <dvhart@infradead.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-fsdevel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, qat-linux@intel.com,
        linux-crypto@vger.kernel.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        amd-gfx@lists.freedesktop.org, linux-input@vger.kernel.org,
        linux-iio@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-nvdimm@lists.01.org, linux-nvme@lists.infradead.org,
        linux-pci@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, sparclinux@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-fbdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-btrfs@vger.kernel.org, ceph-devel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2 05/17] compat_ioctl: move more drivers to
 generic_compat_ioctl_ptrarg
Message-ID: <20180914205748.GC19965@ZenIV.linux.org.uk>
References: <20180912150142.157913-1-arnd@arndb.de>
 <20180912151134.436719-1-arnd@arndb.de>
 <20180914203506.GE35251@wrath>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180914203506.GE35251@wrath>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 14, 2018 at 01:35:06PM -0700, Darren Hart wrote:
 
> Acked-by: Darren Hart (VMware) <dvhart@infradead.org>
> 
> As for a longer term solution, would it be possible to init fops in such
> a way that the compat_ioctl call defaults to generic_compat_ioctl_ptrarg
> so we don't have to duplicate this boilerplate for every ioctl fops
> structure?

	Bad idea, that...  Because several years down the road somebody will add
an ioctl that takes an unsigned int for argument.  Without so much as looking
at your magical mystery macro being used to initialize file_operations.

	FWIW, I would name that helper in more blunt way - something like
compat_ioctl_only_compat_pointer_ioctls_here()...
