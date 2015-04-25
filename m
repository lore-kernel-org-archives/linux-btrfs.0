Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f178.google.com ([209.85.192.178]:32832 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751856AbbDYJjf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 25 Apr 2015 05:39:35 -0400
Received: by pdbnk13 with SMTP id nk13so72759331pdb.0
        for <linux-btrfs@vger.kernel.org>; Sat, 25 Apr 2015 02:39:34 -0700 (PDT)
Date: Sat, 25 Apr 2015 02:39:33 -0700
From: Omar Sandoval <osandov@osandov.com>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs balance start -dconvert=raid5 on raid1 not converting to
 raid5
Message-ID: <20150425093933.GA9617@mew>
References: <20150425030040.GA4756@mew>
 <freemail.20150425055650.78792.2@fmxmldata05.freemail.hu>
 <pan$ef3f8$660eb017$117e7a5d$569a62fd@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <pan$ef3f8$660eb017$117e7a5d$569a62fd@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Apr 25, 2015 at 08:18:30AM +0000, Duncan wrote:
> None None posted on Sat, 25 Apr 2015 05:56:50 +0200 as excerpted:
> 
> > Omar Sandoval <osandov@osandov.com> írta:
> >>On Sat, Apr 25, 2015 at 04:47:31AM +0200, None None wrote:
> >>> I tried to convert my btrfs from raid1 to raid5 but after the balance
> >>> command it&#39;s still raid1.
> >>
> >>This is a known bug in v4.0. I sent in a patch [1] to revert the commit
> >>that caused the regression, but it didn&#39;t get any response. You
> >>could apply that or just revert 2f0810880f08 ("btrfs: delete chunk
> >>allocation attemp when setting block group ro") to fix your problem for
> >>now.
> >>
> >>[1]: https://patchwork.kernel.org/patch/6238111/
> >>
> > I'll give it a try, thanks for the fast reply.
> 
> FWIW, while I've not been following this /too/ closely (as my use-case 
> has zero reason to do a convert), I believe I saw Chris and others 
> discussing the patch, and I /think/ it (or an update) may have actually 
> been in the 4.1 upgrade window pull.
> 
> Presumably they'll queue it for stable too, once it's in 4.1 (or whatever 
> if I'm wrong on the 4.1 pull).
> 
> A verify either way would be useful, but as I said I've not been 
> following it /too/ closely, and I'm still on 4.0 here, so...
> 

Just reproduced the bug on Chris' integration-4.1 branch, which appears
to have everything that was pulled for 4.1-rc1 plus some more. Maybe
you're thinking of the original bisect report [1]? I never saw anything
else come out of that.

[1]: http://thread.gmane.org/gmane.comp.file-systems.btrfs/43117

-- 
Omar
