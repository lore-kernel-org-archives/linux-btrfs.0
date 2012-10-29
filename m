Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:37886 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759689Ab2J2SLh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Oct 2012 14:11:37 -0400
Date: Mon, 29 Oct 2012 11:11:35 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: zwu.kernel@gmail.com
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxram@linux.vnet.ibm.com, viro@zeniv.linux.org.uk,
        david@fromorbit.com, tytso@mit.edu, cmm@us.ibm.com,
        wuzhy@linux.vnet.ibm.com, wenqing.lz@taobao.com
Subject: Re: [RFC v4+ hot_track 13/19] debugfs: introduce one function
Message-ID: <20121029181135.GB3605@kroah.com>
References: <1351485061-12297-1-git-send-email-zwu.kernel@gmail.com>
 <1351485061-12297-14-git-send-email-zwu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1351485061-12297-14-git-send-email-zwu.kernel@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 29, 2012 at 12:30:55PM +0800, zwu.kernel@gmail.com wrote:
> From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
> 
>   The debugfs function is used to get expected dentry.

Huh?  Why do you need this?  Why haven't you added documentation for the
function saying what it does?

confused,

greg k-h
