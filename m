Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:37148 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754110AbaGBAgo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Jul 2014 20:36:44 -0400
Message-ID: <53B3540D.3070401@jp.fujitsu.com>
Date: Wed, 2 Jul 2014 09:36:29 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: <dsterba@suse.cz>, Fabian Frederick <fabf@skynet.be>,
        <linux-kernel@vger.kernel.org>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 1/1] FS/BTRFS: replace count*size kzalloc by kcalloc
References: <1403721343-19383-1-git-send-email-fabf@skynet.be> <20140702000121.GW1553@twin.jikos.cz>
In-Reply-To: <20140702000121.GW1553@twin.jikos.cz>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

(2014/07/02 9:01), David Sterba wrote:
> On Wed, Jun 25, 2014 at 08:35:43PM +0200, Fabian Frederick wrote:
>> kcalloc manages count*sizeof overflow.
>>
>> Cc: Chris Mason <clm@fb.com>
>> Cc: Josef Bacik <jbacik@fb.com>
>> Cc: linux-btrfs@vger.kernel.org
>> Signed-off-by: Fabian Frederick <fabf@skynet.be>
>
> Reviewed-by: David Sterba <dsterba@suse.cz>

Reviewed-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

