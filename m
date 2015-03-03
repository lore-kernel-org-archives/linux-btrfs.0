Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:4112 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755043AbbCCPYM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 3 Mar 2015 10:24:12 -0500
Date: Tue, 3 Mar 2015 10:23:56 -0500
From: Chris Mason <clm@fb.com>
Subject: Re: [PATCH] Btrfs:__add_inode_ref: out of bounds memory read when
 looking for extended ref.
To: <dsterba@suse.cz>
CC: Quentin Casasnovas <quentin.casasnovas@oracle.com>,
        Mark Fasheh <mfasheh@suse.de>, lkml <linux-kernel@vger.kernel.org>,
        <linux-btrfs@vger.kernel.org>
Message-ID: <1425396236.29552.2@mail.thefacebook.com>
In-Reply-To: <20150303143817.GO8720@twin.jikos.cz>
References: <1424966437-29795-1-git-send-email-quentin.casasnovas@oracle.com>
	<20150303143817.GO8720@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On Tue, Mar 3, 2015 at 9:38 AM, David Sterba <dsterba@suse.cz> wrote:
> Adding linux-btrfs to CC
> 
> On Thu, Feb 26, 2015 at 05:00:37PM +0100, Quentin Casasnovas wrote:
>>  Improper arithmetics when calculting the address of the extended 
>> ref could
>>  lead to an out of bounds memory read and kernel panic.
>> 
>>  Signed-off-by: Quentin Casasnovas <quentin.casasnovas@oracle.com>
> 
> Good catch.

Thanks Quentin, can you please bounce the patch to linux-btrfs so it'll 
be in patchwork?

-chris



