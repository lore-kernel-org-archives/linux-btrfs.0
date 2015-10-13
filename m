Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51167 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752552AbbJMMtS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 13 Oct 2015 08:49:18 -0400
Date: Tue, 13 Oct 2015 14:48:08 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH RESEND 0/3] btrfs-progs: Introduce device delete by devid
Message-ID: <20151013124808.GJ27761@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1444487458-2988-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1444487458-2988-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Oct 10, 2015 at 10:30:55PM +0800, Anand Jain wrote:
> This is the btrfs-progs part of the kernel patch
>    Btrfs: Introduce device delete by devid

Thanks, now in next/delete-by-id-v3, I made some changes so please have
a look. Notably, I've dropped the BTRFS_VOL_ARG_V2_FLAGS mask, this
belongs to kernel only (unless you need it userspace of course).
