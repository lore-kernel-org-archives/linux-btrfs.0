Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:52081 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754202AbbGXRvp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Jul 2015 13:51:45 -0400
Date: Fri, 24 Jul 2015 10:50:43 -0700
From: Omar Sandoval <osandov@fb.com>
To: <dsterba@suse.com>, <fstests@vger.kernel.org>,
        <linux-btrfs@vger.kernel.org>,
        Wang Yanfeng <wangyf-fnst@cn.fujitsu.com>
Subject: Re: [PATCH 2/3] btrfs: add replace missing and replace RAID 5/6 to
 profile configs
Message-ID: <20150724175043.GA14974@huxley.DHCP.TheFacebook.com>
References: <cover.1437683940.git.osandov@fb.com>
 <6d332e954da29e8418689cb49294a68da2fa5376.1437683940.git.osandov@fb.com>
 <20150724120946.GT6306@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20150724120946.GT6306@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 24, 2015 at 02:09:46PM +0200, David Sterba wrote:
> On Thu, Jul 23, 2015 at 01:51:50PM -0700, Omar Sandoval wrote:
> > +			# We can't do replace with these profiles because they
> > +			# imply only one device ($SCRATCH_DEV), and we need to
> > +			# keep $SCRATCH_DEV around for _scratch_mount
> > +			# and _check_scratch_fs.
> > +			local unsupported=(
> > +				"single"
> > +				"dup"
> 
> DUP does imply single device, but why does 'single' ?

It does not, I apparently forgot that you could use single to
concatenate multiple devices. I'll fix that in v2.

Thanks for reviewing!
-- 
Omar
