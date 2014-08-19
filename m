Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:45392 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751878AbaHSTsT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Aug 2014 15:48:19 -0400
Message-ID: <53F3A9F7.9070709@fb.com>
Date: Tue, 19 Aug 2014 15:48:07 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, <linux-btrfs@vger.kernel.org>
CC: David Sterba <dsterba@suse.cz>, Josef Bacik <jbacik@fb.com>
Subject: Re: [PATCH] btrfs: Don't continue mounting when superblock csum mismatches
 even generation is less than 10.
References: <1403599753-4072-1-git-send-email-quwenruo@cn.fujitsu.com> <53E2E9A3.6060206@cn.fujitsu.com>
In-Reply-To: <53E2E9A3.6060206@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 08/06/2014 10:51 PM, Qu Wenruo wrote:
> It seems that the patch is rejected in patchwork,
> 
> Could any one tell me the reason?

I had nack'd it because I was worried at the time about the super crc
errors that Dave had found in the past.  Sorry, I really thought I had
sent email about it.

But Dave has a great point in his reply about validating the super
generation.

-chris
