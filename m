Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:60846 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755976Ab3IYPJQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Sep 2013 11:09:16 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 82CF27C0431
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Sep 2013 09:09:16 -0600 (MDT)
Date: Wed, 25 Sep 2013 11:08:55 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Chris Murphy <lists@colorremedies.com>
CC: Josef Bacik <jbacik@fusionio.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: balance induced csum errors, systemd-journal
Message-ID: <20130925150855.GF18681@localhost.localdomain>
References: <4CA64610-C709-4805-A9DC-AA8EB0720BBF@colorremedies.com>
 <1810D553-8DB4-4FAA-A305-CF3BE9A85B6F@colorremedies.com>
 <F715552F-A1A0-49BE-B714-C5DF6B7D8AB6@colorremedies.com>
 <795CFB34-4216-4ACA-A56D-5F673B2FD45E@colorremedies.com>
 <013CDB89-72B2-4276-BCE9-0177CA90D840@colorremedies.com>
 <20130925123051.GD18681@localhost.localdomain>
 <A6A9156F-0502-4528-80D4-D61F48E4A7DE@colorremedies.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
In-Reply-To: <A6A9156F-0502-4528-80D4-D61F48E4A7DE@colorremedies.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 25, 2013 at 08:56:52AM -0600, Chris Murphy wrote:
> 
> On Sep 25, 2013, at 6:30 AM, Josef Bacik <jbacik@fusionio.com> wrote:
> 
> > 
> > That just disables cow which in turn disables csumming so it is a good solution
> > for you right now and gives me time ti figure out wtf is going on here.
> 
> I think it's preventing the corruption of the journal logs, because I'm also no longer getting messages from systemd saying a log is corrupt. So I don't think the problem is solved just by not having csums. I'm thinking the csums were always correct, it was the data that was corrupting… or both data and csums were wrong.
> 
> It seems that the way systemd-journal is writing to disk is handled differently only during balance operations. The corruption has never happened with days of normal usage (no balance). But happens within tens of seconds upon balance. Naturally something or other is always being written to the systemd-journal logs during a balance (someone logs in=journal entry, kernel reports extent found=journal entry, kernel reports moved chunk=journal entry).
> 

I've reproduce it locally so I'll hopefully figure out what is going on soon.
Thanks,

Josef
