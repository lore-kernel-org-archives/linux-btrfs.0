Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36939 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751077AbbJAQSR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 1 Oct 2015 12:18:17 -0400
Date: Thu, 1 Oct 2015 18:17:14 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org, clm@fb.com
Subject: Re: [PATCH 00/23] btrfs device related patch set
Message-ID: <20151001161713.GG5885@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1439548388-29686-1-git-send-email-anand.jain@oracle.com>
 <20150929143406.GD11442@twin.jikos.cz>
 <560B0C6D.4050100@oracle.com>
 <20150930150516.GH11442@suse.cz>
 <20151001144256.GF5885@twin.jikos.cz>
 <560D4A97.9020705@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <560D4A97.9020705@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 01, 2015 at 11:00:39PM +0800, Anand Jain wrote:
>   Its been challenging to realign the patch sequence at my end as well, 
> I am trying. I think it will take a bit longer than expected.

I'd suggest to send several small patchsets instead of one of such size.
A big patchset makes sense if all the patches are logically related so
there's not a limit on the number.

I've picked patches 11, 13, 14, 17, 19, 20 and 22, and made some minor
changes. I'll do some testing here before I ask Chris to pull the
updated branch.
