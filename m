Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:37789 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751068AbdICSGi (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 3 Sep 2017 14:06:38 -0400
Date: Sun, 3 Sep 2017 20:06:36 +0200
From: Adam Borowski <kilobyte@angband.pl>
To: Cloud Admin <admin@cloud.haefemeier.eu>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: How to disable/revoke 'compression'?
Message-ID: <20170903180636.ayrubvma7awbki6i@angband.pl>
References: <1504459921.8809.3.camel@cloud.haefemeier.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1504459921.8809.3.camel@cloud.haefemeier.eu>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Sep 03, 2017 at 07:32:01PM +0200, Cloud Admin wrote:
> Hi,
> I used the mount option 'compression' on some mounted sub volumes. How
> can I revoke the compression? Means to delete the option and get all
> data uncompressed on this volume.
> Is it enough to remount the sub volume without this option? Or is it
> necessary to do some addional step (balancing?) to get all stored data
> uncompressed.

If you set it via mount option, removing the option is enough to disable
compression for _new_ files.  Other ways are chattr +c and btrfs-property,
but if you haven't heard about those you almost surely don't have such
attributes set.

After remounting, you may uncompress existing files.  Balancing won't do
this as it moves extents around without looking inside; defrag on the other
hand rewrites extents thus as a side effect it applies new [non]compression
settings.  Thus: ｢btrfs fi defrag -r /path/to/filesystem｣.

> Beside of it, is it possible to find out what the real and compressed size
> of a file, for example or the ratio?

Currently not.

I've once written a tool which does this, but 1. it's extremely slow, 2.
insane, 3. so insane a certain member of this list would kill me had I
distributed the tool.  Thus, I'd need to rewrite it first...


Meow!
-- 
⢀⣴⠾⠻⢶⣦⠀ 
⣾⠁⢰⠒⠀⣿⡁ Vat kind uf sufficiently advanced technology iz dis!?
⢿⡄⠘⠷⠚⠋⠀                                 -- Genghis Ht'rok'din
⠈⠳⣄⠀⠀⠀⠀ 
