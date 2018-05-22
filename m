Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55743 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751668AbeEVLIr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 May 2018 07:08:47 -0400
Date: Tue, 22 May 2018 13:06:01 +0200
From: David Sterba <dsterba@suse.cz>
To: Gu Jinxiang <gujx@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: remove unnecessary if judge
Message-ID: <20180522110600.GD6649@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1526895134-1714-1-git-send-email-gujx@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1526895134-1714-1-git-send-email-gujx@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 21, 2018 at 05:32:14PM +0800, Gu Jinxiang wrote:
> Since add_excluded_extent always returns 0,
> no need to judge ret.

The whole calltree starting in this function needs to be examined, if
there's a function that can retrun value (like set_extent_bits) or if
there's a BUG_ON that needs to be turned to proper error handling and
pushed upwards eventually.

When dealing with deep call sequences, it's fine and actually
recommended to do one step at a time. See eg. 57599c7e7722daf5 .

Do all necessary error handling in the function (undo changes, free
resources, etc) and return a value. The caller that does not handle the
return value at all will get the BUG_ON and will be converted the same
way in next patch.
