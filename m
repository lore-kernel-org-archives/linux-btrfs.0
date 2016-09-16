Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:43034 "EHLO twin.jikos.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751083AbcIPI65 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Sep 2016 04:58:57 -0400
Date: Fri, 16 Sep 2016 10:58:42 +0200
From: David Sterba <dave@jikos.cz>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org,
        clm@fb.com, dsterba@suse.cz
Subject: Re: [RFC] Preliminary BTRFS Encryption
Message-ID: <20160916085842.GB933@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <1473773990-3071-1-git-send-email-anand.jain@oracle.com>
 <bce627a8-7dcc-71f6-dd44-0444f7993725@gmail.com>
 <69c23d9b-c1be-41ba-1382-3505ba88fdf9@oracle.com>
 <ee07da59-9c9d-10f8-8cf5-6dc86a8e3eab@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <ee07da59-9c9d-10f8-8cf5-6dc86a8e3eab@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 15, 2016 at 10:24:02AM -0400, Austin S. Hemmelgarn wrote:
> >> What happens when you try to
> >> clone them in either case if it isn't supported?
> >
> >  Gets -EOPNOTSUPP.
> That actually makes more sense than what my first thought for a return 
> code was (-EINVAL).

Should be -EXDEV, as we do already.
