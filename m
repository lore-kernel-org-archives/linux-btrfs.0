Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50656 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751721Ab3IIOIS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 9 Sep 2013 10:08:18 -0400
Date: Mon, 9 Sep 2013 16:08:15 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <Anand.Jain@oracle.com>
Cc: Wang Shilong <wangshilong1991@gmail.com>, linux-btrfs@vger.kernel.org,
        dsterba@suse.cz, sandeen@redhat.com
Subject: Re: [PATCH 00/20] fix magic return value in btrfs-progs
Message-ID: <20130909140815.GL32382@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1378308157-4621-1-git-send-email-wangshilong1991@gmail.com>
 <5227E8EE.8090007@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5227E8EE.8090007@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Frist, thank you very much for the patches! I'm going to merge all
except 18/20, expecting V2.

On Thu, Sep 05, 2013 at 10:14:06AM +0800, Anand Jain wrote:
> 
> On 09/04/2013 11:22 PM, Wang Shilong wrote:
> >This patchset tries to fix all the magic return value in btrfs-progs.
> >Most commands will have three kinds of return value:
> >
> >0 success
> >1 usage of syntax errors
> >
> >Exceptions come from balance/scrub/replace. For example, replace cancel
> >will return 2 if there is no operations in progress.
> 
>  Thanks for writing this much needed.
>  Its better to have these return error codes defined
>  in a header. So that it would guide the future developments.

I agree. This means to add symbolic names to the scrub returns codes in
20/20, as an example of a command-specific return codes. I haven't found
a good place where to document the generic return values
(0/1/-errno etc). Something suites commands.h, others utils.h. If you
find more appropriate locations, feel free to use them.

david
