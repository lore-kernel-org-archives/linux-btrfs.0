Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:55693 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752582AbcKHAj4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Nov 2016 19:39:56 -0500
Date: Mon, 7 Nov 2016 16:39:50 -0800
From: Marc MERLIN <marc@merlins.org>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: David Sterba <dsterba@suse.com>, Hugo Mills <hugo@carfax.org.uk>,
        linux-btrfs@vger.kernel.org
Subject: Re: btrfs support for filesystems >8TB on 32bit architectures
Message-ID: <20161108003950.GD13371@merlins.org>
References: <20161107012009.xng7hyhoqwqres3u@merlins.org> <8e2407ee-c137-44c3-b9c8-4dec931d6c3a@cn.fujitsu.com> <0b840fbb-1a3d-d395-47ad-015e84eac05a@cn.fujitsu.com> <20161107053647.uj7df3ppve4pbfms@merlins.org> <10ed4e8a-c9a6-961a-fb51-16186da079e4@cn.fujitsu.com> <20161107145502.7lahpm6smqsv6s2q@merlins.org> <cf75cc57-62f9-2d88-a544-72a45aadd674@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <cf75cc57-62f9-2d88-a544-72a45aadd674@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 08, 2016 at 08:35:54AM +0800, Qu Wenruo wrote:
> >Understood. One big thing (for me) I forgot to confirm:
> >1) btrfs receive
> 
> Unfortunately, receive is completely done in userspace.
> Only send works inside kernel.
 
right, I've confirmed that btrfs receive fails.
It looks like btrfs balance is also failing, which is more surprising.
Isn't that one in the kernel?

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
