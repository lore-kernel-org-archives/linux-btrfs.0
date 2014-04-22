Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38326 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755707AbaDVMhe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Apr 2014 08:37:34 -0400
Date: Tue, 22 Apr 2014 14:37:32 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 4/4] btrfs-progs: Fix the return value when executing
 'btrfs pro get' on a uncompress file.
Message-ID: <20140422123732.GA2027@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1397553744-24465-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1397553744-24465-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 15, 2014 at 05:22:24PM +0800, Qu Wenruo wrote:
> When executing 'btrfs pro get' on a file which is not compressed, return
> value will always be 50 since prop_compress() return -ENOATTR.
> 
> But the codes have already check the errno to avoid unnecessary error
> message, so the return value should also set to 0.
> 
> Signed-off-by: Qu Wenruo <quwenro@cn.fujitsu.com>

JFYI, I've edited the subject and changelog, let's use the 'prop'
abbreviation for properties.
