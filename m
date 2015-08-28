Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35777 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752594AbbH1Rdz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 28 Aug 2015 13:33:55 -0400
Date: Fri, 28 Aug 2015 19:33:17 +0200
From: David Sterba <dsterba@suse.cz>
To: Zhao Lei <zhaolei@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: tests: Add testcase filter for misc-tests
Message-ID: <20150828173317.GK11834@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <09dc1a986fea9d55b40095632d1efd8f4c050730.1440733418.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <09dc1a986fea9d55b40095632d1efd8f4c050730.1440733418.git.zhaolei@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 28, 2015 at 11:43:56AM +0800, Zhao Lei wrote:
> Add testcase filter for misc-tests, so we can select to run necessary
> test cases.
> 
> For example:
>  # ./misc-tests.sh 002
>     [TEST]   002-uuid-rewrite
>  #
>  # ./misc-tests.sh subvolume
>     [TEST]   007-subvolume-sync
>  #

I'm not sure this is is necessary, the TEST variable can be used for
that purpose:

 $ TEST='002*' ./misc-tests.sh
