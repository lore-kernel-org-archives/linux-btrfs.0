Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57241 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752358Ab3LQOfr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Dec 2013 09:35:47 -0500
Date: Tue, 17 Dec 2013 15:35:45 +0100
From: David Sterba <dsterba@suse.cz>
To: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: fix btrfstune silence on failure
Message-ID: <20131217143545.GO6498@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1386928786-4976-1-git-send-email-guihc.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1386928786-4976-1-git-send-email-guihc.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Dec 13, 2013 at 05:59:46PM +0800, Gui Hecheng wrote:
> Originally, btrfstune will fail without any options and just exit
> with no failure prompt.

Works for me:

$ ./btrfstune
usage: btrfstune [options] device
	-S value        enable/disable seeding
	-r              enable extended inode refs
	-x enable skinny metadata extent refs

> Now, the number of arguments are checked before parse options
> and error msg will show up upon failure.

No, the arguments should be parsed first. The btrfstune utility does not
use the same parser helpers like check_argc_exact and actually the bug
you see could be caused by missing optind = 1 before the while () loop.

Can you please test if this helps?

--- a/btrfstune.c
+++ b/btrfstune.c
@@ -115,6 +115,7 @@ int main(int argc, char *argv[])
        int skinny_flag = 0;
        int ret;

+       optind = 1;
        while(1) {
                int c = getopt(argc, argv, "S:rx");
                if (c < 0)
