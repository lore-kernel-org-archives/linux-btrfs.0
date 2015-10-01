Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53601 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933013AbbJANqp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 1 Oct 2015 09:46:45 -0400
Date: Thu, 1 Oct 2015 15:45:44 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, clm@fb.com, dsterba@suse.cz
Subject: Re: [PATCH 21/23] Btrfs: fix fs logging for multi device
Message-ID: <20151001134544.GE5885@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1439548388-29686-1-git-send-email-anand.jain@oracle.com>
 <1439548388-29686-22-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1439548388-29686-22-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 14, 2015 at 06:33:06PM +0800, Anand Jain wrote:
> In case of multi device btrfs fs, using one of device for
> the logging purpose it quite confusing, instead use the
> fsid. FSID is bit long, but the device path can be long
> as well in some cases.

The fsid in the log would be good but yeah it's quite long. Though the
device paths could be long as well, they are not in most cases. The uuid
length is 36 bytes, a device mapper path starts at 12 (prefix) plus the
volume name.

Please send this patch separately with a RFC tag so we can hopeully have
a discussion among more people.
