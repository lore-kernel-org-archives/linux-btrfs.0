Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:45124 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965742AbcKLCSa (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 11 Nov 2016 21:18:30 -0500
Date: Fri, 11 Nov 2016 18:18:22 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: spinning kworker with space_cache=v2 searching for free space
Message-ID: <20161112021821.GC30930@dhcp-whq-twvpn-1-vpnpool-10-159-131-21.vpn.oracle.com>
Reply-To: bo.li.liu@oracle.com
References: <c9bf6cbb-ea68-a517-3c6e-7ff4ec1a788e@profihost.ag>
 <c01a47a5-ff65-1a6e-861f-ab7782bee0ed@profihost.ag>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <c01a47a5-ff65-1a6e-861f-ab7782bee0ed@profihost.ag>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 09, 2016 at 09:19:21PM +0100, Stefan Priebe - Profihost AG wrote:
> Hello,
> 
> found this one from 2014:
> https://patchwork.kernel.org/patch/5551651/
> 
> it this still valid?

The space cache code doesn't change a lot, so I think the patch is still
valid to apply(there might be some conflicts though), but I'm not sure
if it could help the spinning case.

Thanks,

-liubo
> 
> Am 09.11.2016 um 09:09 schrieb Stefan Priebe - Profihost AG:
> > Dear list,
> > 
> > even there's a lot of free space on my disk:
> > 
> > # df -h /vmbackup/
> > Filesystem                    Size  Used Avail Use% Mounted on
> > /dev/mapper/stripe0-backup   37T   24T   13T  64% /backup
> > 
> > # btrfs filesystem df /backup/
> > Data, single: total=23.75TiB, used=22.83TiB
> > System, DUP: total=8.00MiB, used=3.94MiB
> > Metadata, DUP: total=283.50GiB, used=105.82GiB
> > GlobalReserve, single: total=512.00MiB, used=0.00B
> > 
> > I always have a kworker process endless spinning.
> > 
> > # perf top shows:
> >   47,56%  [kernel]               [k] rb_next
> >    7,71%  [kernel]               [k] tree_search_offset.isra.25
> >    6,44%  [kernel]               [k] btrfs_find_space_for_alloc
> > 
> > Mount options:
> > rw,noatime,compress-force=zlib,nossd,noacl,space_cache=v2,skip_balance
> > 
> > What's wrong here?
> > 
> > Greets,
> > Stefan
> > 
