Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40569 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751722AbaLJMpR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Dec 2014 07:45:17 -0500
Date: Wed, 10 Dec 2014 13:45:16 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v4 08/13] btrfs-progs: Add count_digit() function to help
 calculate filename len.
Message-ID: <20141210124516.GB27601@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1418113652-25088-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1418113652-25088-9-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1418113652-25088-9-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 09, 2014 at 04:27:27PM +0800, Qu Wenruo wrote:
> +static inline int count_digit(u64 num)

FYI, I've renamed it to count_digits, and updated all callers.
