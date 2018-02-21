Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f50.google.com ([74.125.83.50]:34364 "EHLO
        mail-pg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S939001AbeBUSIx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Feb 2018 13:08:53 -0500
Received: by mail-pg0-f50.google.com with SMTP id m19so952012pgn.1
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Feb 2018 10:08:53 -0800 (PST)
Date: Wed, 21 Feb 2018 10:08:50 -0800
From: Omar Sandoval <osandov@osandov.com>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v2 03/27] libbtrfsutil: add Python bindings
Message-ID: <20180221180850.GA29126@vader>
References: <cover.1518720598.git.osandov@fb.com>
 <818e5d95ac69282a1e8c193bf92671f4b9982728.1518720598.git.osandov@fb.com>
 <20180221134754.GD1469@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180221134754.GD1469@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 21, 2018 at 02:47:54PM +0100, David Sterba wrote:
> On Thu, Feb 15, 2018 at 11:04:48AM -0800, Omar Sandoval wrote:
> > +setup(
> > +    name='btrfsutil',
> > +    version=get_version(),
> > +    description='Library for managing Btrfs filesystems',
> > +    url='https://github.com/kdave/btrfs-progs',
> > +    license='GPLv3',
> 
> LGPLv3?

Yes, that was a typo. I'll send an incremental patch.
