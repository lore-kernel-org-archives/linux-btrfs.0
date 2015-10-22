Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:3054 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750732AbbJVBHW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 21 Oct 2015 21:07:22 -0400
Date: Wed, 21 Oct 2015 21:07:10 -0400
From: Chris Mason <clm@fb.com>
To: <dsterba@suse.cz>, Dan Carpenter <dan.carpenter@oracle.com>,
        <linux-btrfs@vger.kernel.org>, Christian Engelmayer <cengelma@gmx.at>
Subject: Re: btrfs: check unsupported filters in balance arguments
Message-ID: <20151022010710.GB5300@ret.masoncoding.com>
References: <20151021205500.GD9839@mwanda>
 <20151021225237.GJ13624@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20151021225237.GJ13624@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 22, 2015 at 12:52:37AM +0200, David Sterba wrote:
> On Wed, Oct 21, 2015 at 11:55:00PM +0300, Dan Carpenter wrote:
> > Hello David Sterba,
> > 
> > The patch 8eb934591f8b: "btrfs: check unsupported filters in balance
> > arguments" from Oct 12, 2015, leads to the following static checker
> > warning:
> > 
> > 	fs/btrfs/ioctl.c:4673 btrfs_ioctl_balance()
> > 	warn: possible memory leak of 'bctl'
> 
> Thanks for the report, the fix is on the way:
> https://patchwork.kernel.org/patch/7453231/

Thanks, I've picked this up.

-chris
