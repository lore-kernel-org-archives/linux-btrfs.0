Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52509 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751262AbbKWRfP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Nov 2015 12:35:15 -0500
Date: Mon, 23 Nov 2015 18:33:30 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 00/25] Btrfs-convert rework to support native separate
Message-ID: <20151123173330.GH31035@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1447989869-24739-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1447989869-24739-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 20, 2015 at 11:24:04AM +0800, Qu Wenruo wrote:
> Here comes the 1st version of btrfs-convert rework.
> Any test is welcomed, and it can already pass the convert test from
> btrfs-progs. (Since the test doesn't test rollback function)

I went through the patches, looks mostly ok akin to the proposed
changes. I'll take the independent patches rightaway. Unfortunatelly
there are code changes that clash significantly with the pending
reiserfs addition to convert, I'm afraid you'll have to rework your
patchset on top of that.  The code is now pushed to branch
'dev/convert-reiser'.
