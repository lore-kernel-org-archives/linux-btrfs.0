Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43541 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750768AbbI3PGR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Sep 2015 11:06:17 -0400
Date: Wed, 30 Sep 2015 17:05:16 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, clm@fb.com
Subject: Re: [PATCH 00/23] btrfs device related patch set
Message-ID: <20150930150516.GH11442@suse.cz>
Reply-To: dsterba@suse.cz
References: <1439548388-29686-1-git-send-email-anand.jain@oracle.com>
 <20150929143406.GD11442@twin.jikos.cz>
 <560B0C6D.4050100@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <560B0C6D.4050100@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 30, 2015 at 06:10:53AM +0800, Anand Jain wrote:
> 
> 
> On 09/29/2015 10:34 PM, David Sterba wrote:
> > On Fri, Aug 14, 2015 at 06:32:45PM +0800, Anand Jain wrote:
> >> Anand Jain (22):
> >>    Btrfs: rename btrfs_sysfs_add_one to btrfs_sysfs_add_mounted
> >>    Btrfs: rename btrfs_sysfs_remove_one to btrfs_sysfs_remove_mounted
> >>    Btrfs: rename btrfs_kobj_add_device to btrfs_sysfs_add_device_link
> >>    Btrfs: rename btrfs_kobj_rm_device to btrfs_sysfs_rm_device_link
> >>    Btrfs: rename super_kobj to fsid_kobj
> >>    Btrfs: SB read failure should return EIO for __bread failure
> >>    Btrfs: __btrfs_std_error() logic should be consistent w/out
> >>      CONFIG_PRINTK defined
> >
> > FYI, I'm picking the above for 4.4 as they're quite straightforward,
>  > the other patches touch interfaces and I have some comments.
> 
> Thanks David.
> Except for
>    [PATCH 08/23] Btrfs: device delete by devid
>    [PATCH 23/23] Btrfs: allow -o rw,degraded for single group profile

In case the two patches are independent on the rest of series, it would
be better to put them towards the end of the series. I was going down
the list and stpeed at 08/23 because it introduced something nontrivial
and then I can't be sure that skipping the single patch would not break
the whole series.

> rest are straightforward as well. If there is any comment will take it.

I'll have another look and will let you know.
