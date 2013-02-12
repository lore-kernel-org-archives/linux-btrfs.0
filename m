Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55391 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760483Ab3BLPGS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Feb 2013 10:06:18 -0500
Date: Tue, 12 Feb 2013 16:06:16 +0100
From: David Sterba <dsterba@suse.cz>
To: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, chris.mason@fusionio.com
Subject: Re: [PATCH] Btrfs-progs: check out if the swap device
Message-ID: <20130212150616.GY12339@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <201302120125.AA00019@FM-323941448.jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201302120125.AA00019@FM-323941448.jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 12, 2013 at 10:25:23AM +0900, Tsutomu Itoh wrote:
> Currently, the following commands succeed.
> 
>  # cat /proc/swaps
>  Filename                                Type            Size    Used    Priority
>  /dev/sda3                               partition       8388604 0       -1
>  /dev/sdc8                               partition       9765884 0       -2
>  # mkfs.btrfs /dev/sdc8

if a swap device is backed by a file, mkfs succeeds:

Filename                                Type            Size    Used
Priority
/dev/sda15                              partition       4232016 0 -2
/mnt/swap                               file            10236   0 -3

$ mkfs.btrfs /mnt/swap

WARNING! - Btrfs 0.20 IS EXPERIMENTAL
WARNING! - see http://btrfs.wiki.kernel.org before using

SMALL VOLUME: forcing mixed metadata/data groups
Created a data/metadata chunk of size 1048576
fs created label (null) on /mnt/swap
        nodesize 4096 leafsize 4096 sectorsize 4096 size 10.00MB
Btrfs 0.20
---

Please add check for this as well.

thanks,
david
