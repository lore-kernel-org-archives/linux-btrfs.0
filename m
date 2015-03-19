Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60952 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753523AbbCSRtv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Mar 2015 13:49:51 -0400
Date: Thu, 19 Mar 2015 18:49:50 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/7] btrfs: Check qgroup level in kernel qgroup assign.
Message-ID: <20150319174950.GG20767@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1425025468-29749-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1425025468-29749-2-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1425025468-29749-2-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 27, 2015 at 04:24:22PM +0800, Qu Wenruo wrote:
> Although we have qgroup level check in btrfs-progs, it's not enough
> since other programe may still call ioctl directly not using
> btrfs-progs. For example, systemd.
> 
> But it's btrfs-progs to be blame since we don't provide a
> full-function(like subvolume create things) btrfs library with enough
> check, and only rely on kernel ioctl.
> 
> So Add level checks in kernel too.

The checks should be duplicated in kernel if they are part of the qgroup
naming/numbering protocol. The library interface would help programmers
to get it right but as there's a direct interface via the ioctls, the
checks have to be there regardless.
