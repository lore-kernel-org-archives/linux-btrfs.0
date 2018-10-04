Return-Path: <SRS0=cN6C=MQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3175CC64EBC
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Oct 2018 19:01:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F280E20877
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Oct 2018 19:01:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=osandov-com.20150623.gappssmtp.com header.i=@osandov-com.20150623.gappssmtp.com header.b="xVIf/Zug"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F280E20877
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=osandov.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727499AbeJEB4Z (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 4 Oct 2018 21:56:25 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:37657 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727354AbeJEB4Z (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 Oct 2018 21:56:25 -0400
Received: by mail-pg1-f193.google.com with SMTP id c10-v6so3579629pgq.4
        for <linux-btrfs@vger.kernel.org>; Thu, 04 Oct 2018 12:01:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=++2i9fT3K2n9k7MjnjwcyFOfUxmMvwuwGyn5kW1X7TA=;
        b=xVIf/ZuglR+Qa98QI8v+yUBwPWae70fEkXYlRCt34R6sAjCRV9pKAgWBustjJlPsGc
         mRa9zXxGmpEScO050I3IgPyITt6mnVqbhVujKiXwzs3h1GibHOhSmXuoshvcj19K4JDv
         Kbfw6HuRWfeNtsybxXYp9hLZVHXMafF4q/BfgglYTzXIqjDaK/dPooJfSuInYcqnc89E
         8kHFVfnV7OuNyksHTOzDduUK5Kfc+6ALWsOlmIuBPhnLCLyYx9ZTYZ0HkLBgQCiXc2cQ
         rPbGyIEhCh6D7U3gFrUH6bLE+pSZRhmyvnnD2Q8QHD8nAlw//83ffjdb/vVKx04a6VTZ
         6lLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=++2i9fT3K2n9k7MjnjwcyFOfUxmMvwuwGyn5kW1X7TA=;
        b=omtNo8sKL31kaPyI50jHqFDH8G5MK8nVaFYPVv0WRvcpY+Dm/PSSvX1CrudncHj92P
         3RqBR/0TjG5UXVg1wcdT0oAd8JlSIBnh1IBfMKxGrAbGQkpxklCVNYylwrQNa7MSydme
         5q8z89mI8cf+jWE0HJs/WrPmv+K+GoS/zevEa8PJnkY1mGCMqDVy8nIRL+WLCLZbpPnO
         KjG73VMkBLkz7OPoO+n+ccq5So2j3LJ5/f0yldevWTXxCSESbrZdrjlCmnocoXZc5U66
         G+uz66lVjSlMKCcS8QjRDGwFW+kncFquAqBs+RLg54cyUmvDEDYxbvk7SrJdTTSGM+Am
         j5/A==
X-Gm-Message-State: ABuFfoi2TXRMzxqK7ZWIi1EspSDFvJqTjDkwDlMcKQUEStdv8GuYu1kQ
        ik8iu85ZNOfsjicI4SEkUXBvcw==
X-Google-Smtp-Source: ACcGV615hU08PjU6UA+O5EOXl2mSoAZNBmSmpKbDQvh+jYQgmac2JcBczCeAZs3QMNQRj3u6tQjbBA==
X-Received: by 2002:a63:5747:: with SMTP id h7-v6mr6917709pgm.423.1538679709220;
        Thu, 04 Oct 2018 12:01:49 -0700 (PDT)
Received: from vader ([2620:10d:c090:200::7:7e9a])
        by smtp.gmail.com with ESMTPSA id f1-v6sm7763271pgc.4.2018.10.04.12.01.48
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 04 Oct 2018 12:01:48 -0700 (PDT)
Date:   Thu, 4 Oct 2018 12:01:48 -0700
From:   Omar Sandoval <osandov@osandov.com>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 05/10] btrfs-progs: Pull free space tree related code
 from kernel
Message-ID: <20181004190148.GG25437@vader>
References: <1538405181-25231-1-git-send-email-nborisov@suse.com>
 <1538405181-25231-6-git-send-email-nborisov@suse.com>
 <20181004182636.GE25437@vader>
 <33367247-9a7b-bbfa-66c7-1404f6db656a@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <33367247-9a7b-bbfa-66c7-1404f6db656a@suse.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Oct 04, 2018 at 09:34:01PM +0300, Nikolay Borisov wrote:
> 
> 
> On  4.10.2018 21:26, Omar Sandoval wrote:
> > On Mon, Oct 01, 2018 at 05:46:16PM +0300, Nikolay Borisov wrote:
> >> To help implement free space tree checker in user space some kernel
> >> function are necessary, namely iterating/deleting/adding freespace
> >> items, some internal search functions. Functions to populate a block
> >> group based on the extent tree. The code is largely copy/paste from
> >> the kernel with locking eliminated (i.e free_space_lock). It supports
> >> reading/writing of both bitmap and extent based FST trees.
> > 
> > For some reason, a lot of this added code uses spaces instead of tabs,
> > so I had to fix that in order to compare it to the kernel code (some of
> > the functions were reordered, too).
> > 
> > The only functional difference I noticed was that this is missing the
> > code to insert the block group header in the free space tree:
> > 
> > 	if (block_group->needs_free_space) {
> > 		ret = __add_block_group_free_space(trans, block_group, path);
> > 		if (ret)
> > 			return ret;
> > 	}
> > 
> > Was that intentionally omitted? Without it, the free space tree is
> > pretty broken :(
> 
> Yes, it was intentional. If you remember I even emailed you about this
> particular piece of code and you said you needed to have it this way in
> case delayed refs were run before the space tree was initialized.
> 
> In user space AFAIK we don't have that problem since
> add_new_free_space_info/__add_to_free_space_tree is called via
> 
> btrfs_Create_free_space_tree
>    populate_free_space_tree
>      add_new_free_space_info
>      __add_to_free_space_tree

Ah, will progs never allocate a new block group? If so, then you're
right, this is fine.
