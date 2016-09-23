Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:41255 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1760490AbcIWOkM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 23 Sep 2016 10:40:12 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1bnRe0-0005ui-Gt
        for linux-btrfs@vger.kernel.org; Fri, 23 Sep 2016 16:40:04 +0200
To: linux-btrfs@vger.kernel.org
From: Holger =?iso-8859-1?q?Hoffst=E4tte?=
        <holger@applied-asynchrony.com>
Subject: Re: [PATCH v2 2/6] Btrfs: fix mount -o clear_cache,space_cache=v2
Date: Fri, 23 Sep 2016 14:37:58 +0000 (UTC)
Message-ID: <pan$d50c6$e983460$c9fecddf$860c751a@applied-asynchrony.com>
References: <218563982dbe4387c60909eeb0add6914a20f813.1474580472.git.osandov@fb.com>
        <016aef0e9b3421cc2d2cce0914a746a14eb7af45.1474580472.git.osandov@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 22 Sep 2016 17:24:21 -0700, Omar Sandoval wrote:

> From: Omar Sandoval <osandov@fb.com>
> 
> We moved the code for creating the free space tree the first time that
> it's enabled, but didn't move the clearing code along with it. This
> breaks my (undocumented) intention that `mount -o
> clear_cache,space_cache=v2` would clear the free space tree and then
> recreate it.
> 
> Fixes: 511711af91f2 ("btrfs: don't run delayed references while we are creating the free space tree")
> Cc: stable@vger.kernel.org # 4.5+
> Signed-off-by: Omar Sandoval <osandov@fb.com>

Tested-by: Holger Hoffstätte <holger@applied-asynchrony.com>

Thanks!
Holger

