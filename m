Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:45535 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751630AbeF1FeZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Jun 2018 01:34:25 -0400
Date: Thu, 28 Jun 2018 13:34:20 +0800
From: Eryu Guan <guaneryu@gmail.com>
To: Nikolay Borisov <nborisov@suse.com>
Cc: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH] fstests: btrfs: Test if btrfs will corrupt nodatasum
 compressed extent when replacing device
Message-ID: <20180628053420.GT2780@desktop>
References: <20180601013448.22450-1-wqu@suse.com>
 <b99cbadf-6c03-6bd2-fed5-590a5a8ae840@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <b99cbadf-6c03-6bd2-fed5-590a5a8ae840@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 28, 2018 at 08:11:00AM +0300, Nikolay Borisov wrote:
> 
> 
> On  1.06.2018 04:34, Qu Wenruo wrote:
> > This is a long existing bug (from 2012) but exposed by a reporter
> > recently, that when compressed extent without data csum get written to
> > device-replace target device, the written data is in fact uncompressed data
> > other than the original compressed data.
> > 
> > And since btrfs still consider the data is compressed and will try to read it
> > as compressed, it can cause read error.
> > 
> > The root cause is located, and one RFC patch already sent to fix it,
> > titled "[PATCH RFC] btrfs: scrub: Don't use inode pages for device replace".
> > (The RFC is only for the extra possible way to fix the bug, the fix
> > itself should work without problem)
> > 
> > Reported-by: James Harvey <jamespharvey20@gmail.com>
> > Signed-off-by: Qu Wenruo <wqu@suse.com>
> 
> Reviewed-by: Nikolay Borisov <nborisov@suse.com>

Thanks for the review! I assume the v3 patch also passes your review :)

Eryu
