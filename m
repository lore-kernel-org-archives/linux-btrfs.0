Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:36076 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751154AbdFVCj2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Jun 2017 22:39:28 -0400
Date: Thu, 22 Jun 2017 04:39:24 +0200
From: Adam Borowski <kilobyte@angband.pl>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH] btrfs: Remove false alert when fiemap range is smaller
 than on-disk extent
Message-ID: <20170622023924.q6fmqvillg5yoyu4@angband.pl>
References: <20170622020121.8381-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20170622020121.8381-1-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 22, 2017 at 10:01:21AM +0800, Qu Wenruo wrote:
> Commit 4751832da990 ("btrfs: fiemap: Cache and merge fiemap extent before
> submit it to user") introduced a warning to catch unemitted cached
> fiemap extent.
> 
> However such warning doesn't take the following case into consideration:
> 
> 0			4K			8K
> |<---- fiemap range --->|
> |<----------- On-disk extent ------------------>|

With this fix, my filesystem doesn't appear to go in flames yet.

-- 
⢀⣴⠾⠻⢶⣦⠀ 
⣾⠁⢠⠒⠀⣿⡁ A dumb species has no way to open a tuna can.
⢿⡄⠘⠷⠚⠋⠀ A smart species invents a can opener.
⠈⠳⣄⠀⠀⠀⠀ A master species delegates.
