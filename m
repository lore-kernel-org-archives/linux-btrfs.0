Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm01.jp.fujitsu.com ([202.219.69.168]:42505 "EHLO
	mgwkm01.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921AbbFWAFh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Jun 2015 20:05:37 -0400
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com [10.134.21.209])
	by kw-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id AA224AC0E0E
	for <linux-btrfs@vger.kernel.org>; Tue, 23 Jun 2015 08:55:23 +0900 (JST)
Message-ID: <5588A056.2080003@jp.fujitsu.com>
Date: Tue, 23 Jun 2015 08:55:02 +0900
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
MIME-Version: 1.0
To: Christian Robottom Reis <kiko@async.com.br>
CC: dsterba@suse.cz, linux-btrfs@vger.kernel.org, Chris Mason <clm@fb.com>
Subject: Re: qgroup limit clearing, was Re: Btrfs progs release 4.1
References: <20150622150023.GX6761@twin.jikos.cz> <201506222052.t5MKqWVM024486@anthem.async.com.br>
In-Reply-To: <201506222052.t5MKqWVM024486@anthem.async.com.br>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2015/06/23 3:18, Christian Robottom Reis wrote:
> On Mon, Jun 22, 2015 at 05:00:23PM +0200, David Sterba wrote:
>>    - qgroup:
>>      - show: distinguish no limits and 0 limit value
>>      - limit: ability to clear the limit
>
> I'm using kernel 4.1-rc7 as per:
>
>      root@riff:/var/lib/lxc/juju-trusty-lxc-template/rootfs# uname -a
>      Linux riff 4.1.0-040100rc7-generic #201506080035 SMP Mon Jun 8 04:36:20 UTC 2015 x86_64 x86_64 x86_64 GNU/Linux
>
> But apart from still having major issues with qgroups (quota enforcement
> triggers even when there seems to be plenty of free space) clearing
> limits with btrfs-progs 4.1 doesn't revert back to 'none', instead
> confusingly setting the quota to 16EiB. Using:
>
>      root@riff:/var/lib/lxc/juju-trusty-lxc-template/rootfs# btrfs version
>      btrfs-progs v4.1
>
> I start from:
>
>      qgroupid         rfer         excl     max_rfer     max_excl
>      --------         ----         ----     --------     --------
>      0/5           2.15GiB      1.95GiB         none         none
>      0/261         1.42GiB      1.11GiB         none    100.00GiB
>      0/265         1.09GiB    600.59MiB         none    100.00GiB
>      0/271       793.32MiB    366.40MiB         none    100.00GiB
>      0/274       514.96MiB    142.92MiB         none    100.00GiB
>
> I then issue:
>
>      root@riff# btrfs qgroup limit -e none 261 /var
>      root@riff# btrfs qgroup limit none 261 /var
>
> I end up with:
>
>      qgroupid         rfer         excl     max_rfer     max_excl
>      --------         ----         ----     --------     --------
>      0/5           2.15GiB      1.95GiB         none         none
>      0/261         1.42GiB      1.11GiB     16.00EiB     16.00EiB
>      0/265         1.09GiB    600.59MiB         none    100.00GiB
>      0/271       793.32MiB    366.40MiB         none    100.00GiB
>      0/274       514.96MiB    142.92MiB         none    100.00GiB
>
> Is that expected?
>

The following fix is necessary for the kernel to display it correctly.

  [PATCH] btrfs: qgroup: allow user to clear the limitation on qgroup
  http://marc.info/?l=linux-btrfs&m=143331495409594&w=2

Thanks,
Tsutomu


--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
