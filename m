Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f182.google.com ([209.85.213.182]:42558 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751727AbaAMTao (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 Jan 2014 14:30:44 -0500
Received: by mail-ig0-f182.google.com with SMTP id uy17so3527129igb.3
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Jan 2014 11:30:43 -0800 (PST)
Message-ID: <1389641439.9531.2.camel@sasami.ottawa.blindsidenetworks.com>
Subject: Re: btrfs versions compatibility and updates
From: Calvin Walton <calvin.walton@kepstin.ca>
To: Martin <m_btrfs@ml1.co.uk>
Cc: linux-btrfs@vger.kernel.org
Date: Mon, 13 Jan 2014 14:30:39 -0500
In-Reply-To: <lb18r7$q52$1@ger.gmane.org>
References: <lb18r7$q52$1@ger.gmane.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 2014-01-13 at 17:47 +0000, Martin wrote:
> There's the very good idea of releasing the btrfs userspace tools with a
> version number that matches the kernel version... Good to see a good
> jump for what is considered 'stable'.
> 
> 
> What is the policy for maintaining compatibility with whatever range of
> kernel versions?
> 
> And what is the state of play now for the "Chris Mason" or whatever
> latest 'stable' branch of btrfs on git?
> 
> 
> In other words: Should we always update the btrfs userspace tools to the
> latest even though we may be running one or two kernels behind that?...

In a recent thread on this mailing list:
http://permalink.gmane.org/gmane.comp.file-systems.btrfs/31536
it looks like the decision made was that the latest btrfs-progs should
support older kernels.

-- 
Calvin Walton <calvin.walton@kepstin.ca>

