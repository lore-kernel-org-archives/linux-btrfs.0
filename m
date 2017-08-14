Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55645 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752199AbdHNQHG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 Aug 2017 12:07:06 -0400
Date: Mon, 14 Aug 2017 18:05:43 +0200
From: David Sterba <dsterba@suse.cz>
To: Ernesto =?iso-8859-1?Q?A=2E_Fern=E1ndez?=
        <ernesto.mnd.fernandez@gmail.com>
Cc: linux-btrfs@vger.kernel.org, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>
Subject: Re: [PATCH v3] btrfs: preserve i_mode if __btrfs_set_acl() fails
Message-ID: <20170814160543.GW2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170729002626.GA6759@debian.home>
 <20170730021838.GA4565@debian.home>
 <20170802061825.GA8058@debian.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <20170802061825.GA8058@debian.home>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 02, 2017 at 03:18:27AM -0300, Ernesto A. Fernández wrote:
> When changing a file's acl mask, btrfs_set_acl() will first set the
> group bits of i_mode to the value of the mask, and only then set the
> actual extended attribute representing the new acl.
> 
> If the second part fails (due to lack of space, for example) and the
> file had no acl attribute to begin with, the system will from now on
> assume that the mask permission bits are actual group permission bits,
> potentially granting access to the wrong users.
> 
> Prevent this by restoring the original mode bits if __btrfs_set_acl
> fails.
> 
> Signed-off-by: Ernesto A. Fernández <ernesto.mnd.fernandez@gmail.com>
> ---
> Please ignore the two previous versions, this is far simpler and has the
> same effect. To Josef Bacik: thank you for your review, I'm sorry I
> wasted your time.

This version is much better, starting the transaction would add some
overhead and would need to be measured so we have an idea about the
impact.

Reviewed-by: David Sterba <dsterba@suse.com>
