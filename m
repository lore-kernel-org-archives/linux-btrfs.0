Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from szxga06-in.huawei.com ([45.249.212.32]:51774 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726826AbeIQPAz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 17 Sep 2018 11:00:55 -0400
Date: Mon, 17 Sep 2018 10:33:48 +0100
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: <viro@zeniv.linux.org.uk>, <linux-fsdevel@vger.kernel.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>, <devel@driverdev.osuosl.org>,
        <linux-kernel@vger.kernel.org>, <qat-linux@intel.com>,
        <linux-crypto@vger.kernel.org>, <linux-media@vger.kernel.org>,
        <dri-devel@lists.freedesktop.org>, <linaro-mm-sig@lists.linaro.org>,
        <amd-gfx@lists.freedesktop.org>, <linux-input@vger.kernel.org>,
        <linux-iio@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <linux-nvdimm@lists.01.org>, <linux-nvme@lists.infradead.org>,
        <linux-pci@vger.kernel.org>, <platform-driver-x86@vger.kernel.org>,
        <linux-remoteproc@vger.kernel.org>, <sparclinux@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-fbdev@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-btrfs@vger.kernel.org>, <ceph-devel@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 05/17] compat_ioctl: move more drivers to
 generic_compat_ioctl_ptrarg
Message-ID: <20180917103348.00003f31@huawei.com>
In-Reply-To: <20180912151134.436719-1-arnd@arndb.de>
References: <20180912150142.157913-1-arnd@arndb.de>
        <20180912151134.436719-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 12 Sep 2018 17:08:52 +0200
Arnd Bergmann <arnd@arndb.de> wrote:

> The .ioctl and .compat_ioctl file operations have the same prototype so
> they can both point to the same function, which works great almost all
> the time when all the commands are compatible.
> 
> One exception is the s390 architecture, where a compat pointer is only
> 31 bit wide, and converting it into a 64-bit pointer requires calling
> compat_ptr(). Most drivers here will ever run in s390, but since we now
> have a generic helper for it, it's easy enough to use it consistently.
> 
> I double-checked all these drivers to ensure that all ioctl arguments
> are used as pointers or are ignored, but are not interpreted as integer
> values.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---

For IIO part.

Acked-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

Thanks,
> diff --git a/drivers/iio/industrialio-core.c b/drivers/iio/industrialio-core.c
> index a062cfddc5af..22844b94b0e9 100644
> --- a/drivers/iio/industrialio-core.c
> +++ b/drivers/iio/industrialio-core.c
> @@ -1630,7 +1630,7 @@ static const struct file_operations iio_buffer_fileops = {
>  	.owner = THIS_MODULE,
>  	.llseek = noop_llseek,
>  	.unlocked_ioctl = iio_ioctl,
> -	.compat_ioctl = iio_ioctl,
> +	.compat_ioctl = generic_compat_ioctl_ptrarg,
>  };
>  
