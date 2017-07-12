Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53900 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751957AbdGLNw6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Jul 2017 09:52:58 -0400
Date: Wed, 12 Jul 2017 15:51:44 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org,
        rgoldwyn@suse.de
Subject: Re: [PATCH] btrfs: qgroups: Fix BUG_ON condition
Message-ID: <20170712135144.GB2866@suse.cz>
Reply-To: dsterba@suse.cz
References: <1499841739-18549-1-git-send-email-nborisov@suse.com>
 <9f2efc65-1972-e200-72ff-2ccf29da06d1@gmx.com>
 <20170712134242.GA2866@suse.cz>
 <04a1f309-28ac-33e9-cf8f-fb0b991c0b06@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <04a1f309-28ac-33e9-cf8f-fb0b991c0b06@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 12, 2017 at 04:50:20PM +0300, Nikolay Borisov wrote:
> > As you wrote, it was not obvious that there was no change on the line,
> > this just slowed down reading the patch.
> 
> I didn't intentionally fix this, I've configured vi so as to
> automatically do this. There is also whitespace damage on a particular
> line in extent-tree.c and every time I submit a patch that touches this
> file I explicitly have to omit that particular hunk.
> 
> How would you feel about me sending a patch fixing those 2 whitespace
> damages?

Can't you fix your editor not to auto-correct? :)
