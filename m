Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dragon.async.com.br ([208.70.149.241]:47921 "EHLO
	dragon.async.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753002AbbFVUwj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Jun 2015 16:52:39 -0400
Received: from anthem.async.com.br (189-19-234-109.dsl.telesp.net.br [189.19.234.109])
	by dragon.async.com.br (Postfix) with ESMTPS id 955E44540C8
	for <linux-btrfs@vger.kernel.org>; Mon, 22 Jun 2015 15:52:37 -0500 (CDT)
Received: from localhost.localdomain (gasolinux.internal [192.168.99.14])
	by anthem.async.com.br (8.14.4/8.14.4/Debian-2ubuntu2.1) with ESMTP id t5MKqWVM024486
	for <linux-btrfs@vger.kernel.org>; Mon, 22 Jun 2015 17:52:32 -0300
Message-Id: <201506222052.t5MKqWVM024486@anthem.async.com.br>
Date: Mon, 22 Jun 2015 15:18:35 -0300
From: Christian Robottom Reis <kiko@async.com.br>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: qgroup limit clearing, was Re: Btrfs progs release 4.1
References: <20150622150023.GX6761@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150622150023.GX6761@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 22, 2015 at 05:00:23PM +0200, David Sterba wrote:
>   - qgroup:
>     - show: distinguish no limits and 0 limit value
>     - limit: ability to clear the limit

I'm using kernel 4.1-rc7 as per:

    root@riff:/var/lib/lxc/juju-trusty-lxc-template/rootfs# uname -a
    Linux riff 4.1.0-040100rc7-generic #201506080035 SMP Mon Jun 8 04:36:20 UTC 2015 x86_64 x86_64 x86_64 GNU/Linux

But apart from still having major issues with qgroups (quota enforcement
triggers even when there seems to be plenty of free space) clearing
limits with btrfs-progs 4.1 doesn't revert back to 'none', instead
confusingly setting the quota to 16EiB. Using:

    root@riff:/var/lib/lxc/juju-trusty-lxc-template/rootfs# btrfs version
    btrfs-progs v4.1

I start from:

    qgroupid         rfer         excl     max_rfer     max_excl 
    --------         ----         ----     --------     -------- 
    0/5           2.15GiB      1.95GiB         none         none 
    0/261         1.42GiB      1.11GiB         none    100.00GiB 
    0/265         1.09GiB    600.59MiB         none    100.00GiB 
    0/271       793.32MiB    366.40MiB         none    100.00GiB 
    0/274       514.96MiB    142.92MiB         none    100.00GiB 

I then issue:

    root@riff# btrfs qgroup limit -e none 261 /var
    root@riff# btrfs qgroup limit none 261 /var

I end up with:

    qgroupid         rfer         excl     max_rfer     max_excl 
    --------         ----         ----     --------     -------- 
    0/5           2.15GiB      1.95GiB         none         none 
    0/261         1.42GiB      1.11GiB     16.00EiB     16.00EiB 
    0/265         1.09GiB    600.59MiB         none    100.00GiB 
    0/271       793.32MiB    366.40MiB         none    100.00GiB 
    0/274       514.96MiB    142.92MiB         none    100.00GiB 

Is that expected?
-- 
Christian Robottom Reis | [+55 16] 3376 0125   | http://async.com.br/~kiko
CEO, Async Open Source  | [+55 16] 9 9112 6430 | http://launchpad.net/~kiko
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
