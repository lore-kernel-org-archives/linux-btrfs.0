Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:46940 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753027Ab2IRPLV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Sep 2012 11:11:21 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org, miaox@cn.fujitsu.com
Subject: Re: [PATCH V4 6/7] Btrfs-progs: enhance btrfs subvol list only to show read-only snapshots
Date: Tue, 18 Sep 2012 17:11:19 +0200
References: <50584E6D.8000602@cn.fujitsu.com> <50585674.9090501@cn.fujitsu.com> (sfid-20120918_132127_153756_1F72F0E7)
In-Reply-To: <50585674.9090501@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201209181711.19321.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Dienstag, 18. September 2012 schrieb Miao Xie:
>  static const char * const cmd_subvol_list_usage[] = {
> -       "btrfs subvolume list [-pu] [-s 0|1] <path>",
> +       "btrfs subvolume list [-pur] [-s 0|1] <path>",
>         "List subvolumes (and snapshots)",
>         "",
>         "-p           print parent ID",
>         "-u           print the uuid of subvolumes (and snapshots)",
>         "-s value     list snapshots with generation in ascending/descending order",
>         "             (1: ascending, 0: descending)",
> +       "-r           list readonly subvolumes(including snapshots)",

I would add an space between "subvolumes" and "(including snapshots)" here.

>         NULL
>  };

(No kernel developer, thus not commenting on the code.)

Thanks,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
