Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:35258 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753950AbbIHL7X (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Sep 2015 07:59:23 -0400
Received: by wicge5 with SMTP id ge5so113615643wic.0
        for <linux-btrfs@vger.kernel.org>; Tue, 08 Sep 2015 04:59:22 -0700 (PDT)
Received: from [192.168.0.107] (89-212-5-85.static.t-2.net. [89.212.5.85])
        by smtp.googlemail.com with ESMTPSA id h8sm4463770wib.21.2015.09.08.04.59.20
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 08 Sep 2015 04:59:20 -0700 (PDT)
To: linux-btrfs@vger.kernel.org
From: =?UTF-8?Q?Peter_Ke=c5=a1e?= <peter.kese@viidea.com>
Subject: raid6 + hot spare question
Message-ID: <55EECD97.7090109@viidea.com>
Date: Tue, 8 Sep 2015 13:59:19 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


I'm planning to set up a raid6 array with 4 x 4TB drives.
Presumably that would result in 8TB of usable space + parity, which is 
about enough for my data (my data is currently 5TB in raid1, slowly 
growing at about 1 TB per year, but I often keep some additional backups 
if space permits).

However I'd like to be prepared for a disk failure. Because my server is 
not easily accessible and disk replacement times can be long, I'm 
considering the idea of making a 5-drive raid6, thus getting 12TB 
useable space + parity. In this case, the extra 4TB drive would serve as 
some sort of a hot spare.

My assumption is that if one hard drive fails before the volume is more 
than 8TB full, I can just rebalance and resize the volume from 12 TB 
back to 8 TB essentially going from 5-drive raid6 to 4-drive raid6).

Can anyone confirm my assumption? Can I indeed rebalance from 5-drive 
raid6 to 4-drive raid6 if the volume is not too big?

Thanks,
     Peter
