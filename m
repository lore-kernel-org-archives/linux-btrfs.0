Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57185 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751039AbdEETJl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 5 May 2017 15:09:41 -0400
Date: Fri, 5 May 2017 21:09:34 +0200
From: David Sterba <dsterba@suse.cz>
To: Sargun Dhillon <sargun@sargun.me>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] btrfs: Add quota_override knob into sysfs
Message-ID: <20170505190934.GO10575@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170421231232.GA3769@ircssh-2.c.rugged-nimbus-611.internal>
 <20170421231304.GA3787@ircssh-2.c.rugged-nimbus-611.internal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170421231304.GA3787@ircssh-2.c.rugged-nimbus-611.internal>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 21, 2017 at 11:13:06PM +0000, Sargun Dhillon wrote:
> This patch adds the read-write attribute quota_override into sysfs.
> Any process which has cap_sys_resource can set this flag to on, and
> once it is set to true, processes with cap_sys_resource can exceed
> the quota.

So we've moved to the hardest part, where to put the sysfs file and how
to name it.

My first though was against putting it right under the filesystem UUID
and rather introduce a directory with all tunables, but we already
have a read-write label there. Ok then.

The valid values are 0 and 1. And no locking is needed as fs_info::flags
are updated atomically (once patch 1 is updated).
