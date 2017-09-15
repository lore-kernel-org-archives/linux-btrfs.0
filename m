Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38036 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751152AbdIOPtf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 15 Sep 2017 11:49:35 -0400
Date: Fri, 15 Sep 2017 17:48:03 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: kreijack@inwind.it, linux-btrfs@vger.kernel.org,
        Austin S Hemmelgarn <ahferroin7@gmail.com>
Subject: Re: [PATCH v2 7/7] btrfs-progs: Doc/mkfs: Add extra condition for
 rootdir option
Message-ID: <20170915154803.GA29043@suse.cz>
Reply-To: dsterba@suse.cz
References: <20170911063612.32114-1-quwenruo.btrfs@gmx.com>
 <20170911063612.32114-8-quwenruo.btrfs@gmx.com>
 <20170912170304.GD29043@twin.jikos.cz>
 <0a949fd9-f0cf-22c5-4e91-ebb1bfad1355@libero.it>
 <20170912180753.GI29043@suse.cz>
 <0c906ea3-bfdb-a088-f940-4b63a3da8d2f@gmx.com>
 <20170915125605.GY29043@twin.jikos.cz>
 <9d514995-7706-0157-6b98-93632fe3dce7@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <9d514995-7706-0157-6b98-93632fe3dce7@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 15, 2017 at 09:24:19PM +0800, Qu Wenruo wrote:
> > I'm going to review & merge this series to devel. Tests and
> > documentation should be updated to make the usecase clear.
> 
> I'm happy to address any comment, both code and doc/test.

For the tests I'd like to see:

* with file target, try non-existent file, zero-length file, too-small
  file and large-enough

* for block device target, I think loop device would do, too-small and
  large-enough

* after the test, verify that the files have same size and contents
