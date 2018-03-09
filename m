Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33135 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932116AbeCIO4X (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 9 Mar 2018 09:56:23 -0500
Date: Fri, 9 Mar 2018 15:54:01 +0100
From: David Sterba <dsterba@suse.cz>
To: Menion <menion@gmail.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: dmesg flooded with "Very big device. Trying to use READ
 CAPACITY(16)" with 8TB HDDs
Message-ID: <20180309145401.GS23693@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CAJVZm6etk=bL0LY3FZXkm5Wun64F4w6HMxdLhKRD-v+mEGm08w@mail.gmail.com>
 <CAJVZm6e0+urcBNrVkXSwvuckTt1A2R8uj536ZzHcB9eG9FoqpQ@mail.gmail.com>
 <20180302151805.GB5942@twin.jikos.cz>
 <CAJVZm6dQacWC0hVWoBxy2H3cSm78pCSqyJkD9Ch4AWLdUrwh9w@mail.gmail.com>
 <CAJVZm6fb+PZ+0tn+JsWK54Nq4W50TwCO7nAaasLoyOm2M13okQ@mail.gmail.com>
 <CAJVZm6eGXez164prciYkemOVVLQ+=RqfvyfB+wzW+imtxVP66w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAJVZm6eGXez164prciYkemOVVLQ+=RqfvyfB+wzW+imtxVP66w@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 08, 2018 at 12:18:04PM +0100, Menion wrote:
> Actually this path can be taken in few occurrency
> 
> 1) device probe, only when the device is plugged or detected the first time
> 2) revalidate_disk fops of block device
> 
> Is it possible that BTRFS every 5 minutes call the revalidate_disk?

An idea: udev or blkid cache refresh, triggers 'btrfs dev scan' that
calls blkdev_get_by_path that could in turn call the revalidation and
whatnot.

Alternatively you can patch the code and add a WARN_ON right after the
message, the stacktrace will tell for sure from where it gets triggered.
