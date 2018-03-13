Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from v150-95-217-78.ll6w.static.cnode.io ([150.95.217.78]:59506 "EHLO
        mail.reasonset.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750724AbeCMET3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Mar 2018 00:19:29 -0400
Date: Tue, 13 Mar 2018 13:19:28 +0900
From: MASAKI haruka <yek@reasonset.net>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Btrfs broken in massive transfar
Message-Id: <20180313131928.5f3f1d053eaf50424b6dbff8@reasonset.net>
In-Reply-To: <f4e1a551-fc29-f7e8-a738-76365af403f7@gmx.com>
References: <20180313065743.c3ec9ade3e90dc4fc4b5adc9@reasonset.net>
        <f4e1a551-fc29-f7e8-a738-76365af403f7@gmx.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

*Now* I tried with Linux 4.14 and 4.15.
I experienced same probrem and reported in 2014 with Linux 3.9 and 3.10. (Perchance, actually the kernel was newer than 3.10, anyway I experienced same probrem with old 3.x kernel.)

> 
> 
> On 2018年03月13日 05:57, MASAKI haruka wrote:
> > I'm trying to clone 18TiB data between btrfs,
> > but it will crash anyway.
> > 
> > This probrem is occured even how to clone (btrfs send/receive, rsync or cp.)
> > I experienced same probrem in Linux 3.9 and Linux 3.10.
> 
> Did you really mean *3*.9 and *3*.10?
> 
> That's too old for btrfs usage IIRC.
> 
> It would be *4*.9 or *4*.10 for a relative new kernel for btrfs.
> 
> Would you please try some latest mainline kernel again?
> 
> > 
> > What happen:
> > 
> > 1. Failed to write because I/O error (read only filesystem)
> > 2. writing to the btrfs succeeds and fails randomly.
> > 3. The btrfs unable to unmount (resource is busy.) Unable to umount even forcely, so cannot halt.
> > 
> > Example:
> > ---
> > mkfile o7784-11-0
> > rename o7784-11-0 -> .filesystem/HDD/.XFV_pp/,fQO40jotqhUZ0/5JSSubx1Ph5xYNOcXhIAoIK3/XDGOWpbx,5zYWEi0L5LHdWBo/kVxX8RdGhryQiEMOm4II2qMw
> > utimes .filesystem/HDD/.XFV_pp/,fQO40jotqhUZ0/5JSSubx1Ph5xYNOcXhIAoIK3/XDGOWpbx,5zYWEi0L5LHdWBo
> > truncate .filesystem/HDD/.XFV_pp/,fQO40jotqhUZ0/5JSSubx1Ph5xYNOcXhIAoIK3/XDGOWpbx,5zYWEi0L5LHdWBo/kVxX8RdGhryQiEMOm4II2qMw size=1073698824
> > chown .filesystem/HDD/.XFV_pp/,fQO40jotqhUZ0/5JSSubx1Ph5xYNOcXhIAoIK3/XDGOWpbx,5zYWEi0L5LHdWBo/kVxX8RdGhryQiEMOm4II2qMw - uid=1000, gid=1000
> > chmod .filesystem/HDD/.XFV_pp/,fQO40jotqhUZ0/5JSSubx1Ph5xYNOcXhIAoIK3/XDGOWpbx,5zYWEi0L5LHdWBo/kVxX8RdGhryQiEMOm4II2qMw - mode=0600
> > utimes .filesystem/HDD/.XFV_pp/,fQO40jotqhUZ0/5JSSubx1Ph5xYNOcXhIAoIK3/XDGOWpbx,5zYWEi0L5LHdWBo/kVxX8RdGhryQiEMOm4II2qMw
> > mkfile o7785-12-0
> > rename o7785-12-0 -> .filesystem/HDD/.XFV_pp/,fQO40jotqhUZ0/5JSSubx1Ph5xYNOcXhIAoIK3/XDGOWpbx,5zYWEi0L5LHdWBo/lSABmfoArm9pAtade-gHmS6X
> > utimes .filesystem/HDD/.XFV_pp/,fQO40jotqhUZ0/5JSSubx1Ph5xYNOcXhIAoIK3/XDGOWpbx,5zYWEi0L5LHdWBo
> > truncate .filesystem/HDD/.XFV_pp/,fQO40jotqhUZ0/5JSSubx1Ph5xYNOcXhIAoIK3/XDGOWpbx,5zYWEi0L5LHdWBo/lSABmfoArm9pAtade-gHmS6X size=864067592
> > ERROR: truncate .filesystem/HDD/.XFV_pp/,fQO40jotqhUZ0/5JSSubx1Ph5xYNOcXhIAoIK3/XDGOWpbx,5zYWEi0L5LHdWBo/lSABmfoArm9pAtade-gHmS6X failed: Input/output error
> > btrfs send 180310235348  0.09s user 11.98s system 16% cpu 1:14.42 total
> > ---
> 
> In that case, we need kernel message to investigate.
> (And of course, please use at least 4.x kernel)
> 
> Thanks,
> Qu
> 
> > 
> > Tries:
> > 1.
> > Connect between host A (btrfs, 4disks) and B with socat (TCP).
> > Host B write to iSCSI disk (btrfs, single).
> > clone with btrfs send/receive. Linux 4.15.
> > -> Crashed at transfarred 1.78TB
> > 
> > 2.
> > Delete snapshot and retry.
> > Connect between host A and B with SSH and socat (UNIX).
> > Host B write to iSCSI disk (btrfs, single).
> > clone with btrfs send/receive. Linux 4.15.
> > -> Crashed at transfarred 90GB
> > 
> > 3.
> > Recreate btrfs.
> > Host A write to iSCSI disk.
> > clone with btrfs send/receive. Linux 4.15.
> > -> Crashed at transfarred 260GB
> > 
> > 4.
> > Recreate btrfs.
> > Original disk attach to other computer (having more resource.)
> > clone with btrfs send/receive. Linux 4.15.
> > -> Crashed at transfarred 120GB
> > 
> > 5.
> > Recreate btrfs.
> > Clone with rsync. Linux 4.15.
> > -> Crashed at transfarred 100GB
> > 
> > 6.
> > Recreate btrfs.
> > Try with Linux 4.14, btrfs send/receive.
> > -> Crashed at transfarred 3.98TB
> > 
> > 7.
> > Recreate btrfs.
> > Connect between host and NAS (iSCSI) with GbE cable directly.
> > Mounted with options relatime, spase_cache, compress=lzo.
> > clone with btrfs send/receive. Linux 4.14.
> > -> Crashed at transfarred 2.13TB
> > 
> 


-- 
MASAKI haruka <yek@reasonset.net>
