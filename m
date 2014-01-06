Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:39925 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755666AbaAFQY0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 Jan 2014 11:24:26 -0500
Received: by mail-ie0-f174.google.com with SMTP id at1so18847933iec.33
        for <linux-btrfs@vger.kernel.org>; Mon, 06 Jan 2014 08:24:26 -0800 (PST)
Message-ID: <1389025462.18558.8.camel@sasami.ottawa.blindsidenetworks.com>
Subject: Re: Help! - "btrfs device delete missing" running out of space
From: Calvin Walton <calvin.walton@kepstin.ca>
To: Piotr =?UTF-8?Q?Paw=C5=82ow?= <pp@siedziba.pl>
Cc: linux-btrfs@vger.kernel.org
Date: Mon, 06 Jan 2014 11:24:22 -0500
In-Reply-To: <laca4i$7lq$1@ger.gmane.org>
References: <labocc$5ue$1@ger.gmane.org> <laca4i$7lq$1@ger.gmane.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, 2014-01-05 at 19:00 +0000, Piotr Pawłow wrote:
> Hello,
> > distribution, used space on each device should be accordingly: 160, 
> > 216, and 405.
> 
> The last number should be 376, I copied the wrong one. Anyway, I deleted 
> as much data as possible, which probably won't help in the end, but at 
> the moment it's still going. Meanwhile, I made a script to replicate this 
> problem:
> 
> http://pastebin.com/W2c2pJYp

I'm not sure what the solution is, but the issue seems to be that btrfs
is laying out the RAID1 like this:

Mirror A   Mirror B
+------+   +------+
| 250g |   | 300g |
+------+   |      |
|      |   +------+
| 500g |   ////////
|      |   ////////
+------+   ////////

Rather than the hoped-for:

Mirror A   Mirror B
+------+   +------+
| 250g |   |      |
+------+   | 500g |
| 300g |   |      |
|      |   +------+
+------+   ////////

As far as I know, there's no way to tune this at the moment.

-- 
Calvin Walton <calvin.walton@kepstin.ca>

