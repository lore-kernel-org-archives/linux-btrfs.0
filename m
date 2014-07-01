Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from pipebreaker.pl ([109.107.25.67]:60186 "EHLO
	mother.pipebreaker.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187AbaGAHoo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Jul 2014 03:44:44 -0400
Date: Tue, 1 Jul 2014 09:44:41 +0200
From: Tomasz Torcz <tomek@pipebreaker.pl>
To: linux-btrfs@vger.kernel.org
Subject: Re: Kernel panic / Ubuntu 12.04.4
Message-ID: <20140701074441.GC9937@mother.pipebreaker.pl>
References: <20140701064559.GP30445@nightfall.bogus.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140701064559.GP30445@nightfall.bogus.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 01, 2014 at 08:45:59AM +0200, Tor Houghton wrote:
> Well, I probably should have looked at the logs first and not tried to delete
> some old data, but as the command (rm -rf) hung, I got suspicious:
> 
> Jun 30 23:51:06 moonshade kernel: [ 1440.454721] btrfs: relocating block group 2939934474240 flags 1
> Jun 30 23:51:07 moonshade kernel: [ 1440.637248] btrfs: relocating block group 2999510827008 flags 36
> Jun 30 23:51:07 moonshade kernel: [ 1440.897153] btrfs: relocating block group 2997363343360 flags 36
> Jun 30 23:51:07 moonshade kernel: [ 1441.147110] btrfs: relocating block group 2995215859712 flags 36

  Looks like balance running?

> Jul  1 01:31:47 moonshade kernel: [ 7480.673992] Pid: 17884, comm: btrfs Not tainted 3.5.0-40-generic #62~precise1-Ubuntu Dell Inc.                 Dell DM051                   /0HJ054

  Kernel 3.5 is extremely old and lacks fixes from 11 kernel releases done
afterwards.  Please contact your vendor (Canonical?) for support.

-- 
Tomasz Torcz                "Funeral in the morning, IDE hacking
xmpp: zdzichubg@chrome.pl    in the afternoon and evening." - Alan Cox

