Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 50-193-208-193-static.hfc.comcastbusiness.net ([50.193.208.193]:53572
	"EHLO tetsuo.zabbo.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806Ab2GTSTA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Jul 2012 14:19:00 -0400
Date: Fri, 20 Jul 2012 11:18:59 -0700
From: Zach Brown <zab@zabbo.net>
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs-progs: detect if the disk we are formatting is a
 ssd
Message-ID: <20120720181859.GE3889@lenny.home.zabbo.net>
References: <1342797098-6493-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1342797098-6493-1-git-send-email-jbacik@fusionio.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> +static int is_ssd(const char *file)
> +{
> +	char *dev = strrchr(file, '/');

 [ ... ]

> +	snprintf(path, PATH_MAX, "/sys/block/%s/queue/rotational", dev);
> +	fd = open(path, O_RDONLY);

Hmm, this doesn't seem right.  The last path component can have nothing
to do with the underlying device name.  And /sys/block doesn't have
entries for partition devices.

After some poking around (and hints from Eric), it looks like the thing
to do is stat the file to find that it's a block device and then use
blkid_devno_to_wholedisk().  That parses the link from
/sys/dev/block/$maj:$min to find the containing device.

Then it'll work for partitions and nutty udev vanity symlinks.

- z
