Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42693 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760052Ab3B0Pw5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Feb 2013 10:52:57 -0500
Date: Wed, 27 Feb 2013 16:52:55 +0100
From: David Sterba <dsterba@suse.cz>
To: Wang Shilong <wangshilong1991@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs-progs: fix parse_limit function to return errors
 when parsing unit
Message-ID: <20130227155255.GI27541@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1361449575-1835-1-git-send-email-wangshilong1991@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1361449575-1835-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 21, 2013 at 08:26:15PM +0800, Wang Shilong wrote:
> From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
> 
> Steps to reproduce:
> 	btrfs qgroup limit m <mnt>/subv
> 
> Here, unit(k/K/g/G/m/M/t/T) all will trigger the problem.
> For the above command, the original code will parse the limit value as 0
> and return successfully.It is wrong,fix it.

I don't think we should allow to accept bare units for specifing
numbers, so in that case fail with 'unrecognized limit'.

david
