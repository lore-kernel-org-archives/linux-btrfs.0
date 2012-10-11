Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:47418 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751901Ab2JKTns (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Oct 2012 15:43:48 -0400
Date: Thu, 11 Oct 2012 21:43:35 +0200
From: David Sterba <dave@jikos.cz>
To: Stefan Priebe <s.priebe@profihost.ag>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Josef Bacik <jbacik@fusionio.com>, miaox@cn.fujitsu.com
Subject: Re: problems with btrfs send / restore
Message-ID: <20121011194335.GE4405@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <50771F22.3070501@profihost.ag>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <50771F22.3070501@profihost.ag>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 11, 2012 at 09:33:54PM +0200, Stefan Priebe wrote:
> [server: /btrfs/target]# btrfs send -i /btrfs/src/\@snapshot/1
> /btrfs/src/\@snapshot/2 | btrfs receive /btrfs/target/\@snapshot/
> At subvol /btrfs/src/@snapshot/2
> At subvol 2
> ERROR: failed to open /btrfs/target/@snapshot/@snapshot/1/test.tar. No such file or directory
                                      ^^^^^^^^^^^^^^^^^^^

I wonder if this is the ghost snapshot dir entry that Miao fixed. Did
somehow get into the 'send' stream and confused the receive side.

david
