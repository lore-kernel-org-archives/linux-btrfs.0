Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60724 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752077AbaLSNwa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Dec 2014 08:52:30 -0500
Date: Fri, 19 Dec 2014 14:52:29 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 5/5] btrfs-progs: Remove deprecated _BSD_SOURCE macro.
Message-ID: <20141219135229.GI27601@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1418969592-21278-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1418969592-21278-6-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1418969592-21278-6-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Dec 19, 2014 at 02:13:12PM +0800, Qu Wenruo wrote:
> -#define _BSD_SOURCE
> +#define _DEFAILT_SOURCE

_DEFAULT_SOURCE, I'll fix that.
