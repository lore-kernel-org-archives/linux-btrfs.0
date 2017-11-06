Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38612 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752750AbdKFNmZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 6 Nov 2017 08:42:25 -0500
Date: Mon, 6 Nov 2017 14:40:33 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 06/11] btrfs: document device locking
Message-ID: <20171106134033.GC28789@suse.cz>
Reply-To: dsterba@suse.cz
References: <cover.1509471604.git.dsterba@suse.com>
 <5f3dc05b0b44803e9d20498970f259ead2bfe7de.1509471604.git.dsterba@suse.com>
 <798c9b24-4688-27f0-3553-c4313ba6bc91@oracle.com>
 <22384755-34ff-d45e-8bd8-9d4914a8774a@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <22384755-34ff-d45e-8bd8-9d4914a8774a@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 06, 2017 at 10:32:48AM +0800, Anand Jain wrote:
> >> + * Lock nesting
> >> + * ------------
> >> + *
> >> + * uuid_mutex
> >> + *   volume_mutex
> 
> I think it should be nested like this, but as of now its not. Ref [1]
>   [1]
>   btrfs: move volume_mutex into the btrfs_rm_device()

Right, this violates the documented rules and I think that's because of
the ambiguous semantic of the uuid_mutex. Here we're using the "on a
mounted filesystem" part so we lock only in the context where this
applies. Again, once volume_mutex is gone, this will be fixed.
