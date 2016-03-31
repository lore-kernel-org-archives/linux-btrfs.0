Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56210 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752076AbcCaQqV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Mar 2016 12:46:21 -0400
Date: Thu, 31 Mar 2016 18:45:44 +0200
From: David Sterba <dsterba@suse.cz>
To: Yauhen Kharuzhy <yauhen.kharuzhy@zavadatar.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Reset IO error counters before start of device
 replacing
Message-ID: <20160331164544.GH6230@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1459286268-16461-1-git-send-email-yauhen.kharuzhy@zavadatar.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1459286268-16461-1-git-send-email-yauhen.kharuzhy@zavadatar.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 29, 2016 at 02:17:48PM -0700, Yauhen Kharuzhy wrote:
> If device replace entry was found on disk at mounting and its num_write_errors
> stats counter has non-NULL value, then replace operation will never be
> finished and -EIO error will be reported by btrfs_scrub_dev() because
> this counter is never reset.
> 
>  # mount -o degraded /media/a4fb5c0a-21c5-4fe7-8d0e-fdd87d5f71ee/
>  # btrfs replace status /media/a4fb5c0a-21c5-4fe7-8d0e-fdd87d5f71ee/
>  Started on 25.Mar 07:28:00, canceled on 25.Mar 07:28:01 at 0.0%, 40 write errs, 0 uncorr. read errs
>  # btrfs replace start -B 4 /dev/sdg /media/a4fb5c0a-21c5-4fe7-8d0e-fdd87d5f71ee/
>  ERROR: ioctl(DEV_REPLACE_START) failed on "/media/a4fb5c0a-21c5-4fe7-8d0e-fdd87d5f71ee/": Input/output error, no error
> 
> Reset num_write_errors and num_uncorrectable_read_errors counters in the
> dev_replace structure before start of replacing.
> 
> Signed-off-by: Yauhen Kharuzhy <yauhen.kharuzhy@zavadatar.com>

Reviewed-by: David Sterba <dsterba@suse.com>
