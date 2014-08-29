Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:5584 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753774AbaH2Py0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Aug 2014 11:54:26 -0400
Message-ID: <5400A214.4010601@fb.com>
Date: Fri, 29 Aug 2014 11:53:56 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>, Filipe Manana <fdmanana@suse.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: fix crash while a ranged msync() is ongoing
References: <1409315868-29734-1-git-send-email-fdmanana@suse.com> <20140829145130.GA14038@infradead.org>
In-Reply-To: <20140829145130.GA14038@infradead.org>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 08/29/2014 10:51 AM, Christoph Hellwig wrote:
> On Fri, Aug 29, 2014 at 01:37:48PM +0100, Filipe Manana wrote:
>> After the commit 7fc34a62ca4434a79c68e23e70ed26111b7a4cf8 (titled
>> "mm/msync.c: sync only the requested range in msync()"), our fsync
>> callback can be called with a range that covers only part of the
>> file and not the whole file anymore.
> 
> Not that there have been other users of range fsyncs around for a long
> time.  The SCSI target code is one, the NFS server another, and last but
> not least generic_write_sync() which is used by most filesystems
> including btrfs to implement O_SYNC writes.

Yeah, this patch is going in, thanks Filipe.

-chris

