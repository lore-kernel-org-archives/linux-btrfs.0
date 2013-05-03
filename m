Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:47758 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756340Ab3ECFys (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 3 May 2013 01:54:48 -0400
Message-ID: <1367560631.23415.2.camel@sauron.fi.intel.com>
Subject: Re: imperfect FIEMAP results on btrfs
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Dave Chinner <david@fromorbit.com>
Cc: linux-btrfs@vger.kernel.org, linux-ext4 <linux-ext4@vger.kernel.org>
Date: Fri, 03 May 2013 08:57:11 +0300
In-Reply-To: <20130502233103.GA15549@dastard>
References: <1367510414.32396.90.camel@sauron.fi.intel.com>
	 <20130502233103.GA15549@dastard>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 2013-05-03 at 09:31 +1000, Dave Chinner wrote:
> IOWs, you simply can't assume that a specific test will give you the
> same block layout across filesystems and different filesystem
> configurations. Welcome to the world of "can't assume anything about
> block layout" pain xfstests has been dealing with for years ;)

This is what I also assumed, but wanted to get some feed-back from the
community. Thanks a lot for the answer!

-- 
Best Regards,
Artem Bityutskiy

