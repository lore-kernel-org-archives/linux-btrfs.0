Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:10855 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750819AbaHTPJf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Aug 2014 11:09:35 -0400
Message-ID: <53F4BA21.50705@fb.com>
Date: Wed, 20 Aug 2014 11:09:21 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: David Sterba <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH -rc2] btrfs: remove stale code after removing ordered
 operations
References: <1408546994-4156-1-git-send-email-dsterba@suse.cz>
In-Reply-To: <1408546994-4156-1-git-send-email-dsterba@suse.cz>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 08/20/2014 11:03 AM, David Sterba wrote:
> The commit "btrfs: disable strict file flushes for renames and
> truncates" (8d875f95da43c6a8f18f77869f2ef26e9594fecc) left some unused
> code and defines.

See my followup for the perf regression, we still need these.  I was
never able to trigger the enospc problem with xfstests here, but I did
double check that we're flushing or not properly now.

-chris
