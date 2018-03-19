Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34131 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751617AbeCSIeN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Mar 2018 04:34:13 -0400
Subject: Re: Kernel warning - not sure if this is important
To: Peter Chant <pete@petezilla.co.uk>, linux-btrfs@vger.kernel.org
References: <398a50db-8ae0-b933-7268-4231e08d615d@petezilla.co.uk>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <bcd412c7-b7c1-a581-ea4b-e00bec6cd909@suse.com>
Date: Mon, 19 Mar 2018 10:34:11 +0200
MIME-Version: 1.0
In-Reply-To: <398a50db-8ae0-b933-7268-4231e08d615d@petezilla.co.uk>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 19.03.2018 10:21, Peter Chant wrote:
> I got this kernel warning overnight.  Possibly during or after a dedup
> using duperemove.  I'm not sure if that is relevent.  Seems to relate to
> fs/btrfs/backref.c line 1266.
> 
> Don't know if it is important.  Thought I'd post it just in case.
> 
> I'm afraid this is a screen-shot in the old fashioned sense:
> https://drive.google.com/file/d/1NelZV2ld9Yqqt8b2y2sg6aAwgevgMy4X/view?usp=sharing

You are hitting a warning that was removed in : c8195a7b1ad5 ("btrfs:
remove spurious WARN_ON(ref->count < 0) in find_parent_nodes")


In short - you can disregard it. However, it's likely you will continue
seeing it in the future unless you update to 4.16 (the commit is not
tagged for stable ))



> 
> Pete
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
