Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:37832 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752045Ab2J2SKm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Oct 2012 14:10:42 -0400
Date: Mon, 29 Oct 2012 11:10:40 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: zwu.kernel@gmail.com
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxram@linux.vnet.ibm.com, viro@zeniv.linux.org.uk,
        david@fromorbit.com, tytso@mit.edu, cmm@us.ibm.com,
        wuzhy@linux.vnet.ibm.com, wenqing.lz@taobao.com
Subject: Re: [RFC v4+ hot_track 15/19] sysfs: add two hot_track proc files
Message-ID: <20121029181040.GA3605@kroah.com>
References: <1351485061-12297-1-git-send-email-zwu.kernel@gmail.com>
 <1351485061-12297-16-git-send-email-zwu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1351485061-12297-16-git-send-email-zwu.kernel@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 29, 2012 at 12:30:57PM +0800, zwu.kernel@gmail.com wrote:
> From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
> 
>   Add two proc files hot-kick-time and hot-update-delay
> under the dir /proc/sys/fs/ in order to turn
> TIME_TO_KICK and HEAT_UPDATE_DELAY into be tunable.

As you say, these are proc files, not sysfs files, so please fix the
 Subject: up here.

thanks,

greg k-h
