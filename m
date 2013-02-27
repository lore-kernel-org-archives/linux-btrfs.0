Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40971 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758160Ab3B0PL2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Feb 2013 10:11:28 -0500
Date: Wed, 27 Feb 2013 16:11:26 +0100
From: David Sterba <dsterba@suse.cz>
To: Wang Shilong <wangshilong1991@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] Btrfs-progs: let the error message outputed only once
Message-ID: <20130227151126.GF27541@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1361963001-1934-1-git-send-email-wangshilong1991@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1361963001-1934-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 27, 2013 at 07:03:21PM +0800, Wang Shilong wrote:
> From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
> 
> If we fail to execute the command:
> 		btrfs qgroup show <mnt>
> It will output the follow messages:
> 	ERROR: can't perform the search - Inappropriate ioctl for device
> 	ERROR: can't list qgroups
> 
> The error is outputed twice, this is wrong, fix it.

Right, thanks. The helper should not print anything. Both patches added to
integration.

david
