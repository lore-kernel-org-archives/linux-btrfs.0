Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57189 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753883AbbIWWIW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Sep 2015 18:08:22 -0400
Date: Wed, 23 Sep 2015 15:08:21 -0700
From: Mark Fasheh <mfasheh@suse.de>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, jbacik@fb.com, clm@fb.com
Subject: Re: [PATCH 0/4] btrfs: update qgroups in drop snapshot
Message-ID: <20150923220821.GE17854@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
References: <1442952948-21389-1-git-send-email-mfasheh@suse.de>
 <56022381.6030606@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <56022381.6030606@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 23, 2015 at 11:58:57AM +0800, Qu Wenruo wrote:
> Hi Mark,
> 
> I'd like to test the patchset, but it seems to be a little out of
> date, and failed to apply to integration-4.3.
> 
> Would you please rebase it to integration-4.3?

Hey Qu I think you just need to drop the patch titled:

    Btrfs: keep dropped roots in cache until transaction commit

since it is already in integration-4.3. Everything else seems to apply on my
end.
	--Mark

--
Mark Fasheh
