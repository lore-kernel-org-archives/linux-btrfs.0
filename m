Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36080 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753042Ab3ITRii (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Sep 2013 13:38:38 -0400
Date: Fri, 20 Sep 2013 09:53:02 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: David Sterba <dsterba@suse.cz>
Cc: stable@vger.kernel.org, Josef Bacik <jbacik@fusionio.com>,
        Chris Mason <chris.mason@fusionio.com>, linux-btrfs@vger.kernel.org
Subject: Re: Handful of btrfs fixes for 3.11.x stable
Message-ID: <20130920165301.GA11262@kroah.com>
References: <1379694879-29402-1-git-send-email-dsterba@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1379694879-29402-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 20, 2013 at 06:34:39PM +0200, David Sterba wrote:
> Hi stable team,
> 
> please add the following commits to 3.11 tree, they fix user visible problems,
> were tested and are now present in 3.12-rc1.
> 
> 3d05ca371200b3366530621abf73769024581b79
> b13a004528c3e5eb060a26eee795f5a0da7bfe9f
> 7ef67ffda91cc0c56f33937bfdf1d057b9ee96ca
> ca6d07c1d74bf7ba3083bc31a9aeeaa1d0ad86aa
> 
> Josef Bacik (4):
>   Btrfs: reset ret in record_one_backref
>   Btrfs: change how we queue blocks for backref checking
>   Btrfs: skip subvol entries when checking if we've created a dir already
>   Btrfs: remove ourselves from the cluster list under lock

Thanks for this, I'll queue them up soon.  Are any of these applicable
for 3.10 as well?

greg k-h
