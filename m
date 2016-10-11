Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:58928 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752894AbcJKPVP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Oct 2016 11:21:15 -0400
Subject: Re: btrfs bio linked list corruption.
To: Dave Jones <davej@codemonkey.org.uk>, Al Viro <viro@ZenIV.linux.org.uk>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        <linux-btrfs@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
References: <20161011144507.okg6baqvodn2m2lh@codemonkey.org.uk>
 <20161011151139.GD19539@ZenIV.linux.org.uk>
 <20161011151904.qimdy3rra63fri7n@codemonkey.org.uk>
From: Chris Mason <clm@fb.com>
Message-ID: <f8198dfa-defe-e7b2-afb4-3de8478cb743@fb.com>
Date: Tue, 11 Oct 2016 11:20:41 -0400
MIME-Version: 1.0
In-Reply-To: <20161011151904.qimdy3rra63fri7n@codemonkey.org.uk>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 10/11/2016 11:19 AM, Dave Jones wrote:
> On Tue, Oct 11, 2016 at 04:11:39PM +0100, Al Viro wrote:
>  > On Tue, Oct 11, 2016 at 10:45:08AM -0400, Dave Jones wrote:
>  > > This is from Linus' current tree, with Al's iovec fixups on top.
>  >
>  > Those iovec fixups are in the current tree...
>
> ah yeah, git quietly dropped my local copy when I rebased so I didn't notice.
>
>  > TBH, I don't see anything
>  > in splice-related stuff that could come anywhere near that (short of
>  > some general memory corruption having random effects of that sort).
>  >
>  > Could you try to bisect that sucker, or is it too hard to reproduce?
>
> Only hit it the once overnight so far. Will see if I can find a better way to
> reproduce today.

This call trace is reading metadata so we can finish the truncate.  I'd 
say adding more memory pressure would make it happen more often.

I'll try to trigger.

-chris

