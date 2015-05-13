Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36291 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932272AbbEMQZK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 May 2015 12:25:10 -0400
Date: Wed, 13 May 2015 18:25:08 +0200
From: David Sterba <dsterba@suse.cz>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: clm@fb.com, jbacik@fb.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs: use after free when closing devices
Message-ID: <20150513162507.GR23255@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1431473498-15773-1-git-send-email-sasha.levin@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1431473498-15773-1-git-send-email-sasha.levin@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 12, 2015 at 07:31:37PM -0400, Sasha Levin wrote:
> __btrfs_close_devices() would call_rcu to free the device, which is racy with
> list_for_each_entry() accessing the memory to retrieve the next device on the
> list.
> 
> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>

Reviewed-by: David Sterba <dsterba@suse.cz>
