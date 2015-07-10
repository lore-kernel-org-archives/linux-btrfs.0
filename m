Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from www.digint.ch ([92.42.190.51]:55945 "EHLO mail.digint.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753480AbbGJKyU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 10 Jul 2015 06:54:20 -0400
Subject: Re: Anyone tried out btrbk yet?
To: Martin Steigerwald <martin@lichtvoll.de>
References: <11148188.L9vtSMaNHV@merkaba>
From: Axel Burri <axel@tty0.ch>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <559FA280.8090309@tty0.ch>
Date: Fri, 10 Jul 2015 12:46:24 +0200
MIME-Version: 1.0
In-Reply-To: <11148188.L9vtSMaNHV@merkaba>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2015-07-09 14:26, Martin Steigerwald wrote:

> Well I may try it for one of my BTRFS volumes in addition to the rsync 
> backup for now. I would like to give all options on command line, but well, 
> maybe it can completely replace my current script if I put everything in its 
> configuration.

One reason why btrbk exists is that I wanted to have all my backups
configured in a config file. I use btrbk to backup several hosts to
several backup locations (around 20 subvolumes), which made setting
everything up with command-line options very cumbersome.

For simpler setups you might be better off with command-line based tools
(e.g. Marcs "btrfs-subvolume-backup", which I like for it's smallness).

Give it a try, there is a "dryrun" command in btrbk :)
Ask on github if you need help.


- Axel
