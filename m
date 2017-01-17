Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50039 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750957AbdAQPQt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Jan 2017 10:16:49 -0500
Date: Tue, 17 Jan 2017 16:15:07 +0100
From: David Sterba <dsterba@suse.cz>
To: lakshmipathi.g@giis.co.in
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btfs-progs: fsck-tests: corrupt nlink value test
Message-ID: <20170117151506.GS12081@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170107231955.GA24631@fedori>
 <c9e21f30-2231-94cd-09ed-8422951e7b69@cn.fujitsu.com>
 <fdc7f38883f4333cad73b7a92a1ba00a@giis.co.in>
 <77e26cd7-0390-d02e-3dda-7107a2c68e7d@cn.fujitsu.com>
 <f5ef3a5bec7fccbd06559eda6a7cf59a@giis.co.in>
 <9592e847-74a9-d530-96a1-b7b8888975e3@cn.fujitsu.com>
 <43f607d52e2ba14633096022575bb5de@giis.co.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <43f607d52e2ba14633096022575bb5de@giis.co.in>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 16, 2017 at 09:35:52AM -0700, lakshmipathi.g@giis.co.in wrote:
> If btrfs-corrupt-block is in bad shape, then corruption scripts around 
> them won't help in long term.
> 
> Yes, documentation for btrfs-corrupt-block needs improvement.  imo, 
> re-arranged priority will be like : (5), (1)/(3) then (4).  Agree that 
> some corner cases, having static image is best option, i think the 
> corruption test-case needs to be mixture of both static-images and 
> scripts.

Both approaches have their pros and cons so I'll accept both. The
functionality provided by the corrupt block utility can be used, any
changes to the command line UI will be also applied to the test scripts.
