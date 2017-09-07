Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f51.google.com ([74.125.83.51]:34089 "EHLO
        mail-pg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751634AbdIGRYz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Sep 2017 13:24:55 -0400
Received: by mail-pg0-f51.google.com with SMTP id q68so650115pgq.1
        for <linux-btrfs@vger.kernel.org>; Thu, 07 Sep 2017 10:24:55 -0700 (PDT)
Date: Thu, 7 Sep 2017 10:24:53 -0700
From: Omar Sandoval <osandov@osandov.com>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH 5/7] Btrfs: fix suspicious RCU in BTRFS_IOC_DEV_INFO
Message-ID: <20170907172453.GB17057@vader.DHCP.thefacebook.com>
References: <cover.1503470354.git.osandov@fb.com>
 <433d5c3c5a47154a8bead243a9f6e0c8b3b7ad7d.1503470354.git.osandov@fb.com>
 <20170906153728.GW31874@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170906153728.GW31874@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 06, 2017 at 05:37:28PM +0200, David Sterba wrote:
> On Tue, Aug 22, 2017 at 11:46:03PM -0700, Omar Sandoval wrote:
> > From: Omar Sandoval <osandov@fb.com>
> > 
> > A naked read of the value of an RCU pointer isn't safe. Put the whole
> > access in an RCU critical section, not just the pointer dereference.
> 
> In this case it is safe, as the device will not go away (and potentially
> free dev->name) because it's under the device_list_mutex.
> 
> The locking around devices and related structures is not exactly
> straightforward, but here I don't think we need to stick to the RCU
> pattern if the protection is guaranteed by other means. This applies to
> uuid_mutex and device_list_mutex.

You're right, it's a little confusing because uuid_mutex protects
device->name, so under device_list_mutex, device->name might change but
will never become NULL. We can just drop this one, thanks!
