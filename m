Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:52278 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750776AbbEGTc3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 7 May 2015 15:32:29 -0400
Message-ID: <554BBD46.1050309@fb.com>
Date: Thu, 7 May 2015 15:30:14 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: <dsterba@suse.cz>, Filipe Manana <fdmanana@suse.com>,
        <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: fix race when reusing stale extent buffers that
 leads to BUG_ON
References: <1429784928-12665-1-git-send-email-fdmanana@suse.com> <20150507161944.GF23255@twin.jikos.cz>
In-Reply-To: <20150507161944.GF23255@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 05/07/2015 12:19 PM, David Sterba wrote:
> On Thu, Apr 23, 2015 at 11:28:48AM +0100, Filipe Manana wrote:
>> Signed-off-by: Filipe Manana <fdmanana@suse.com>
> 
> Phew, great catch and fix.
> 
> Reviewed-by: David Sterba <dsterba@suse.cz>
> 
> Chis, please try to squeeze it into 4.1-rc.
> 

Yes, I've been giving this one extra soak time, but I'll get it into 4.1

-chris

