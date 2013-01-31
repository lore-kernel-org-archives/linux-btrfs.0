Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36473 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751763Ab3AaMq1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Jan 2013 07:46:27 -0500
Received: from relay2.suse.de (unknown [195.135.220.254])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx2.suse.de (Postfix) with ESMTP id 8D2F6A3CEE
	for <linux-btrfs@vger.kernel.org>; Thu, 31 Jan 2013 13:46:26 +0100 (CET)
Date: Thu, 31 Jan 2013 13:46:25 +0100
From: David Sterba <dsterba@suse.cz>
To: David Sterba <dsterba@suse.cz>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Integration branch of btrfs-progs 2013-01-30
Message-ID: <20130131124625.GJ30535@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20130130002427.GD30535@twin.jikos.cz>
 <20130130002658.GE30535@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130130002658.GE30535@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 30, 2013 at 01:26:58AM +0100, David Sterba wrote:
> Stefan Behrens (3):
>       Btrfs-progs: add command to get/reset device stats via ioctl

JFI, pointed out on IRC:

--- a/print-tree.c
+++ b/print-tree.c
@@ -454,6 +454,8 @@ static void print_key_type(u64 objectid, u8 type)
                break;
        case BTRFS_QGROUP_LIMIT_KEY:
                printf("BTRFS_QGROUP_LIMIT_KEY");
+       case BTRFS_DEV_STATS_KEY:
+               printf("DEV_STATS_ITEM");
                break;
        default:
                printf("UNKNOWN.%d", type);

This hunk was mismerged, a missing break before case BTRFS_DEV_STATS_KEY:

I'll fix it in next integration, as it's not so urgent.

david
