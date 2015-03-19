Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35854 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750920AbbCSSzX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Mar 2015 14:55:23 -0400
Date: Thu, 19 Mar 2015 19:55:21 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH 25/26] Btrfs: sysfs: support seed devices in the sysfs
 layout v3
Message-ID: <20150319185521.GH20767@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1425940724-7744-1-git-send-email-anand.jain@oracle.com>
 <1425940724-7744-26-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1425940724-7744-26-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 10, 2015 at 06:38:43AM +0800, Anand Jain wrote:
>   by using the kobject_move()

Then you should add the kobject_move patch to this patchset as well,
with Greg's ack.
