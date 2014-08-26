Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:38994 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757998AbaHZNCk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Aug 2014 09:02:40 -0400
Message-ID: <53FC855F.2060904@fb.com>
Date: Tue, 26 Aug 2014 09:02:23 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Martin Steigerwald <Martin@lichtvoll.de>
CC: Liu Bo <bo.li.liu@oracle.com>, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v3] Btrfs: fix task hang under heavy compressed write
References: <1407829499-21902-1-git-send-email-bo.li.liu@oracle.com> <1408117013-305-1-git-send-email-bo.li.liu@oracle.com> <53FB4F05.6050801@fb.com> <5413015.p5ELBzGdTR@merkaba>
In-Reply-To: <5413015.p5ELBzGdTR@merkaba>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 08/26/2014 06:20 AM, Martin Steigerwald wrote:
> Am Montag, 25. August 2014, 10:58:13 schrieb Chris Mason:
>> On 08/15/2014 11:36 AM, Liu Bo wrote:
>>> This has been reported and discussed for a long time, and this hang occurs
>>> in both 3.15 and 3.16.
>>
>> [ great description ]
>>
>> I ran this through tests last week, and an overnight test over the
>> weekend.  It's in my for-linus branch now, along with everything else I
>> plan on sending for rc3.
>>
>> Please double check my merge, I had to undo your rebase onto Miao's patches.
> 
> I would like to test this on 3.17-rc2, what do I need to do to make it apply 
> cleanly? That function in disk-io.c looks quite different from what the patch 
> assumes at the beginning, so I am not sure how to merge this.

You can just pull my for-linus branch, Liu Bo's fix is on top.

-chris
