Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:54246 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751139AbaBNBhF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Feb 2014 20:37:05 -0500
Message-ID: <52FD73DB.8020305@fb.com>
Date: Thu, 13 Feb 2014 20:39:39 -0500
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        <linux-btrfs@vger.kernel.org>
CC: Anand Jain <Anand.Jain@oracle.com>
Subject: Re: [RFC PATCH] btrfs: fix null pointer deference at btrfs_sysfs_add_one+0x105
References: <1389777748-4341-1-git-send-email-Anand.Jain@oracle.com> <52FD726B.2080503@jp.fujitsu.com>
In-Reply-To: <52FD726B.2080503@jp.fujitsu.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02/13/2014 08:33 PM, Hidetoshi Seto wrote:
> I still see this trouble on v3.14-rc2.
> I confirmed that we cannot do mount with -o degraded without
> this patch. Could you pick this up, Chris?
> 

Thanks for catching this, it'll be in the next pull.

-chris
