Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:49834 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235AbcBOQlA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Feb 2016 11:41:00 -0500
Date: Mon, 15 Feb 2016 08:40:37 -0800
From: Marc MERLIN <marc@merlins.org>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: David Sterba <dsterba@suse.cz>,
        Btrfs mailing list <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs-image failure (btrfs-tools 4.4)
Message-ID: <20160215164037.GK4115@merlins.org>
References: <20160125205500.GK23751@merlins.org> <56A6C5CB.5060406@cn.fujitsu.com> <20160211063132.GX13969@merlins.org> <56BC355F.1080305@cn.fujitsu.com> <20160211150947.GY13969@merlins.org> <20160211151339.GZ13969@merlins.org> <56BD2847.8070403@cn.fujitsu.com> <20160212172628.GJ2763@merlins.org> <20160214172659.GD4115@merlins.org> <56C1191C.7030309@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <56C1191C.7030309@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 15, 2016 at 08:17:32AM +0800, Qu Wenruo wrote:
> Sorry for the late reply.
> 
> According to the output of your btrfsck --repair output, things just get 
> worse.
> 
> So at this point, it's harder to locate the original problem. (Csum 
> missing with bad file extents)
> 
> IMHO you can wipe the fs now.

Sounds good. I've just done so then. Thanks for your replies.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
