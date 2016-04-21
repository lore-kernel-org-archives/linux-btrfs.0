Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49787 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751650AbcDUXxu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Apr 2016 19:53:50 -0400
Date: Thu, 21 Apr 2016 16:53:48 -0700
From: Mark Fasheh <mfasheh@suse.de>
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
        Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: Re: [PATCH] btrfs: Test that qgroup counts are valid after snapshot
 creation
Message-ID: <20160421235348.GW2187@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
References: <20160419222530.GU2187@wotan.suse.de>
 <5716D1F6.6010507@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5716D1F6.6010507@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thank you for the review, comments are below.

On Wed, Apr 20, 2016 at 09:48:54AM +0900, Satoru Takeuchi wrote:
> On 2016/04/20 7:25, Mark Fasheh wrote:
> >+# Force a small leaf size to make it easier to blow out our root
> >+# subvolume tree
> >+_scratch_mkfs "--nodesize 16384"
> 
> nodesize 16384 is the default value. Do you
> intend other value, for example 4096?

"future proofing" I suppose - if we up the default, the for loop below may
not create a level 1 tree.

If we force it smaller than 16K I believe that may mean we can't run this
test on some kernels with page size larger than the typical 4k.
	--Mark


--
Mark Fasheh
