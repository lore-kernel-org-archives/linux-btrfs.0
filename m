Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41428 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753123AbcKRSc0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 Nov 2016 13:32:26 -0500
Date: Fri, 18 Nov 2016 19:32:22 +0100
From: David Sterba <dsterba@suse.cz>
To: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: qgroup: fix error in ASSERT condition
 expression
Message-ID: <20161118183222.GG12522@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <201611170501.AA00016@WIN-5MHF4RKU941.jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201611170501.AA00016@WIN-5MHF4RKU941.jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 17, 2016 at 02:01:31PM +0900, Tsutomu Itoh wrote:
> Option -f, -F and --sort don't work because a conditional expression
> of ASSERT is wrong.
> 
> Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>

Applied, thanks.
