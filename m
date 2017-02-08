Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:57787 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750974AbdBHXxE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 8 Feb 2017 18:53:04 -0500
Date: Wed, 8 Feb 2017 18:51:25 -0500
From: Chris Mason <clm@fb.com>
To: David Sterba <dsterba@suse.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PULL] Fix ioctls on 32bit/64bit userspace/kernel, for 4.10
Message-ID: <20170208235130.GA97173@clm-mbp.thefacebook.com>
References: <cover.1486571660.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
In-Reply-To: <cover.1486571660.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 08, 2017 at 05:51:28PM +0100, David Sterba wrote:
>Hi,
>
>could you please merge this single-patch pull request, for 4.10 still?  There
>are quite a few patches on top of v4.10-rc7 so this IMHO does not look like
>look too bad even late in the release cycle. Though it's a fix for an uncommon
>usecase of 32bit userspace on 64bit kernel, it fixes basically operation of the
>ioctls. Thanks.

Hi Dave, I'll pull this in and it, thanks.

-chris
