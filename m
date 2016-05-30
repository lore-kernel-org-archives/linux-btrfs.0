Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44576 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754643AbcE3Nzw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 May 2016 09:55:52 -0400
Date: Mon, 30 May 2016 15:55:14 +0200
From: David Sterba <dsterba@suse.cz>
To: Fei Fei Xu <feifeixu.sh@gmail.com>
Cc: dsterba@suse.cz, Feifei Xu <xufeifei@linux.vnet.ibm.com>,
        linux-btrfs@vger.kernel.org, steve.capper@linaro.org,
        chandan@mykolab.com, jbacik@fb.com, dsterba@suse.com,
        Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: Re: [PATCH 3/5] Btrfs: self-tests: Support non-4k page size
Message-ID: <20160530135514.GA29147@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <201605270701.u4R6xXUw031405@mx0a-001b2d01.pphosted.com>
 <201605270701.u4R6xPFu036351@mx0a-001b2d01.pphosted.com>
 <20160527192915.GX29147@twin.jikos.cz>
 <574A7B6E.2020904@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <574A7B6E.2020904@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, May 29, 2016 at 01:17:34PM +0800, Fei Fei Xu wrote:
> > There are more instances of the pointed style issues, please fix all of
> > them. As the changes do not affect functionality I'll add the paches to
> > for-next, but I'm expecting a v2.
> Thanks, I will send out v2 soon according to all above comments.

What's the base of the patchset? Does not apply cleanly on the current
integration (ie. what's in master).
