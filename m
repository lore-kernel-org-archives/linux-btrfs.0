Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52542 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933251AbdKPJnl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 16 Nov 2017 04:43:41 -0500
Subject: Re: Ideas to reuse filesystem's checksum to enhance dm-raid1/10/5/6?
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, Nikolay Borisov <nborisov@suse.com>,
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        linux-fsdevel@vger.kernel.org
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <477d2d2b-3893-50c1-5946-076670a03f2d@gmx.com>
 <7ed134fc-1616-a1ab-6701-a917af0522da@suse.com>
 <5357fd4a-51b1-ebfb-27de-4d022d9749c0@gmx.com>
 <4df8d248-5def-9d29-89eb-7d9b977f089e@suse.com>
 <354402cd-587d-72d8-aaa1-87a1b5c9f03c@gmx.com>
From: Zdenek Kabelac <zkabelac@redhat.com>
Message-ID: <6e0f8a37-c3f8-61f0-d51d-01b72c3c65b7@redhat.com>
Date: Thu, 16 Nov 2017 10:43:37 +0100
MIME-Version: 1.0
In-Reply-To: <354402cd-587d-72d8-aaa1-87a1b5c9f03c@gmx.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dne 16.11.2017 v 09:08 Qu Wenruo napsal(a):
> 
> 
>>>>>>
>>>>> [What we have]
>>>>> The nearest infrastructure I found in kernel is bio_integrity_payload.
>>>>>

Hi

We already have  dm-integrity target upstream.
What's missing in this target ?

Regards

Zdenek


