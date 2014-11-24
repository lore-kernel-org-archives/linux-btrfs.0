Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:64210 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751530AbaKXSBT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Nov 2014 13:01:19 -0500
Date: Mon, 24 Nov 2014 13:01:10 -0500
From: Chris Mason <clm@fb.com>
Subject: Re: [GIT PULL] Btrfs deadlock fix
To: <dsterba@suse.cz>
CC: <torvalds@linux-foundation.org>, <linux-btrfs@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Message-ID: <1416852070.3019.5@mail.thefacebook.com>
In-Reply-To: <20141124173909.GC26471@twin.jikos.cz>
References: <20141123151439.GA16816@ret.masoncoding.com>
	<20141124173909.GC26471@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 24, 2014 at 12:39 PM, David Sterba <dsterba@suse.cz> wrote:
> Hi Chris,
> 
> I thought the fix for the scrub/replace deadlock would be included in
> this pull, I can reproduce it on each run of xfstests with 3.18-rc.
> 
> btrfs: fix dead lock while running replace and defrag concurrently

> https://patchwork.kernel.org/patch/5264531/
> 
> I've retested it again including this pull and still deadlocks 
> reliably
> at btrfs/070.

This wasn't a new problem, so I had it queued for the merge window.

-chris



