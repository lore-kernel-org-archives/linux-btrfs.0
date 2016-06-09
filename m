Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52381 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751315AbcFINNo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 9 Jun 2016 09:13:44 -0400
Date: Thu, 9 Jun 2016 15:13:44 +0200
From: David Sterba <dsterba@suse.cz>
To: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: add the error message when open fails
Message-ID: <20160609131343.GJ3905@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <201606090123.AA00000@WIN-5MHF4RKU941.jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201606090123.AA00000@WIN-5MHF4RKU941.jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 09, 2016 at 10:23:15AM +0900, Tsutomu Itoh wrote:
> When open in btrfs_open_devices failed, only the following message is
> displayed. Therefore the user doesn't understand the reason why open
> failed.
> 
>   # btrfs check /dev/sdb8
>   Couldn't open file system
> 
> This patch adds the error message when open fails.

I think the message should be printed by the caller, not by the helper.
