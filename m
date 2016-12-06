Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58462 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751161AbcLFCwE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 5 Dec 2016 21:52:04 -0500
Subject: Re: [PATCH 1/2] btrfs-progs: Correct value printed by
 assertions/BUG_ON/WARN_ON
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org,
        David Sterba <dsterba@suse.com>
References: <20161129162452.28402-1-rgoldwyn@suse.de>
 <f0beaab1-a09c-cd3e-c00e-2727c3ec8ecd@cn.fujitsu.com>
 <ff3428dc-ee0e-8feb-fa76-1627b4fa411b@suse.de>
 <a5d9ed5f-d8cc-f2ae-52e2-5a4bf4285910@cn.fujitsu.com>
Cc: Goldwyn Rodrigues <rgoldwyn@suse.com>
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Message-ID: <f1fad444-39d0-d79f-0774-491d5f444ed5@suse.de>
Date: Mon, 5 Dec 2016 20:51:58 -0600
MIME-Version: 1.0
In-Reply-To: <a5d9ed5f-d8cc-f2ae-52e2-5a4bf4285910@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 12/05/2016 08:03 PM, Qu Wenruo wrote:
> BTW, the DISABLE_BACKTRACE branch seems quite different from backtrace one.
> 
> #define BUG_ON(c) assert_trace(#c, __FILE__, __func__, __LINE__, (long)(c))
> #define WARN_ON(c) warning_trace(#c, __FILE__, __func__, __LINE__,
> (long)(c))
> #define ASSERT(c) assert_trace(#c, __FILE__, __func__, __LINE__,
> (long)!(c))
> #define BUG() assert_trace(NULL, __FILE__, __func__, __LINE__, 1)
> #else
> #define BUG_ON(c) assert(!(c))
> #define WARN_ON(c) warning_trace(#c, __FILE__, __func__, __LINE__,
> (long)(c))
> #define ASSERT(c) assert(!(c))
> #define BUG() assert(0)
> 
> Condition of BUG_ON/ASSERT/BUG are all logical notted for
> DISABLE_BACKTRACE.
> While WARN_ON() of both branch are the same condition.

WARN_ON is using warning_trace as opposed to assert, and that is the
reason it is not notted.

> 
> This seems quite confusing to me.
> 
> Any idea to make it more straightforward?
> 

I just kept it the same as before. warning_trace was using an extra
variable, trace, which was not needed because the print_trace was
already in ifndefs.

If you are talking about keeping WARN_ON outside of ifndef, yes, that
will reduce the code further by another line.

-- 
Goldwyn
