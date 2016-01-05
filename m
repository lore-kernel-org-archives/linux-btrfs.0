Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34783 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751645AbcAENxQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 5 Jan 2016 08:53:16 -0500
Date: Tue, 5 Jan 2016 14:50:55 +0100
From: David Sterba <dsterba@suse.cz>
To: Geliang Tang <geliangtang@163.com>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] btrfs: use list_for_each_entry_safe in
 free-space-cache.c
Message-ID: <20160105135055.GX4227@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <8a5a49f737a7eed984c8f92f4684d9a6b761f2f2.1450447999.git.geliangtang@163.com>
 <b87e3c3186f2f308924b2e09d112036912233c9d.1450447999.git.geliangtang@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <b87e3c3186f2f308924b2e09d112036912233c9d.1450447999.git.geliangtang@163.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Dec 18, 2015 at 10:17:00PM +0800, Geliang Tang wrote:
> Use list_for_each_entry_safe() instead of list_for_each_safe() to
> simplify the code.
> 
> Signed-off-by: Geliang Tang <geliangtang@163.com>

Reviewed-by: David Sterba <dsterba@suse.com>
