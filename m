Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51591 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751095Ab3JAMDz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 1 Oct 2013 08:03:55 -0400
Date: Tue, 1 Oct 2013 14:03:52 +0200
From: David Sterba <dsterba@suse.cz>
To: Wang Shilong <wangshilong1991@gmail.com>
Cc: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: create helper function to use lblkid to
 scan for btrfs disks
Message-ID: <20131001120352.GB18291@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1380296700-7232-1-git-send-email-anand.jain@oracle.com>
 <5245ADFC.2090706@oracle.com>
 <3CB50CC0-506D-4B7B-B66B-D01FC021BF63@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <3CB50CC0-506D-4B7B-B66B-D01FC021BF63@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Sep 28, 2013 at 12:21:51AM +0800, Wang Shilong wrote:
> > Following this patch the idea is to use lblkid to scan
> > for the btrfs disks by default which means we don't
> > use BTRFS_SCAN_PROC any more.
> 
> Firstly, i would like to know if we will get any different results between scanning
> /proc/partions and using lbkid.

I take blkid as a more authoritative source, /proc/partitions was a
workaround to avoid scanning the whole /dev directory.

> If not, why we can use liblkid totally,since this is more simple.

Agreed, blkid by default and --all-devices as a last resort fallback.
The proc workaround can go away.

david
