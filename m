Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34791 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752218AbcAENxW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 5 Jan 2016 08:53:22 -0500
Date: Tue, 5 Jan 2016 14:51:01 +0100
From: David Sterba <dsterba@suse.cz>
To: Geliang Tang <geliangtang@163.com>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3 v2] btrfs: use list_for_each_entry* in backref.c
Message-ID: <20160105135101.GY4227@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <617786fdb0eb4f593bdc6efffe040ce6ebcb1cc5.1450447999.git.geliangtang@163.com>
 <d65aa20f49405e738c90aaf703ccec31f311de22.1450712597.git.geliangtang@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <d65aa20f49405e738c90aaf703ccec31f311de22.1450712597.git.geliangtang@163.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 21, 2015 at 11:50:23PM +0800, Geliang Tang wrote:
> Use list_for_each_entry*() to simplify the code.
> 
> Signed-off-by: Geliang Tang <geliangtang@163.com>

Reviewed-by: David Sterba <dsterba@suse.com>
