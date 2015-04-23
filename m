Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:24574 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030274AbbDWR5e (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Apr 2015 13:57:34 -0400
Message-ID: <55393289.2040104@fb.com>
Date: Thu, 23 Apr 2015 13:57:29 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: =?UTF-8?B?SG9sZ2VyIEhvZmZzdMOkdHRl?=
	<holger.hoffstaette@googlemail.com>,
        <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 0/4] btrfs: reduce block group cache writeout times during
 commit
References: <1428954759-1304912-1-git-send-email-clm@fb.com>	<mh8h3f$l3u$1@ger.gmane.org> <pan.2015.04.22.16.37.38@googlemail.com>	<5537D27E.3080609@fb.com> <pan.2015.04.23.16.34.05@googlemail.com>
In-Reply-To: <pan.2015.04.23.16.34.05@googlemail.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04/23/2015 12:34 PM, Holger Hoffstätte wrote:
> kmem_cache_destroy btrfs_transaction: Slab cache still has objects

Josef has a fix for this, but the fix was causing other problems.  It's
not a new bug, but we'll get it fixed up.

-chris

