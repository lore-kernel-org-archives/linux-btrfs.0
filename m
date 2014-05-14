Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fw7a-shanna.wadns.net ([196.220.39.217]:50460 "EHLO
	fw7a.wadns.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751070AbaENMZo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 May 2014 08:25:44 -0400
Message-ID: <537360B2.50107@swiftspirit.co.za>
Date: Wed, 14 May 2014 14:25:22 +0200
From: Brendan Hide <brendan@swiftspirit.co.za>
MIME-Version: 1.0
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>,
        Eric Sandeen <sandeen@redhat.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>, jshubin@redhat.com
Subject: Re: [PATCH] mkfs.btrfs: allow UUID specification at mkfs time
References: <5372C457.3000706@redhat.com> <53731BE3.5010604@cn.fujitsu.com>
In-Reply-To: <53731BE3.5010604@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 14/05/14 09:31, Wang Shilong wrote:
> On 05/14/2014 09:18 AM, Eric Sandeen wrote:
>> Allow the specification of the filesystem UUID at mkfs time.
>>
>> (Implemented only for mkfs.btrfs, not btrfs-convert).
> Just out of curiosity, this option is used for what kind of use case?
> I notice Ext4 also has this option.:-)
Personally I can't think of any "average" or "normal" use case. The 
simplest case however is in using predictable/predetermined UUIDs.

Certain things, such as testing or perhaps even large-scale automation, 
are likely simpler to implement with a predictable UUID.

-- 
__________
Brendan Hide
http://swiftspirit.co.za/
http://www.webafrica.co.za/?AFF1E97

