Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43227 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753321AbbBKSTN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 Feb 2015 13:19:13 -0500
Date: Wed, 11 Feb 2015 19:19:11 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org,
        dsterba@suse.cz, clm@fb.com
Subject: Re: [PATCH 1/4] Btrfs-progs: add regression tests for sysfs contents
 during btrfs device management
Message-ID: <20150211181911.GI28877@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1423465506-30934-1-git-send-email-anand.jain@oracle.com>
 <1423465506-30934-2-git-send-email-anand.jain@oracle.com>
 <54D86EAC.3090803@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <54D86EAC.3090803@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 09, 2015 at 04:24:12PM +0800, Qu Wenruo wrote:
> This tests are not even not bind to btrfs-progs.
> They are kernel tests in fact.
> 
> So btrfs-progs isn't the best place for it.

Well, I agree. Userspace tools mostly exercise the checker, repair or
image, ie. mostly offline actions.  The mount test that now exists is to
really check that the fixed filesystem can be mounted.

The tests Anand proposes perform add, replace, seeding etc. That really
belongs to fstests.
