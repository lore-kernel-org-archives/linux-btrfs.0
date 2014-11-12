Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f172.google.com ([209.85.192.172]:36265 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753075AbaKLQBP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Nov 2014 11:01:15 -0500
Received: by mail-pd0-f172.google.com with SMTP id r10so12547403pdi.3
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Nov 2014 08:01:14 -0800 (PST)
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 8.0 \(1990.1\))
Subject: Re: Quota question
From: Wang Shilong <wangshilong1991@gmail.com>
In-Reply-To: <928A4C3A-2CE4-48E5-8831-BE6C1685ED8B@free.fr>
Date: Thu, 13 Nov 2014 00:01:01 +0800
Cc: Josef Bacik <jbacik@fb.com>, linux-btrfs <linux-btrfs@vger.kernel.org>
Message-Id: <404E7ECA-23DA-484D-B398-F955BE06839B@gmail.com>
References: <23550138-C487-44E1-AA4A-B3B951D778D1@free.fr> <F924EC8F-D124-4E6D-A8FE-E03D82A8DAB8@free.fr> <pan$db0e5$7ee7229b$da3a292b$c1219b2@cox.net> <CCA13B0E-D1EE-44D8-A634-FD17C2B22C72@free.fr> <pan$648cb$e6ca8d21$192128f6$95e500d3@cox.net> <967D58C4-46E1-4508-A5A9-A0835C18E87D@free.fr> <EE8501C5-2A50-4E93-89F5-C08E28CE71DB@free.fr> <928A4C3A-2CE4-48E5-8831-BE6C1685ED8B@free.fr>
To: Cyril Scetbon <cyril.scetbon@free.fr>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


> Anyone on this ? There is an issue with quotas depending on the write rate. The more we can write before a sync, the more we can exceed quotas limits

Absolutely, this was a regression bug since Josef introduce delay refs merging for qgroup.
Josef, would you please spend some time tracking this problem down?


> -- 
> Cyril SCETBON
> 
>> I did some new tests and the issue with quota exceeded comes from the fact that the data is not sync to disk : http://pastebin.com/fZdh2YRu
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Best Regards,
Wang Shilong

