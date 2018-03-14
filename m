Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f51.google.com ([74.125.83.51]:41476 "EHLO
        mail-pg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751835AbeCNO24 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Mar 2018 10:28:56 -0400
Received: by mail-pg0-f51.google.com with SMTP id w17so1419851pgq.8
        for <linux-btrfs@vger.kernel.org>; Wed, 14 Mar 2018 07:28:56 -0700 (PDT)
Date: Wed, 14 Mar 2018 08:28:52 -0600
From: Tycho Andersen <tycho@tycho.ws>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: WARN when unmounting a subvolume that is being synced
Message-ID: <20180314142852.GA19493@cisco>
References: <20180314031051.n6e4ymnlkz4yztic@smitten>
 <783b8c49-3844-21a2-9609-67f9b4c8a5e1@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <783b8c49-3844-21a2-9609-67f9b4c8a5e1@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 14, 2018 at 09:46:07AM +0200, Nikolay Borisov wrote:
> 
> 
> On 14.03.2018 05:10, Tycho Andersen wrote:
> > Hi all,
> > 
> > I'm getting the WARN below. I think (?) what I'm doing when I get it
> > is that I'm unmounting a subvolume while it's being synced (concurrent
> > uses of the subvolume, at least, happy to look into it further if the
> > stack trace is not so useful). Anyway, I can fairly reliably reproduce
> > this on 4.16-rc4.
> > 
> > Thoughts?
> 
> Yeah, you've mounted the filesystem with flushoncommit. THe easiest
> thing would be to remount with that option ommitted i.e the default
> behavior. This is a well-known issue, unfortunately fixing it is a bit
> hairy and deadlock prone against fs freeze.

Excellent, thanks!

Tycho
