Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:40351 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751333AbdF3AOX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 29 Jun 2017 20:14:23 -0400
Date: Fri, 30 Jun 2017 02:14:16 +0200
From: Adam Borowski <kilobyte@angband.pl>
To: Nick Terrell <terrelln@fb.com>
Cc: kernel-team@fb.com, Chris Mason <clm@fb.com>, Yann Collet <cyan@fb.com>,
        linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH] btrfs: Keep one more workspace around
Message-ID: <20170630001416.ib3dbh26sbcp6pz7@angband.pl>
References: <20170629175726.1246810-1-terrelln@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20170629175726.1246810-1-terrelln@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 29, 2017 at 10:57:26AM -0700, Nick Terrell wrote:
> The time it took to execute cp vmlinux /mnt/btrfs && sync
> dropped from 1.70s to 1.44s with lzo compression, and from 2.04s to 1.80s
> for zstd compression.

> -	if (*free_ws < num_online_cpus()) {
> +	if (*free_ws <= num_online_cpus()) {

A simple, self-contained, one-character fix that gives a nice speed-up.
What about getting this for 4.13 or perhaps even 4.9?

Workspace flickering is not a very serious bug, but if we can restore wasted
write speed _this_ easily...


-- 
⢀⣴⠾⠻⢶⣦⠀ 
⣾⠁⢠⠒⠀⣿⡁ A dumb species has no way to open a tuna can.
⢿⡄⠘⠷⠚⠋⠀ A smart species invents a can opener.
⠈⠳⣄⠀⠀⠀⠀ A master species delegates.
