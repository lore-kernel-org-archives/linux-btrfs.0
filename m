Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37479 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755723AbbHFMbg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 6 Aug 2015 08:31:36 -0400
Date: Thu, 6 Aug 2015 14:31:14 +0200
From: David Sterba <dsterba@suse.com>
To: Anand Jain <anand.jain@oracle.com>
Cc: dsterba@suse.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/6] sysfs-part2 Add seed device representation on the
 sysfs
Message-ID: <20150806123114.GJ31669@suse.cz>
Reply-To: dsterba@suse.com
References: <1436340774-10909-1-git-send-email-anand.jain@oracle.com>
 <20150805172908.GI31669@twin.jikos.cz>
 <55C28554.708@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <55C28554.708@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 06, 2015 at 05:51:16AM +0800, Anand Jain wrote:
...
>   these can go in.
> 
> >>    Btrfs: sysfs: support seed devices in the sysfs layout
> >
> > Sorry for late reply, the patches look good. I'm going to prepare a
> > branch for pull into 4.3. Thanks.
> 
> I suggested if this can wait.
> on the 2nd thought, I am preparing to conduct a survey to know most 
> preferred sysfs layout for btrfs.
>   mainly between
>   one, less invasive overlays on the existing layout (current method).
>   the other, separates FS and Volume attributes (old method).
> 
>   sorry that I am going back a bit, but i think its worth as these API 
> are forever.

Understood.
