Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40726 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750759AbeFVFsn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 22 Jun 2018 01:48:43 -0400
Subject: Re: unsolvable technical issues?
To: waxhead@dirtcellar.net, linux-btrfs@vger.kernel.org
References: <b255d0fb-5cee-36c5-d49f-5f014d20e518@dirtcellar.net>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <1c1b0945-81b1-ac6f-2f16-2527ca382d9f@suse.com>
Date: Fri, 22 Jun 2018 08:48:41 +0300
MIME-Version: 1.0
In-Reply-To: <b255d0fb-5cee-36c5-d49f-5f014d20e518@dirtcellar.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 22.06.2018 02:13, waxhead wrote:
> According to this:
> 
> https://stratis-storage.github.io/StratisSoftwareDesign.pdf
> Page 4 , section 1.2
> 
> It claims that BTRFS still have significant technical issues that may
> never be resolved.
> Could someone shed some light on exactly what these technical issues
> might be?! What are BTRFS biggest technical problems?

That's a question that needs to be directed at the author of the statement.

> 
> If you forget about the "RAID"5/6 like features then the only annoyances
> that I have with BTRFS so far is...
> 
> 1. Lack of per subvolume "RAID" levels
> 2. Lack of not using the deviceid to re-discover and re-add dropped devices
> 
> And that's about it really...
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
