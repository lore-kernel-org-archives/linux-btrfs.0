Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:23420 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753317AbaEHKFo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 May 2014 06:05:44 -0400
Date: Thu, 8 May 2014 18:05:29 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: David Disseldorp <ddiss@suse.de>
Cc: xfs@oss.sgi.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs/035: update clone test to expect EOPNOTSUPP
Message-ID: <20140508100528.GD3407@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1399465998-26545-1-git-send-email-ddiss@suse.de>
 <20140508041123.GB3407@localhost.localdomain>
 <20140508110522.21930dfd@f163.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140508110522.21930dfd@f163.suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 08, 2014 at 11:05:22AM +0200, David Disseldorp wrote:
> Hi liubo,
> 
> On Thu, 8 May 2014 12:11:24 +0800, Liu Bo wrote:
> 
> > Something different here, I didn't get EIO on 3.15.0-rc4.
> 
> Strange, I'm able to consistently reproduce this on a
> vanilla v3.15-rc4-202-g30321c7 kernel.
> Does that mean the updated test passes successfully for you?

(yeah I've reproduce that error as well)

The interesting thing is that if you do a _scratch_remount before
'cat $SCRATCH_MNT/src', it goes well, I'm looking into why...

-liubo
