Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f169.google.com ([209.85.223.169]:35348 "EHLO
	mail-io0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642AbcGRV2z (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Jul 2016 17:28:55 -0400
Received: by mail-io0-f169.google.com with SMTP id m101so2572732ioi.2
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Jul 2016 14:28:55 -0700 (PDT)
Subject: Re: [PATCH next] Btrfs: fix comparison in __btrfs_map_block()
To: =?UTF-8?Q?Vincent_Stehl=c3=a9?= <vincent.stehle@intel.com>,
        linux-btrfs@vger.kernel.org
References: <1465155145-10812-14-git-send-email-mchristi@redhat.com>
 <1468595001-4270-1-git-send-email-vincent.stehle@intel.com>
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com,
        Mike Christie <mchristi@redhat.com>, Jens Axboe <axboe@fb.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <17530fad-226a-77e7-ff76-3fca3b1ffc97@kernel.dk>
Date: Mon, 18 Jul 2016 15:28:52 -0600
MIME-Version: 1.0
In-Reply-To: <1468595001-4270-1-git-send-email-vincent.stehle@intel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/15/2016 09:03 AM, Vincent Stehlé wrote:
> Add missing comparison to op in expression, which was forgotten when doing
> the REQ_OP transition.

Thanks, added to the 4.8 branch.

-- 
Jens Axboe

