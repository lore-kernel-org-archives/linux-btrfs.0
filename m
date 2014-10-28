Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48928 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751030AbaJ1PJ0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 28 Oct 2014 11:09:26 -0400
Date: Tue, 28 Oct 2014 16:09:25 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz, clm@fb.com
Subject: Re: [PATCH 1/1] btrfs-progs: code optimize cmd_scan_dev() use
 btrfs_register_one_device()
Message-ID: <20141028150925.GB27030@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1413334238-25729-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1413334238-25729-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 15, 2014 at 08:50:38AM +0800, Anand Jain wrote:
> -void btrfs_register_one_device(char *fname)
> +int btrfs_register_one_device(char *fname)

> -void btrfs_register_one_device(char *fname);
> +int btrfs_register_one_device(char *fname);

JFYI, I changed 'char' to 'const char'.
