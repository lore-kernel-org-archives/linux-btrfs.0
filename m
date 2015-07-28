Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:18831 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752654AbbG1RmH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 28 Jul 2015 13:42:07 -0400
Date: Tue, 28 Jul 2015 10:41:39 -0700
From: Omar Sandoval <osandov@fb.com>
To: <dsterba@suse.com>, Brendan Hide <brendan@swiftspirit.co.za>,
        Wang Yanfeng <wangyf-fnst@cn.fujitsu.com>, <fstests@vger.kernel.org>,
        <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 2/3] btrfs: add replace missing and replace RAID 5/6 to
 profile configs
Message-ID: <20150728174120.GA19835@huxley.DHCP.TheFacebook.com>
References: <cover.1437683940.git.osandov@fb.com>
 <6d332e954da29e8418689cb49294a68da2fa5376.1437683940.git.osandov@fb.com>
 <20150724120946.GT6306@twin.jikos.cz>
 <20150724175043.GA14974@huxley.DHCP.TheFacebook.com>
 <55B6AF40.5040107@swiftspirit.co.za>
 <20150728165207.GK6306@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20150728165207.GK6306@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 28, 2015 at 06:52:07PM +0200, David Sterba wrote:
> On Tue, Jul 28, 2015 at 12:22:56AM +0200, Brendan Hide wrote:
> > > It does not, I apparently forgot that you could use single to 
> > > concatenate multiple devices. I'll fix that in v2.
> > > 
> > > Thanks for reviewing!
> > > 
> > Late to the party. DUP *implies* single device but there are cases
> > where dup is used on a multi-device fs. Even if the use-cases aren't
> > good or intended to be long-term, they are still valid, right?
> 
> You're right, DUP is reported by 'fi df' after 2nd device is added and
> this state (even if it's temporary) has to be taken into account.

I wouldn't read too much into this, _btrfs_get_profile_configs is just
for tests that mkfs a bunch of new filesystems for testing, and in that
case, DUP is invalid for multiple devices. It's not meant to be an
authoritative source of truth regarding what metadata/data profiles
could be legal.

Thanks,
-- 
Omar
