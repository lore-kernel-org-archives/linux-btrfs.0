Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55484 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932635AbeCSNWw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Mar 2018 09:22:52 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 9640EAEA0
        for <linux-btrfs@vger.kernel.org>; Mon, 19 Mar 2018 13:22:51 +0000 (UTC)
Date: Mon, 19 Mar 2018 14:20:27 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH v2 1/7] btrfs-progs: convert/ext2: Fix inline extent
 creation check
Message-ID: <20180319132026.GF6955@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180313015616.6574-1-wqu@suse.com>
 <20180313015616.6574-2-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180313015616.6574-2-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 13, 2018 at 09:56:10AM +0800, Qu Wenruo wrote:
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Please squash patches 1 and 2 together and write a changelog, somethiing
like is in the cover letter. This is a bugfix, we need to document what
was broken and how it's fixed.
