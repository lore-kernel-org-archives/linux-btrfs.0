Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57903 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750844AbbJAOn5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 1 Oct 2015 10:43:57 -0400
Date: Thu, 1 Oct 2015 16:42:56 +0200
From: David Sterba <dsterba@suse.cz>
To: dsterba@suse.cz, Anand Jain <anand.jain@oracle.com>,
        linux-btrfs@vger.kernel.org, clm@fb.com
Subject: Re: [PATCH 00/23] btrfs device related patch set
Message-ID: <20151001144256.GF5885@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1439548388-29686-1-git-send-email-anand.jain@oracle.com>
 <20150929143406.GD11442@twin.jikos.cz>
 <560B0C6D.4050100@oracle.com>
 <20150930150516.GH11442@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150930150516.GH11442@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 30, 2015 at 05:05:16PM +0200, David Sterba wrote:
> >    [PATCH 08/23] Btrfs: device delete by devid
> >    [PATCH 23/23] Btrfs: allow -o rw,degraded for single group profile
> 
> In case the two patches are independent on the rest of series, it would
> be better to put them towards the end of the series. I was going down
> the list and stpeed at 08/23 because it introduced something nontrivial
> and then I can't be sure that skipping the single patch would not break
> the whole series.
> 
> > rest are straightforward as well. If there is any comment will take it.
> 
> I'll have another look and will let you know.

There are several patches that I'll add to the branch, some other have
minor issues and the rest seem to depend on the skipped patches. ATM I
can't say what exacly will end up in the branch but you can watch it in
my gits, anand/sysfs-updates-v4.3-rc3. The series is mixing various
patch types and I don't se a better approach.
