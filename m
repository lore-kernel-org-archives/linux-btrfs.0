Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47990 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751274AbbKZOoS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 26 Nov 2015 09:44:18 -0500
Date: Thu, 26 Nov 2015 15:42:32 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: dsterba@suse.cz, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org, jeffm@suse.com
Subject: Re: [PATCH 00/25] Btrfs-convert rework to support native separate
Message-ID: <20151126144232.GS31035@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1447989869-24739-1-git-send-email-quwenruo@cn.fujitsu.com>
 <20151123173330.GH31035@twin.jikos.cz>
 <565424B8.3020502@cn.fujitsu.com>
 <20151125124235.GO31035@suse.cz>
 <5656547F.5050900@cn.fujitsu.com>
 <20151126093028.GP31035@suse.cz>
 <5656DB29.2030708@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5656DB29.2030708@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 26, 2015 at 06:12:57PM +0800, Qu Wenruo wrote:
> But I'm a little concerned about the unstable headers, unlike ext2 its 
> headers is almost stable but reiserfs seems not.

Well, reiserfs is not developped nowadays and I think Jeff implemented
the bits required for btrfs-convert. The configure script will detect if
the reiser library provided needed functions, compiling reiser in will
be optional anyway.

> What about rebasing my patch to your abstract patch (btrfs-progs: 
> convert: add context and operations struct to allow different file 
> systems) first and add back your reiserfs patch?

Oh right, the patch is independent, I'll add it to devel.

> Your abstract patch is quite nice, although need some modification to 
> work with new convert.

Yes, that's expected.

> I hope to add stable things first and don't want another reiserfs change 
> breaks the compile.

Ok.
