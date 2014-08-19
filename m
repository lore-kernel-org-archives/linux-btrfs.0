Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:58751 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751878AbaHSTbK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Aug 2014 15:31:10 -0400
Message-ID: <53F3A5F4.8080405@fb.com>
Date: Tue, 19 Aug 2014 15:31:00 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Liu Bo <bo.li.liu@oracle.com>, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: cleanup the same name in end_bio_extent_readpage
References: <1408462342-2581-1-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1408462342-2581-1-git-send-email-bo.li.liu@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 08/19/2014 11:32 AM, Liu Bo wrote:
> We've defined a 'offset' out of bio_for_each_segment_all.

This isn't causing problems though?  It should just be shadowing the
bio_for_each_segment_all variable for the duration of the curlies.

No objection as a cleanup, just making sure I'm not missing something.

-chris
