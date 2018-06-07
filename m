Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43533 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753121AbeFGMZd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 7 Jun 2018 08:25:33 -0400
Date: Thu, 7 Jun 2018 14:22:46 +0200
From: David Sterba <dsterba@suse.cz>
To: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs-progs: check: Initialize all filed of
 btrfs_inode_item in insert_inode_item()
Message-ID: <20180607122246.GB3215@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1528339598.git.misono.tomohiro@jp.fujitsu.com>
 <a9e2495c-6085-4efb-5257-f58a5019e2b7@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <a9e2495c-6085-4efb-5257-f58a5019e2b7@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 07, 2018 at 11:49:58AM +0900, Misono Tomohiro wrote:
> Initialize all filed of btrfs_inode_item to zero in order to prevent
> having some garbage, especially for flags field.

Have you observed in practice or is it a matter of precaution?
