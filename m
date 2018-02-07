Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58921 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932119AbeBGQ1W (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 7 Feb 2018 11:27:22 -0500
Date: Wed, 7 Feb 2018 17:25:07 +0100
From: David Sterba <dsterba@suse.cz>
To: Gu Jinxiang <gujx@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH v4 2/3] btrfs-progs: introduce TEST_TOP for resources
 except binaries
Message-ID: <20180207162507.GC3003@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1517895445-17767-1-git-send-email-gujx@cn.fujitsu.com>
 <1517895445-17767-3-git-send-email-gujx@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1517895445-17767-3-git-send-email-gujx@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 06, 2018 at 01:37:24PM +0800, Gu Jinxiang wrote:
> Use TEST_TOP for tests/common, Documentation, images, and internal
> binaries.

Well, the point of TEST_TOP was also to remove the /tests/ subdirectory
from the paths if it's inside git and to set it to the top directory
where the exported testsuite resides. I'm not sure if we should continue
this back-and-forth. The project idea was stated out tersly so the
implementation was left "as an exercise". The v4 is close to what I'd
liek to merge, so let's give it a v5 and if there will be only small
things to fix I'll update the patches at commit time.
