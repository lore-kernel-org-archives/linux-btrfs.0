Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35251 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751535Ab3IMQVS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Sep 2013 12:21:18 -0400
Date: Fri, 13 Sep 2013 18:21:16 +0200
From: David Sterba <dsterba@suse.cz>
To: dsterba@suse.cz, Anand Jain <anand.jain@oracle.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 2/2] btrfs-progs: use kernel for mounted and lblkid to
 scan disks
Message-ID: <20130913162116.GN6810@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1377851756-4009-1-git-send-email-anand.jain@oracle.com>
 <1378460273-20647-1-git-send-email-anand.jain@oracle.com>
 <1378460273-20647-2-git-send-email-anand.jain@oracle.com>
 <20130912163629.GD6810@twin.jikos.cz>
 <5232EDA6.6060902@oracle.com>
 <20130913155646.GL6810@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130913155646.GL6810@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 13, 2013 at 05:56:46PM +0200, David Sterba wrote:
> Reproduced with today's linus tree (btrfs pull is there), progs contain the
> patches in question:

Reproduces with the updated patches you sent today.
