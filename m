Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42604 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752108AbdHDUkk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 4 Aug 2017 16:40:40 -0400
Date: Fri, 4 Aug 2017 13:40:38 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Nikolay Borisov <nborisov@suse.com>
Cc: stable@vger.kernel.org, Omar Sandoval <osandov@osandov.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: please include 17024ad0a0fd ("Btrfs: fix early ENOSPC due to
 delalloc") to 4.12 stable
Message-ID: <20170804204038.GA24251@kroah.com>
References: <0992c84e-1ac5-2a89-65aa-c283bbd08f44@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <0992c84e-1ac5-2a89-65aa-c283bbd08f44@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 04, 2017 at 11:25:14PM +0300, Nikolay Borisov wrote:
> Hello,
> 
> I'd like to aforementioned patch to be applied to stable 4.9/4.12. The
> attached backport applies cleanly to both of them.

Thanks, I'll queue it up after this next release happens.

greg k-h
