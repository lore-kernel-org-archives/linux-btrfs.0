Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:52141 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750779AbcEaUvi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 31 May 2016 16:51:38 -0400
Date: Tue, 31 May 2016 16:51:03 -0400
From: Chris Mason <clm@fb.com>
To: Jeff Mahoney <jeffm@suse.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>, David Sterba <DSterba@suse.com>
Subject: Re: [RFC] strace patches for new ioctls
Message-ID: <20160531205103.ueklsith275g7oau@floor.thefacebook.com>
References: <4a3270c7-8023-6d2c-3ab0-ffc699feb94f@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4a3270c7-8023-6d2c-3ab0-ffc699feb94f@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 31, 2016 at 04:41:55PM -0400, Jeff Mahoney wrote:
> Hi all -
> 
> Strace 4.12 was tagged for release today and it supports decoding of
> btrfs ioctls.  I'd like to propose a requirement that future ioctl
> additions come with a patch to strace as well so we don't get out of sync.
> 
> I wrote the decoding to help with some issues some of our developers
> were seeing while writing various tools.  Rather than describing their
> workload or showing us the code, an strace in verbose mode shows us
> pretty much exactly what they're doing.
> 
> Opinions?

Maybe add a link to the wiki of your last set of patches to use as a
template?  It's a great idea.

-chris

