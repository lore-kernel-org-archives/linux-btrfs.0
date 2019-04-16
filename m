Return-Path: <SRS0=AHcI=SS=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEE85C282E0
	for <linux-btrfs@archiver.kernel.org>; Tue, 16 Apr 2019 22:41:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 983C3217D4
	for <linux-btrfs@archiver.kernel.org>; Tue, 16 Apr 2019 22:41:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728404AbfDPWlC (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 16 Apr 2019 18:41:02 -0400
Received: from smtp.infotech.no ([82.134.31.41]:43553 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727136AbfDPWlC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 16 Apr 2019 18:41:02 -0400
X-Greylist: delayed 426 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Apr 2019 18:40:57 EDT
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 7AE53204198;
        Wed, 17 Apr 2019 00:33:49 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id GbqKz4pLBTus; Wed, 17 Apr 2019 00:33:42 +0200 (CEST)
Received: from [192.168.48.23] (host-45-58-224-183.dyn.295.ca [45.58.224.183])
        by smtp.infotech.no (Postfix) with ESMTPA id 07E86204195;
        Wed, 17 Apr 2019 00:33:36 +0200 (CEST)
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCH v3 00/26] compat_ioctl: cleanups
To:     Arnd Bergmann <arnd@arndb.de>,
        Alexander Viro <viro@zeniv.linux.org.uk>
Cc:     linux-fsdevel@vger.kernel.org, y2038@lists.linaro.org,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Karsten Keil <isdn@linux-pingi.de>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Marcel Holtmann <marcel@holtmann.org>, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-integrity@vger.kernel.org,
        qat-linux@intel.com, linux-crypto@vger.kernel.org,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux1394-devel@lists.sourceforge.net,
        amd-gfx@lists.freedesktop.org, linux-input@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-ide@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-rdma@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-mtd@lists.infradead.org, linux-ppp@vger.kernel.org,
        linux-nvme@lists.infradead.org,
        platform-driver-x86@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, linux-rtc@vger.kernel.org,
        linux-s390@vger.kernel.org, sparclinux@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-fbdev@vger.kernel.org,
        linux-btrfs@vger.kernel.org, ceph-devel@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, linux-wireless@vger.kernel.org,
        alsa-devel@alsa-project.org
References: <20190416202013.4034148-1-arnd@arndb.de>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <c379ed8d-1f33-e391-a1b5-810da77605f2@interlog.com>
Date:   Tue, 16 Apr 2019 18:33:35 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190416202013.4034148-1-arnd@arndb.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 2019-04-16 4:19 p.m., Arnd Bergmann wrote:
> Hi Al,
> 
> It took me way longer than I had hoped to revisit this series, see
> https://lore.kernel.org/lkml/20180912150142.157913-1-arnd@arndb.de/
> for the previously posted version.
> 
> I've come to the point where all conversion handlers and most
> COMPATIBLE_IOCTL() entries are gone from this file, but for
> now, this series only has the parts that have either been reviewed
> previously, or that are simple enough to include.
> 
> The main missing piece is the SG_IO/SG_GET_REQUEST_TABLE conversion.
> I'll post the patches I made for that later, as they need more
> testing and review from the scsi maintainers.

Perhaps you could look at the document in this url:
     http://sg.danny.cz/sg/sg_v40.html

It is work-in-progress to modernize the SCSI generic driver. It
extends ioctl(sg_fd, SG_IO, &pt_obj) to additionally accept the sg v4
interface as defined in include/uapi/linux/bsg.h . Currently only the
bsg driver uses the sg v4 interface. Since struct sg_io_v4 is all
explicitly sized integers, I'm guessing it is immune "compat" problems.
[I can see no reference to bsg nor struct sg_io_v4 in the current
fs/compat_ioctl.c file.]

Other additions described in the that document are these new ioctls:
   - SG_IOSUBMIT    ultimately to replace write(sg_fd, ...)
   - SG_IORECEIVE              to replace read(sg_fd, ...)
   - SG_IOABORT     abort SCSI cmd in progress; new functionality
   - SG_SET_GET_EXTENDED   has associated struct sg_extended_info

The first three take a pointer to a struct sg_io_hdr (v3 interface) or
a struct sg_io_v4 object. Both objects start with a 32 bit integer:
'S' identifies the v3 interface while 'Q' identifies the v4 interface.

The SG_SET_GET_EXTENDED ioctl takes a pointer to a struct
sg_extended_info object which contains explicitly sized integers so it
may also be immune from "compat" problems. The ioctls section (13) of
that document referenced above has a table showing how many "sets and
gets" are hiding in the SG_SET_GET_EXTENDED ioctl.

BTW No change is proposed for this case:
     ioctl(normal_block_device, SG_IO, &sg_v3_obj)
which is handled by block/scsi_ioctl.c


This would be a good time for me to address any "compat" concerns in the
proposed sg driver update.

Doug Gilbert


> I hope you can still take these for the coming merge window, unless
> new problems come up.
> 
>        Arnd
> 
> Arnd Bergmann (26):
>    compat_ioctl: pppoe: fix PPPOEIOCSFWD handling
>    compat_ioctl: move simple ppp command handling into driver
>    compat_ioctl: avoid unused function warning for do_ioctl
>    compat_ioctl: move PPPIOCSCOMPRESS32 to ppp-generic.c
>    compat_ioctl: move PPPIOCSPASS32/PPPIOCSACTIVE32 to ppp_generic.c
>    compat_ioctl: handle PPPIOCGIDLE for 64-bit time_t
>    compat_ioctl: move rtc handling into rtc-dev.c
>    compat_ioctl: add compat_ptr_ioctl()
>    compat_ioctl: move drivers to compat_ptr_ioctl
>    compat_ioctl: use correct compat_ptr() translation in drivers
>    ceph: fix compat_ioctl for ceph_dir_operations
>    compat_ioctl: move more drivers to compat_ptr_ioctl
>    compat_ioctl: move tape handling into drivers
>    compat_ioctl: move ATYFB_CLK handling to atyfb driver
>    compat_ioctl: move isdn/capi ioctl translation into driver
>    compat_ioctl: move rfcomm handlers into driver
>    compat_ioctl: move hci_sock handlers into driver
>    compat_ioctl: remove HCIUART handling
>    compat_ioctl: remove HIDIO translation
>    compat_ioctl: remove translation for sound ioctls
>    compat_ioctl: remove IGNORE_IOCTL()
>    compat_ioctl: remove /dev/random commands
>    compat_ioctl: remove joystick ioctl translation
>    compat_ioctl: remove PCI ioctl translation
>    compat_ioctl: remove /dev/raw ioctl translation
>    compat_ioctl: remove last RAID handling code
> 
>   Documentation/networking/ppp_generic.txt    |   2 +
>   arch/um/drivers/hostaudio_kern.c            |   1 +
>   drivers/android/binder.c                    |   2 +-
>   drivers/char/ppdev.c                        |  12 +-
>   drivers/char/random.c                       |   1 +
>   drivers/char/tpm/tpm_vtpm_proxy.c           |  12 +-
>   drivers/crypto/qat/qat_common/adf_ctl_drv.c |   2 +-
>   drivers/dma-buf/dma-buf.c                   |   4 +-
>   drivers/dma-buf/sw_sync.c                   |   2 +-
>   drivers/dma-buf/sync_file.c                 |   2 +-
>   drivers/firewire/core-cdev.c                |  12 +-
>   drivers/gpu/drm/amd/amdkfd/kfd_chardev.c    |   2 +-
>   drivers/hid/hidraw.c                        |   4 +-
>   drivers/hid/usbhid/hiddev.c                 |  11 +-
>   drivers/hwtracing/stm/core.c                |  12 +-
>   drivers/ide/ide-tape.c                      |  31 +-
>   drivers/iio/industrialio-core.c             |   2 +-
>   drivers/infiniband/core/uverbs_main.c       |   4 +-
>   drivers/isdn/capi/capi.c                    |  31 +
>   drivers/isdn/i4l/isdn_ppp.c                 |  14 +-
>   drivers/media/rc/lirc_dev.c                 |   4 +-
>   drivers/mfd/cros_ec_dev.c                   |   4 +-
>   drivers/misc/cxl/flash.c                    |   8 +-
>   drivers/misc/genwqe/card_dev.c              |  23 +-
>   drivers/misc/mei/main.c                     |  22 +-
>   drivers/misc/vmw_vmci/vmci_host.c           |   2 +-
>   drivers/mtd/ubi/cdev.c                      |  36 +-
>   drivers/net/ppp/ppp_generic.c               |  99 +++-
>   drivers/net/ppp/pppoe.c                     |   7 +
>   drivers/net/ppp/pptp.c                      |   3 +
>   drivers/net/tap.c                           |  12 +-
>   drivers/nvdimm/bus.c                        |   4 +-
>   drivers/nvme/host/core.c                    |   2 +-
>   drivers/pci/switch/switchtec.c              |   2 +-
>   drivers/platform/x86/wmi.c                  |   2 +-
>   drivers/rpmsg/rpmsg_char.c                  |   4 +-
>   drivers/rtc/dev.c                           |  13 +-
>   drivers/rtc/rtc-vr41xx.c                    |  10 +
>   drivers/s390/char/tape_char.c               |  41 +-
>   drivers/sbus/char/display7seg.c             |   2 +-
>   drivers/sbus/char/envctrl.c                 |   4 +-
>   drivers/scsi/3w-xxxx.c                      |   4 +-
>   drivers/scsi/cxlflash/main.c                |   2 +-
>   drivers/scsi/esas2r/esas2r_main.c           |   2 +-
>   drivers/scsi/megaraid/megaraid_mm.c         |  28 +-
>   drivers/scsi/osst.c                         |  34 +-
>   drivers/scsi/pmcraid.c                      |   4 +-
>   drivers/scsi/st.c                           |  35 +-
>   drivers/staging/android/ion/ion.c           |   4 +-
>   drivers/staging/pi433/pi433_if.c            |  12 +-
>   drivers/staging/vme/devices/vme_user.c      |   2 +-
>   drivers/tee/tee_core.c                      |   2 +-
>   drivers/usb/class/cdc-wdm.c                 |   2 +-
>   drivers/usb/class/usbtmc.c                  |   4 +-
>   drivers/usb/core/devio.c                    |  16 +-
>   drivers/usb/gadget/function/f_fs.c          |  12 +-
>   drivers/vfio/vfio.c                         |  39 +-
>   drivers/vhost/net.c                         |  12 +-
>   drivers/vhost/scsi.c                        |  12 +-
>   drivers/vhost/test.c                        |  12 +-
>   drivers/vhost/vsock.c                       |  12 +-
>   drivers/video/fbdev/aty/atyfb_base.c        |  12 +-
>   drivers/virt/fsl_hypervisor.c               |   2 +-
>   fs/btrfs/super.c                            |   2 +-
>   fs/ceph/dir.c                               |   1 +
>   fs/ceph/file.c                              |   2 +-
>   fs/compat_ioctl.c                           | 602 +-------------------
>   fs/fat/file.c                               |  13 +-
>   fs/fuse/dev.c                               |   2 +-
>   fs/notify/fanotify/fanotify_user.c          |   2 +-
>   fs/userfaultfd.c                            |   2 +-
>   include/linux/fs.h                          |   7 +
>   include/linux/if_pppox.h                    |   2 +
>   include/linux/mtio.h                        |  58 ++
>   include/uapi/linux/ppp-ioctl.h              |   2 +
>   include/uapi/linux/ppp_defs.h               |  14 +
>   net/bluetooth/hci_sock.c                    |  21 +-
>   net/bluetooth/rfcomm/sock.c                 |  14 +-
>   net/l2tp/l2tp_ppp.c                         |   3 +
>   net/rfkill/core.c                           |   2 +-
>   sound/core/oss/pcm_oss.c                    |   4 +
>   sound/oss/dmasound/dmasound_core.c          |   2 +
>   82 files changed, 452 insertions(+), 1034 deletions(-)
>   create mode 100644 include/linux/mtio.h
> 

