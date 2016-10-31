Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:56082 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753205AbcJaEVj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 31 Oct 2016 00:21:39 -0400
Date: Sun, 30 Oct 2016 21:21:38 -0700
From: Marc MERLIN <marc@merlins.org>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs check --repair: ERROR: cannot read chunk root
Message-ID: <20161031042138.GL28648@merlins.org>
References: <20161030183437.GA3287@merlins.org> <062d36da-197f-6a58-0b6e-208a5ca9fef3@cn.fujitsu.com> <20161031020616.GH28648@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161031020616.GH28648@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Oct 30, 2016 at 07:06:16PM -0700, Marc MERLIN wrote:
> On Mon, Oct 31, 2016 at 09:02:50AM +0800, Qu Wenruo wrote:
> > Your chunk root is corrupted, and since chunk tree provides the 
> > underlying disk layout, even for single device, so if we failed to read 
> > it, then it will never be able to be mounted.
>  
> That's the thing though, I can mount the filesystem just fine :)

Actually, has anyone seen any configuration where the kernel can mount a
filesystem without ro, or recovery, it can just mount it read/write and
btrfs check --repair can't open it?

This kind of sounds like a bug in check --repair IMO.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
