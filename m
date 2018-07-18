Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43876 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729333AbeGROo5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 18 Jul 2018 10:44:57 -0400
Date: Wed, 18 Jul 2018 16:06:44 +0200
From: David Sterba <dsterba@suse.cz>
To: james harvey <jamespharvey20@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs-progs: btrfs_close_devices(): only fsync() if
 device->writeable
Message-ID: <20180718140644.GC26141@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CA+X5Wn6h8sot6Z7OQVvehD_T4XxHOiss=gT18s_d6EJPZrUhQA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CA+X5Wn6h8sot6Z7OQVvehD_T4XxHOiss=gT18s_d6EJPZrUhQA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 06, 2018 at 02:30:41AM -0400, james harvey wrote:
> Prevent unnecessary error from failing fsync(), if opened read only.
> 
> Performed 'grep "writeable = " *.h *.c' to make sure there were no odd
> situations where fsync() might still be desired here.  They're all straight-
> forward.  The only situation where writeable will be 0 is if btrfs_open_devices
> is given flags without O_RDWR.  There is no situation where a writeable volume
> temporarily becomes unwriteable, or anything like that.  Given that it's being
> opened O_RDWR, there's no reason to attempt fsync().
> 
> utils.c
> 
>    int btrfs_add_to_fsid() {
>       ...
>       device->writeable = 1;
> 
> volumes.c
> 
>    int btrfs_close_devices() {
>       ...
>       while (!list_empty(&fs_devices->devices)) {
>          ...
>          // just after the fsync() being patched
> 267:     device->writeable = 0;
>    ...
>    int btrfs_open_devices() {
>       ...
>       list_for_each_entry(device, &fs_devices->devices, dev_list) {
>          ...
>          if (flags & O_RDWR)
> 332:        device->writeable = 1
> 
> kernel btrfs_close_devices() does not have a corresponding fsync() that I see.
> 
> Signed-off-by: James Harvey <jamespharvey20@gmail.com>

Applied, thanks.
