Return-Path: <SRS0=hyUm=SC=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77D81C43381
	for <linux-btrfs@archiver.kernel.org>; Sun, 31 Mar 2019 18:44:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 537C92085A
	for <linux-btrfs@archiver.kernel.org>; Sun, 31 Mar 2019 18:44:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731387AbfCaSo4 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 31 Mar 2019 14:44:56 -0400
Received: from ip5f5867e1.dynamic.kabel-deutschland.de ([95.88.103.225]:32780
        "EHLO www.avgustinov.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731353AbfCaSoz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 31 Mar 2019 14:44:55 -0400
Received: from [192.168.178.50] (unknown [192.168.178.50])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by www.avgustinov.eu (Postfix) with ESMTPSA id 54121386371B;
        Sun, 31 Mar 2019 20:44:56 +0200 (CEST)
Subject: interest in post-mortem examination of a BTRFS system and improving
 the btrfs-code?
References: <aa81a49a-d5ca-0f1c-fa75-9ed3656cff55@avgustinov.eu>
To:     linux-btrfs@vger.kernel.org
From:   btrfs@avgustinov.eu
X-Forwarded-Message-Id: <aa81a49a-d5ca-0f1c-fa75-9ed3656cff55@avgustinov.eu>
Message-ID: <a6cb572c-c015-1e19-7489-c59fd1384509@avgustinov.eu>
Date:   Sun, 31 Mar 2019 20:44:46 +0200
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <aa81a49a-d5ca-0f1c-fa75-9ed3656cff55@avgustinov.eu>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: de-DE-1901
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Dear all,


I am a big fan of btrfs, and I am using it since 2013 - in the meantime 
on at least four different computers. During this time, I suffered at 
least four bad btrfs-failures leading to unmountable, unreadable and 
unrecoverable file system. Since in three of the cases I did not manage 
to recover even a single file, I am beginning to lose my confidence in 
btrfs: for 35-years working with different computers no other file 
system was so bad at recovering files!

Considering the importance of btrfs and keeping in mind the number of 
similar failures, described in countless forums on the net, I have got 
an idea: to donate my last two damaged filesystems for investigation 
purposes and thus hopefully contribute to the improvement of btrfs. One 
condition: any recovered personal data (mostly pictures and audio files) 
should remain undisclosed and be deleted.

Should anybody be interested in this - feel free to contact me 
personally (I am not reading the list regularly!), otherwise I am going 
to reformat and reuse both systems in two weeks from today.

Some more info:

   - The smaller system is 83.6GB, I could either send you an image of 
this system on an unneeded hard drive or put it into a dedicated 
computer and give you root rights and ssh-access to it (the network lin 
is 100Mb down, 50Mb up, so it should be acceptable).

   - The used space on the other file system is about 3 TB (4 TB 
capacity) and it is distributed among 5 drives, so I can only offer 
remote access to this, but I will need time to organize it.

If you need additional information - please ask, but keep in mind that I 
have almost no "free time" and the answer could need a day or two.

Kind regards,

Nik.

--


