Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-po-02v.sys.comcast.net ([96.114.154.161]:36662 "EHLO
	resqmta-po-02v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755499AbaJNUGb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Oct 2014 16:06:31 -0400
Message-ID: <543D8245.4010304@pobox.com>
Date: Tue, 14 Oct 2014 13:06:29 -0700
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: David Arendt <admin@prnet.org>, linux-btrfs@vger.kernel.org
Subject: Re: Random file system corruption in 3.17 (not BTRFS related...?)
References: <543D555B.50708@pobox.com> <543D5BC3.9080008@prnet.org>
In-Reply-To: <543D5BC3.9080008@prnet.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/14/2014 10:22 AM, David Arendt wrote:
> I didn't notice a corruption on other filesystems with kernel 3.17.0.
> Also I didn't experience any hangs except when trying to mount a
> corrupted btrfs but this was causing a hang within less than 10 seconds.
> It could be that your problem is unrelated and that the corruption you
> are experiencing is due to an unrelated hang followed by a hard
> powerdown. Have you been able to capture any btrfs related kernel panics ?

My installation is _not_ well suited for capturing panics.

I have not been able to capture any panics on either system and I had to 
just switch back to 3.16.3 as the two systems were my firewall (ext4) 
and my primary laptop (BTRFS). I didn't want to grind them up with 
repeated crashes and corruptions. I only let the firewall fault once 
before switching back.

The laptop faulted and hung twice under 3.17.0 before I switched it 
back, thinking it was a radeon graphics driver issue. Then I logged into 
the firewall via ssh to check something and three shell commands or so 
in, it went to lunch (but the firewall layer was still passing packets).

The only actual sign of filesystem corruption on the laptop was the 
sudden absence or corruption of the (sqlite3 format) history and 
settings files. But firefox was the only thing I'd been actively using.

Given the way the firewall jammed up and died, and the kind of 
corruption (special files don't get updated that much, let alone to link 
up a directory) -- and the fact that it ran fine as a firewall for 
several hours then died as soon as I touched the file system. I suspect 
that there is something fishy in dcache or the vnode layers.

It was too much too soon on two otherwise stable systems.

I offered this email here because I noticed that people were seeing 
"BTRFS corruption" with 3.17 and I'd seen both BTRFS and EXT4 corruption 
which suggests that BTRFS _isn't_ particularly culpable.


