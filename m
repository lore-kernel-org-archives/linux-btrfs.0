Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53906 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751554AbbA3RIb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 30 Jan 2015 12:08:31 -0500
Date: Fri, 30 Jan 2015 18:08:30 +0100
From: David Sterba <dsterba@suse.cz>
To: clm@fb.com
Cc: David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3.19-rc] btrfs: add read-only check to sysfs handler of
 features
Message-ID: <20150130170830.GO3641@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1422035531-22930-1-git-send-email-dsterba@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1422035531-22930-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 23, 2015 at 06:52:11PM +0100, David Sterba wrote:
> We don't want to trigger the change on a read-only filesystem, similar
> to what the label handler does.
> 
> Signed-off-by: David Sterba <dsterba@suse.cz>

Please drop this patch, seems that the right way to the ro/rw & freeze
protection is to use sb_start_write & co.
