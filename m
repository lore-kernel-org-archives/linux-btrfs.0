Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37059 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752063AbdIAQWx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 1 Sep 2017 12:22:53 -0400
Date: Fri, 1 Sep 2017 18:21:26 +0200
From: David Sterba <dsterba@suse.cz>
To: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: doc: fix btrfs-inspect-internal rootid doc
Message-ID: <20170901162126.GU2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <453da244-de65-e58b-ef28-f6dbff093052@jp.fujitsu.com>
 <20170824173734.GI2866@twin.jikos.cz>
 <28eb3b27-6dc2-cc5c-d563-72a6a49716c7@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <28eb3b27-6dc2-cc5c-d563-72a6a49716c7@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 25, 2017 at 09:34:49AM +0900, Misono, Tomohiro wrote:
> On 2017/08/25 2:37, David Sterba wrote:
> > On Thu, Aug 24, 2017 at 04:39:53PM +0900, Misono, Tomohiro wrote:
> >> "btrfs inspect-internal rootid <path>" rejects a file to be specified in
> >> the implementation.
> >> Therefore change "file or directory" to "directory" in the doc.
> > 
> > Is there a reason why a file should not be accepted? The ioctl supports
> > that just fine.
> 
> I thought ioctl would work for file, but current code checks whether 
> <path> is directory or not in the first place. So, I change the doc.
> 
> If it is better to change the code rather than the doc, I will do that. 
> What do you think?

There are helpers that can open either file or directory from a given
path, eg. open_file_or_dir3 so it can be used.
