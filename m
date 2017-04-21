Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:36053 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1038126AbdDULGC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 21 Apr 2017 07:06:02 -0400
Date: Fri, 21 Apr 2017 13:05:59 +0200
From: Adam Borowski <kilobyte@angband.pl>
To: Sargun Dhillon <sargun@sargun.me>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: allow processes with cap_sys_resource to exceed
 quota
Message-ID: <20170421110558.lx56fsrbengxqwuy@angband.pl>
References: <20170421100943.GA2942@ircssh-2.c.rugged-nimbus-611.internal>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20170421100943.GA2942@ircssh-2.c.rugged-nimbus-611.internal>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 21, 2017 at 10:09:46AM +0000, Sargun Dhillon wrote:
> This patch allows processes with CAP_SYS_RESOURCE to exceed the qgroup
> limit. It's useful for administrative programs, such as log rotation,
> that may need to temporarily use more disk space in order to free up
> a greater amount of overall disk space without yielding more disk
> space to the rest of userland.

>  static bool qgroup_check_limits(const struct btrfs_qgroup *qg, u64 num_bytes)
>  {
> +	if (capable(CAP_SYS_RESOURCE))
> +		return true;
> +

I don't think it's a good idea to make random root-uid processes ignore
qgroups completely.  Just because the daemon in question doesn't use a
separate uid is no reason to not protect you from it consuming all the disk
space.

A temporary request "please let me exceed limits" would make sense, though.

The problem with CAP_SYS_RESOURCE is that it's always on unless explicitly
dropped.

-- 
⢀⣴⠾⠻⢶⣦⠀ Meow!
⣾⠁⢠⠒⠀⣿⡁
⢿⡄⠘⠷⠚⠋⠀ Collisions shmolisions, let's see them find a collision or second
⠈⠳⣄⠀⠀⠀⠀ preimage for double rot13!
