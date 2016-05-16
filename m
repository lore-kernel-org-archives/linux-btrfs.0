Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33787 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751815AbcEPNt0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 May 2016 09:49:26 -0400
Date: Mon, 16 May 2016 15:48:59 +0200
From: David Sterba <dsterba@suse.cz>
To: Zhao Lei <zhaolei@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 0/3] btrfs-progs: autogen: Some compatibility fixs
Message-ID: <20160516134859.GD511@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1463110976.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <cover.1463110976.git.zhaolei@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 13, 2016 at 11:44:50AM +0800, Zhao Lei wrote:
> Changelog v1->v2:
> 1: btrfs-progs: autogen: Make build success in CentOS 6 and 7
>    Add AC_SUBST(UDEVDIR), suggested by: Jeff Mahoney <jeffm@suse.com>
> 
> Zhao Lei (3):
>   btrfs-progs: autogen: Avoid chdir fail on dirname with blank
>   btrfs-progs: autogen: Make build success in CentOS 6 and 7
>   btrfs-progs: autogen: Don't show success message on fail

Applied, thanks.
