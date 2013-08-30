Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:41229 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752406Ab3H3MZd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 30 Aug 2013 08:25:33 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 282869A06A0
	for <linux-btrfs@vger.kernel.org>; Fri, 30 Aug 2013 06:25:33 -0600 (MDT)
Date: Fri, 30 Aug 2013 08:25:29 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
CC: Josef Bacik <jbacik@fusionio.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: separate out tests into their own directory V2
Message-ID: <20130830122529.GH10591@localhost.localdomain>
References: <1377804569-1957-1-git-send-email-jbacik@fusionio.com>
 <521FF91B.10309@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <521FF91B.10309@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 30, 2013 at 09:44:59AM +0800, Wang Shilong wrote:
> On 08/30/2013 03:29 AM, Josef Bacik wrote:
> >The plan is to have a bunch of unit tests that run when btrfs is loaded when you
> >build with the appropriate config option.  My ultimate goal is to have a test
> >for every non-static function we have, but at first I'm going to focus on the
> >things that cause us the most problems.  To start out with this just adds a
> >tests/ directory and moves the existing free space cache tests into that
> >directory and sets up all of the infrastructure.  Thanks,
> >
> >Signed-off-by: Josef Bacik <jbacik@fusionio.com>
> 
> Nothing serious, use checkpatch.pl and i get the following warnings:
> 
>  WARNING: kfree(NULL) is safe this check is probably not required
> #132: FILE: fs/btrfs/free-space-cache.c:3035:
> +    if (map)
> +        kfree(map);
> 

Good point about this, I will do it.

> WARNING: line over 80 characters
> #882: FILE: fs/btrfs/tests/free-space-tests.c:211:
> +    ret = test_add_free_space_entry(cache, 4 * 1024 * 1024, 1 * 1024 *
> 1024, 1);
> 
> WARNING: line over 80 characters
> #927: FILE: fs/btrfs/tests/free-space-tests.c:256:
> +    ret = test_add_free_space_entry(cache, 1 * 1024 * 1024, 4 * 1024 *
> 1024, 1);
> 
> WARNING: line over 80 characters
> #947: FILE: fs/btrfs/tests/free-space-tests.c:276:
> +    ret = test_add_free_space_entry(cache, 4 * 1024 * 1024, 4 * 1024 *
> 1024, 1);
> 
> WARNING: line over 80 characters
> #953: FILE: fs/btrfs/tests/free-space-tests.c:282:
> +    ret = test_add_free_space_entry(cache, 2 * 1024 * 1024, 2 * 1024 *
> 1024, 0);
> 
> WARNING: line over 80 characters
> #1016: FILE: fs/btrfs/tests/free-space-tests.c:345:
> +    ret = test_add_free_space_entry(cache, 1 * 1024 * 1024, 2 * 1024 *
> 1024, 1);
> 
> WARNING: line over 80 characters
> #1022: FILE: fs/btrfs/tests/free-space-tests.c:351:
> +    ret = test_add_free_space_entry(cache, 3 * 1024 * 1024, 1 * 1024 *
> 1024, 0);
> 
> WARNING: line over 80 characters
> #1030: FILE: fs/btrfs/tests/free-space-tests.c:359:
> +        test_msg("Error removing bitmap and extent overlapping %d\n", ret);
>

Yeah I skipped the 80 char limit in here to make the tests a little easier to
read.  Thanks,

Josef 
