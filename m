Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:57764 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756298Ab3HONig (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 15 Aug 2013 09:38:36 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 1B5E27C068B
	for <linux-btrfs@vger.kernel.org>; Thu, 15 Aug 2013 07:38:36 -0600 (MDT)
Date: Thu, 15 Aug 2013 09:38:33 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Filipe David Manana <fdmanana@gmail.com>
CC: Josef Bacik <jbacik@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: separate out tests into their own directory
Message-ID: <20130815133833.GE26269@localhost.localdomain>
References: <1376508521-8666-1-git-send-email-jbacik@fusionio.com>
 <CAL3q7H4EO+SXXDfRJHw4Zg+Lbg8b4VAby2=b43r3v2K7mLUseg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CAL3q7H4EO+SXXDfRJHw4Zg+Lbg8b4VAby2=b43r3v2K7mLUseg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 15, 2013 at 01:23:53AM +0100, Filipe David Manana wrote:
> On Wed, Aug 14, 2013 at 8:28 PM, Josef Bacik <jbacik@fusionio.com> wrote:
> > The plan is to have a bunch of unit tests that run when btrfs is loaded when you
> > build with the appropriate config option.  My ultimate goal is to have a test
> > for every non-static function we have, but at first I'm going to focus on the
> > things that cause us the most problems.  To start out with this just adds a
> > tests/ directory and moves the existing free space cache tests into that
> > directory and sets up all of the infrastructure.  Thanks,
> >
> > Signed-off-by: Josef Bacik <jbacik@fusionio.com>
> 
> Josef this seems to have broke compilation when sanity checks are not enabled.
> The following patch fixes it for me at least. Thanks.
> 

Weird that's what I committed but not what I sent to the list, sorry about that.
Thanks,

Josef
