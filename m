Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:42832 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932555AbcA0O0Z (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Jan 2016 09:26:25 -0500
Date: Wed, 27 Jan 2016 09:26:19 -0500
From: Chris Mason <clm@fb.com>
To: David Sterba <dsterba@suse.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v2] btrfs: sysfs: check initialization state before
 updating features
Message-ID: <20160127142619.xzueplmn3csq2rax@floor.thefacebook.com>
References: <1453889679-25588-1-git-send-email-dsterba@suse.com>
 <1453899989-1710-1-git-send-email-dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1453899989-1710-1-git-send-email-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 27, 2016 at 02:06:29PM +0100, David Sterba wrote:
> If the mount phase is not finished, we can't update the sysfs files.
> 
> Reported-by: Chris Mason <clm@fb.com>
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
> v2: fix compilation error

Thanks Dave, pushed into integration-4.5

-chris
