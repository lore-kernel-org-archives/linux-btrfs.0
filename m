Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p05-ob.rzone.de ([81.169.146.181]:13224 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532Ab3KAJvj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Nov 2013 05:51:39 -0400
Message-ID: <527379A9.3070602@jan-o-sch.net>
Date: Fri, 01 Nov 2013 10:51:37 +0100
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
MIME-Version: 1.0
To: Karl Kiniger <karl.kiniger@med.ge.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: btrfs send/receive do not keep inode ctimes
References: <20131025131216.GA14134@kipc2.localdomain>
In-Reply-To: <20131025131216.GA14134@kipc2.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Karl,

On Fri, October 25, 2013 at 15:12 (+0200), Karl Kiniger wrote:
> is there low level support to change inode ctimes somehow?
> (on ext[234] it can be done using debugfs)

No.

> It would be nice to make received snapshots as similar as
> possible to their send source. (I am not talking about
> uuids and such, just ls -lc output)

This is not planned. Currently, we do not even preserve the inode number. Can
you give a short explanation of your use case, why do you need to keep the ctime?

Thanks,
-Jan
