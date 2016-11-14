Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42843 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752629AbcKNMNj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 Nov 2016 07:13:39 -0500
Date: Mon, 14 Nov 2016 13:13:35 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 0/5] Make btrfs-progs really compatible with any
 kernel version
Message-ID: <20161114121335.GJ12522@suse.cz>
Reply-To: dsterba@suse.cz
References: <1448283378-10579-1-git-send-email-anand.jain@oracle.com>
 <824aa945-fd1f-45a2-9123-2bd810f464d6@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <824aa945-fd1f-45a2-9123-2bd810f464d6@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 08, 2016 at 09:14:39PM +0800, Anand Jain wrote:
>   This patch isn't integrated, any idea why ?

Because it does not cover all usecases. I've committed the preparatory
bits from branch where I've been working on that feature so we can
actually get to the hard parts.
