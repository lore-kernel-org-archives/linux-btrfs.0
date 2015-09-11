Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40818 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751875AbbIKOxM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Sep 2015 10:53:12 -0400
Date: Fri, 11 Sep 2015 16:52:25 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: fix cross stripe boundary check
Message-ID: <20150911145225.GO8891@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1441897376-5572-1-git-send-email-dsterba@suse.com>
 <55F21FE5.2030008@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <55F21FE5.2030008@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 11, 2015 at 08:27:17AM +0800, Qu Wenruo wrote:
> BTW, any idea to add mkfs test?

Yes, I'll add a test that will cycle through combinations of various
options (nodesize, raid profiles).
