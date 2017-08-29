Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:37655 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752791AbdH2OkE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 29 Aug 2017 10:40:04 -0400
Date: Tue, 29 Aug 2017 07:39:55 -0700
From: Marc MERLIN <marc@merlins.org>
To: Josef Bacik <jbacik@fb.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Chris Murphy <lists@colorremedies.com>, Chris Mason <clm@fb.com>,
        "bo.li.liu@oracle.com" <bo.li.liu@oracle.com>,
        "fdmanana@suse.com" <fdmanana@suse.com>,
        David Sterba <dsterba@suse.cz>
Subject: Re: BTRFS: error (device dm-2) in btrfs_run_delayed_refs:2960: errno=-17 Object already exists (since 3.4 / 2012)
Message-ID: <20170829143955.GD15290@merlins.org>
References: <20170715004828.f4bom5wq34abe4lz@merlins.org> <20170711062155.hvlx5ud4zphpzjnp@merlins.org> <20170715012216.njq6az3y34qyomtb@merlins.org> <20170715231245.GA28281@merlins.org> <20170829031637.GA15290@merlins.org> <F952197E-3A13-410A-B299-F5C0791A99DF@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <F952197E-3A13-410A-B299-F5C0791A99DF@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 29, 2017 at 02:30:19PM +0000, Josef Bacik wrote:
> Sorry Marc, I’ll wire up a bcc script to try and catch when this
> happens.  In order for it to work it’ll need to read the extent tree in
> before you mount the fs, is that something you’ll be able to swing or is
> this your root fs?  Also is it the only btrfs fs on the system?  Thanks,

HI Josef, thanks for your reply.

Thankfully it's not the root FS.
There are 3 btrfs filesystems on that system.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
