Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:35059 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932305Ab2JaAka (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Oct 2012 20:40:30 -0400
Date: Wed, 31 Oct 2012 01:40:27 +0100
From: David Sterba <dave@jikos.cz>
To: ching <lsching17@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs defrag problem
Message-ID: <20121031004027.GE3102@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <508FBE50.6070300@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <508FBE50.6070300@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 30, 2012 at 07:47:28PM +0800, ching wrote:
>     failed to open /bin/bash
>     open:: Text file busy

That's not a btrfs problem, you can't directly modify an executable that
is being used.

>     failed to open /lib64/ld-2.15.so
>     failed to open /sbin/agetty
>     failed to open /sbin/btrfs
>     failed to open /sbin/dhclient
>     failed to open /sbin/init
>     failed to open /sbin/udevd

libraries, currently executed progs or daemons

>     It seems that locked files cannot be defragged, is it expected behaviour?

Yes.

> 2. Btrfs Wiki mentions that defrag directory will defrag metadata, is symlink/hardlink considered as metadata?
>     P.S. inline data is already disabled by "max_inline=0"

Both -links are metadata and also stored inside metadata blocks without
any chance to move to data blocks, so max_inline does not affect this.

> 3. Is any possible to online defrag a btrfs partition without hindered by mount point/polyinstantied directories?

Sorry, I do not understand the question.

david
