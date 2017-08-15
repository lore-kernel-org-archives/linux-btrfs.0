Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58530 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751569AbdHONW0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 15 Aug 2017 09:22:26 -0400
Date: Tue, 15 Aug 2017 15:21:03 +0200
From: David Sterba <dsterba@suse.cz>
To: filipbystricky@google.com
Cc: linux-btrfs@vger.kernel.org, salyzyn@android.com
Subject: Re: [PATCH 1/3] copied android.mk from devel branch
Message-ID: <20170815132103.GA2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170802185111.187922-1-filipbystricky@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170802185111.187922-1-filipbystricky@google.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 02, 2017 at 11:51:09AM -0700, filipbystricky@google.com wrote:
> From: Filip Bystricky <filipbystricky@google.com>
> 
> This series of patches fixes some compile errors that trigger when
> compiling to android devices.
> 
> This first patch just brings in devel's Android.mk, to which
> kdave@ added a few fixes recently.
> 
> Signed-off-by: Filip Bystricky <filipbystricky@google.com>
> Reviewed-by: Mark Salyzyn <salyzyn@android.com>

The changes in this patch are already applied in current master or devel
branch, so the resulting diff is empty. The patches 2 and 3 bring the
real fixes so I'm going to apply them but patch 2 lacks the changelog.
It should briefly describe the type of changes.

As you've probably fixed the current compilation issues, I'd like to
avoid future breakage when we update the standard Makefile. The travis
CI could be used in connection with the docker images, but I'm open to
other suggestions to do verify builds in other CI systems if there's
some already established practice.
