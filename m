Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39193 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753843AbeAKLXo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Jan 2018 06:23:44 -0500
Subject: Re: recommendations and contraindications of using btrfs for Oracle
 Database Server
To: Ext-Strii-Houttemane Philippe <Philippe.Houttemane@cetim.fr>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <8444d2a08c8f4e8dab2ee48139ce5bb9@AQUILON.cetim.priv>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <3b9c23e7-ce32-44a3-f3d2-9da8287116ed@suse.com>
Date: Thu, 11 Jan 2018 13:23:42 +0200
MIME-Version: 1.0
In-Reply-To: <8444d2a08c8f4e8dab2ee48139ce5bb9@AQUILON.cetim.priv>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 11.01.2018 12:51, Ext-Strii-Houttemane Philippe wrote:
> Hello,
> 
>    We are using btrfs filesystem on local disks (RAID 1) as underlying filesystem to host our Oracle 12c datafiles.
> This allow us to cold backup databases via snapshot in a few seconds and benefit from higher performance than over Linux filesystem formats.
> This is the problem we meet: Oracle regularly crashes with error of this 2 types, the errors occur on different physical machines with same softwares:
> 
> ORA-63999: data file suffered media failure
> ORA-01114: IO error writing block to file 99 (block # 99968)
> ORA-01110: data file 99: '/oradata/PS92PRD/data/pcapp.dbf'
> ORA-27072: File I/O error
> Linux-x86_64 Error: 17: File exists
> Additional information: 4
> Additional information: 99968
> 
> And 
> 
> ORA-63999: data file suffered media failure
> ORA-01114: IO error writing block to file 99 (block # 99994)
> ORA-01110: data file 99: '/oradata/PS92PRD/data/pcapp.dbf'
> ORA-27072: File I/O error
> Linux-x86_64 Error: 5: Input/output error
> Additional information: 4
> Additional information: 99994
> 
> It nevers append with over filesystem types, all the hardware has been checked.
> I suspect a Btrfs activated feature via our mount options instead of a bug: Oracle see a ghost or a duplicated bloc even if copy on cow feature is disabled.
> 
> Here are few details of the system:
> 
> Mount options: defaults,nofail,nodatacow,nobarrier,noatime
> 
> uname -a:
> Linux 3.10.0-514.10.2.el7.x86_64 #1 SMP Fri Mar 3 00:04:05 UTC 2017 x86_64 x86_64 x86_64 GNU/Linux

You are using a vendor-specific kernel. It's best if you turn to them
for support since it's very likely their code doesn't match what is in
upstream, let alone the fact you are using an ancient kernel.

> btrfs -version: btrfs-progs v4.9.1
> 
> btrfs fi show:
> Label: 'oradataBtrfs'  
>         Total devices 1 FS bytes used 1.98TiB
>         devid    1 size 3.18TiB used 2.02TiB path /dev/sdb1
> 
> Thank you very much for your advice.
> 
> Philippe Houttemane
> System, network and DBA engineer.
> 
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
