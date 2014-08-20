Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f171.google.com ([209.85.192.171]:37400 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751979AbaHTD5u (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Aug 2014 23:57:50 -0400
Received: by mail-pd0-f171.google.com with SMTP id z10so10928801pdj.30
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Aug 2014 20:57:49 -0700 (PDT)
Date: Wed, 20 Aug 2014 11:57:42 +0800
From: Eryu Guan <guaneryu@gmail.com>
To: Zach Brown <zab@zabbo.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [BUG] cannot mount subvolume with selinux context
Message-ID: <20140820035742.GC3013@dhcp-13-216.nay.redhat.com>
References: <20140819033216.GB3013@dhcp-13-216.nay.redhat.com>
 <20140819172854.GG429@lenny.home.zabbo.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140819172854.GG429@lenny.home.zabbo.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 19, 2014 at 10:28:54AM -0700, Zach Brown wrote:
> On Tue, Aug 19, 2014 at 11:32:16AM +0800, Eryu Guan wrote:
> > Hi,
> > 
> > Description of the problem:
> > 
> > mount btrfs with selinux context, then create a subvolume, the new
> > subvolume cannot be mounted, even with the same context.
> > 
> > mkfs -t btrfs /dev/sda5
> > mount -o context=system_u:object_r:nfs_t:s0 /dev/sda5 /mnt/btrfs
> > btrfs subvolume create /mnt/btrfs/subvol
> > mount -o subvol=subvol,context=system_u:object_r:nfs_t:s0 /dev/sda5 /mnt/test
> 
> Submit a xfstest?

Sure, will do.

Thanks,
Eryu
> 
> > The security_sb_copy_data() takes out selinux context data to
> > "secdata", then mount_subvol() calls mount_fs() (via vfs_kern_mount())
> > again without selinux context, so mount_subvol() fails, which fails
> > the whole mount.
> > 
> > Not sure what's the proper fix. Zach suggestted that the fix will
> > probably be to rework the vfs functions a bit as he said in rh
> > bugzilla[1].
> 
> Yeah, I have no idea what'd be preferred here:
> 
>  - rework the vfs _kern_ mount api to offer one that doesn't mess with
>    selinux mount options
>  - add a flag to have the second _kern_ mount ignore selinux (but not
>    MS_KERNMOUNT?)
>  - binary data and fs selinux handling?  (like nfs)
> 
> - z
