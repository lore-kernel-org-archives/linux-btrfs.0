Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60414 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751790AbaBNS7u (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Feb 2014 13:59:50 -0500
Date: Fri, 14 Feb 2014 19:59:48 +0100
From: David Sterba <dsterba@suse.cz>
To: Justin Maggard <jmaggard10@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs-progs: add dry-run option to restore command
Message-ID: <20140214185948.GB16073@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1392403247-3627-1-git-send-email-jmaggard10@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1392403247-3627-1-git-send-email-jmaggard10@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 14, 2014 at 10:40:47AM -0800, Justin Maggard wrote:
> Sometimes it is useful to see what btrfs restore is going to do
> before provisioning enough external storage to restore onto.
> Add a dry-run option so we can see what files and paths are found
> by restore, without actually restoring any data.
> 
> Signed-off-by: Justin Maggard <jmaggard10@gmail.com>

Thanks, I've added a

+       if (dry_run)
+               printf("This is a dry-run, no files are going to be restored\n");
+

before the actual restoring starts so user knows.
