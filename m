Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42617 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751782AbbBKSGG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 Feb 2015 13:06:06 -0500
Date: Wed, 11 Feb 2015 19:06:04 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH] btrfs-progs: Move -rdynamic linker only option to
 LDFLAGS.
Message-ID: <20150211180604.GG28877@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1423615584-32176-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1423615584-32176-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 11, 2015 at 08:46:24AM +0800, Qu Wenruo wrote:
> Same thing as clang cleanup patch:
> commit 040b3f11ba6b5555d793a9ef79ed4d9032d22370
> Author: Qu Wenruo <quwenruo@cn.fujitsu.com>
> Date:   Fri Dec 19 14:13:08 2014 +0800
> 
>     btrfs-progs: Makefile: Move linker only option to LDFLAGS
> 
> But the move to autoconfig seems using old Makefile.
> So do it again.
> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Applied, thanks.
