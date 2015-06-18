Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:62159 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751674AbbFRRRA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Jun 2015 13:17:00 -0400
Message-ID: <5582FD06.2010004@fb.com>
Date: Thu, 18 Jun 2015 10:16:54 -0700
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: <dsterba@suse.cz>, Robert Marklund <robbelibobban@gmail.com>,
        <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] check: check so offset is not bigger then the leaf
References: <1434585553-8697-1-git-send-email-robbelibobban@gmail.com> <20150618164443.GH6761@twin.jikos.cz>
In-Reply-To: <20150618164443.GH6761@twin.jikos.cz>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/18/2015 09:44 AM, David Sterba wrote:
> On Thu, Jun 18, 2015 at 01:59:13AM +0200, Robert Marklund wrote:
>> This could crash before because of dangerous dangling
>> offset of pointer.
>
> That's right, this can happen. There are more btrfs_item_ptr that would
> be good to validate that way, namely in the checker as it's most likely
> to see corrupted data.
>

The check_block stuff should be doing this, if it isn't that's where we 
need to fix it.  Thanks,

Josef

