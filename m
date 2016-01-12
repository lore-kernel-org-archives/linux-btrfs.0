Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51127 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753312AbcALSQO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Jan 2016 13:16:14 -0500
Date: Tue, 12 Jan 2016 19:13:48 +0100
From: David Sterba <dsterba@suse.cz>
To: Geliang Tang <geliangtang@163.com>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, Julia Lawall <julia.lawall@lip6.fr>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] btrfs: use list_for_each_entry* in backref.c
Message-ID: <20160112181348.GM4227@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1452611741.git.geliangtang@163.com>
 <222fad42bdeab5259978d086b3f9e466a8f0d531.1452611741.git.geliangtang@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <222fad42bdeab5259978d086b3f9e466a8f0d531.1452611741.git.geliangtang@163.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 12, 2016 at 11:23:16PM +0800, Geliang Tang wrote:
> Use list_for_each_entry*() to simplify the code.
> 
> Signed-off-by: Geliang Tang <geliangtang@163.com>

The patch has been pulled to 4.5 queue already, please do an incremental
against branch integration-4.5 (in Chris' git
git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git)
Thanks.
