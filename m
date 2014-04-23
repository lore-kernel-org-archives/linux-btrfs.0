Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f179.google.com ([209.85.213.179]:60231 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752767AbaDWUZo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Apr 2014 16:25:44 -0400
Received: by mail-ig0-f179.google.com with SMTP id hl10so55652igb.6
        for <linux-btrfs@vger.kernel.org>; Wed, 23 Apr 2014 13:25:44 -0700 (PDT)
Message-ID: <1398284721.20580.7.camel@sasami>
Subject: Re: Can anyone boot a system using btrfs root with linux 3.14 or
 newer?
From: Calvin Walton <calvin.walton@kepstin.ca>
To: Kai Krakow <hurikhan77+btrfs@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Date: Wed, 23 Apr 2014 16:25:21 -0400
In-Reply-To: <vifl2b-87g.ln1@hurikhan77.spdns.de>
References: <000001cf5f19$ac92b2b0$05b81810$@petrovi.no-ip.info>
	 <vifl2b-87g.ln1@hurikhan77.spdns.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 2014-04-23 at 21:06 +0200, Kai Krakow wrote:
> Пламен Петров <plamen@petrovi.no-ip.info> schrieb:
> 
> I'm going with the module suggestion from Marc, too.
> 
> > /dev/sda2              /         btrfs     relatime,compress=zlib 0      0
> 
> This line looks kinda useless to me. The compress=zlib option won't be 
> applied at boot and cannot be changed at runtime because AFAIR btrfs does 
> not allow that yet.

... My understanding is that the compress= option on btrfs *can* be
changed at run time. After remounting with a compress= option, later
writes will be done using the newly selected algorithm.

The compress= option is filesystem-wide, you cannot currently use
different compress= options for different subvolumes. Mounting a
subvolume with a different compress= option will change the compression
algorithm for all mounted subvolumes on that filesystem.

(Note that I wouldn't recommend zlib on most systems as a / filesystem -
it's slow to decompress compared to lzo, so it will cause slower boots
if your disk is reasonably fast.)

-- 
Calvin Walton <calvin.walton@kepstin.ca>

