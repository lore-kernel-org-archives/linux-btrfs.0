Return-Path: <SRS0=BvJc=RS=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 230BCC43381
	for <linux-btrfs@archiver.kernel.org>; Fri, 15 Mar 2019 21:42:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EBC71218A1
	for <linux-btrfs@archiver.kernel.org>; Fri, 15 Mar 2019 21:42:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726314AbfCOVmJ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 15 Mar 2019 17:42:09 -0400
Received: from mx2.suse.de ([195.135.220.15]:59200 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725959AbfCOVmI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 15 Mar 2019 17:42:08 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 9A8E8AEE1;
        Fri, 15 Mar 2019 21:42:07 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 799ECDACEC; Fri, 15 Mar 2019 22:43:24 +0100 (CET)
Date:   Fri, 15 Mar 2019 22:43:24 +0100
From:   David Sterba <dsterba@suse.cz>
To:     kbuild test robot <lkp@intel.com>
Cc:     kbuild-all@01.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 4/9] btrfs: use assertion helpers for spinning readers
Message-ID: <20190315214324.GD3516@suse.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, kbuild test robot <lkp@intel.com>,
        kbuild-all@01.org, linux-btrfs@vger.kernel.org
References: <a76a27b87096042c0ad2d5ab2e05b586dd2f0e58.1552489554.git.dsterba@suse.com>
 <201903160031.tA3xYCpn%lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201903160031.tA3xYCpn%lkp@intel.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sat, Mar 16, 2019 at 12:18:30AM +0800, kbuild test robot wrote:
> Hi David,
> 
> I love your patch! Yet something to improve:
> 
> [auto build test ERROR on kdave/for-next]
> [also build test ERROR on next-20190306]
> [cannot apply to v5.0]
> [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
> 
> url:    https://github.com/0day-ci/linux/commits/David-Sterba/Extent-buffer-locking-cleanups/20190315-231346
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-next
> config: i386-randconfig-x011-201910 (attached as .config)
> compiler: gcc-7 (Debian 7.3.0-1) 7.3.0
> reproduce:
>         # save the attached .config to linux build tree
>         make ARCH=i386 
> 
> All errors (new ones prefixed by >>):
> 
>    fs/btrfs/locking.c: In function 'btrfs_clear_lock_blocking_read':
> >> fs/btrfs/locking.c:97:18: error: 'struct extent_buffer' has no member named 'spinning_readers'; did you mean 'blocking_readers'?
>      atomic_inc(&eb->spinning_readers);
>                      ^~~~~~~~~~~~~~~~
>                      blocking_readers
> 
> vim +97 fs/btrfs/locking.c
> 
> b4ce94de Chris Mason  2009-02-04   85  
> aa12c027 David Sterba 2018-04-04   86  void btrfs_clear_lock_blocking_read(struct extent_buffer *eb)
> aa12c027 David Sterba 2018-04-04   87  {
> b4ce94de Chris Mason  2009-02-04   88  	/*
> aa12c027 David Sterba 2018-04-04   89  	 * No lock is required.  The lock owner may change if we have a read
> aa12c027 David Sterba 2018-04-04   90  	 * lock, but it won't change to or away from us.  If we have the write
> aa12c027 David Sterba 2018-04-04   91  	 * lock, we are the owner and it'll never change.
> b4ce94de Chris Mason  2009-02-04   92  	 */
> aa12c027 David Sterba 2018-04-04   93  	if (eb->lock_nested && current->pid == eb->lock_owner)
> aa12c027 David Sterba 2018-04-04   94  		return;
> aa12c027 David Sterba 2018-04-04   95  	BUG_ON(atomic_read(&eb->blocking_readers) == 0);
> aa12c027 David Sterba 2018-04-04   96  	read_lock(&eb->lock);
> aa12c027 David Sterba 2018-04-04  @97  	atomic_inc(&eb->spinning_readers);

Thanks for the report.  There's the right code in my branch that
compiles (and also got tested), with and without the config option, so I
must have sent branch with the uncommited fixup.
