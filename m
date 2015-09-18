Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:35197 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753271AbbIRS2G (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 Sep 2015 14:28:06 -0400
Received: by pacfv12 with SMTP id fv12so58412307pac.2
        for <linux-btrfs@vger.kernel.org>; Fri, 18 Sep 2015 11:28:06 -0700 (PDT)
Date: Fri, 18 Sep 2015 11:28:04 -0700
From: Omar Sandoval <osandov@osandov.com>
To: Josef Bacik <jbacik@fb.com>
Cc: Holger =?iso-8859-1?Q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH V2] Btrfs: keep dropped roots in cache until transaction
 commit
Message-ID: <20150918182804.GB7341@mew>
References: <1442326024-2536-1-git-send-email-jbacik@fb.com>
 <55F83E34.3090900@googlemail.com>
 <55F86CB1.5020503@googlemail.com>
 <55F86E63.8050300@fb.com>
 <55F92F20.2040603@googlemail.com>
 <55F97399.7000407@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <55F97399.7000407@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 16, 2015 at 09:50:17AM -0400, Josef Bacik wrote:
> On 09/16/2015 04:58 AM, Holger Hoffstätte wrote:
> >On 09/15/15 21:15, Josef Bacik wrote:
> >>On 09/15/2015 03:08 PM, Holger Hoffstätte wrote:
> >>>On 09/15/15 17:50, Holger Hoffstätte wrote:
> >>>>This V2 does indeed seem to fix the issues I reported with snapshot
> >>>>deletion & concurrent sync. I've now created/filled/deleted countless
> >>>>snapshots while issuing sync(s) in parallel, and the problem that I
> >>>>saw fairly frequently with V1 no longer seems to occur here.
> >>>
> >>>Well..I may have spoken too soon:
> >>
> >>Huh this doesn't seem related to my stuff.  Can I have your script
> >>you are running to reproduce this?  Thanks,
> >>
> >>Josef
> >
> >It seemed to be related to Omar's free-space-tree - I saw the same bug
> >a bit later on a different device without snapshot deletion, just
> >deleting two large files. Sorry for the false positive.
> >
> 
> Omar, do you have time to look into this?  Were they highly fragmented files
> or just giant contiguous files?  Thanks,
> 
> Josef
> 

Yeah, I'll take a look over the weekend or next week at the latest.

-- 
Omar
