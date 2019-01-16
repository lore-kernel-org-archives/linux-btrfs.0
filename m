Return-Path: <SRS0=HC3m=PY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06C2CC43387
	for <linux-btrfs@archiver.kernel.org>; Wed, 16 Jan 2019 18:22:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CD84D206C2
	for <linux-btrfs@archiver.kernel.org>; Wed, 16 Jan 2019 18:22:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728466AbfAPSWV (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 16 Jan 2019 13:22:21 -0500
Received: from wp158.webpack.hosteurope.de ([80.237.132.165]:41868 "EHLO
        wp158.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728454AbfAPSWV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 Jan 2019 13:22:21 -0500
Received: from ip5b41acd8.dynamic.kabel-deutschland.de ([91.65.172.216] helo=[192.168.0.31]); authenticated
        by wp158.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1gjppS-0002Qh-MP; Wed, 16 Jan 2019 19:22:18 +0100
Subject: Re: issue mounting volume
To:     Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        Qu Wenruo <quwenruo.btrfs@gmx.com>
References: <6760df5e-a757-56a0-d8c9-3f172458fc65@ch-sc.de>
 <CAJCQCtS9KC_Vrc0qFsvJRFq5cWgxPi5xx7NMVtGAjn2iqokK+w@mail.gmail.com>
From:   Christian Schneider <christian@ch-sc.de>
Message-ID: <9cb26e7c-e763-0186-40cf-4d8a9c6e6cd9@ch-sc.de>
Date:   Wed, 16 Jan 2019 19:22:19 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <CAJCQCtS9KC_Vrc0qFsvJRFq5cWgxPi5xx7NMVtGAjn2iqokK+w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: de-DE
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;christian@ch-sc.de;1547662940;692a3fd2;
X-HE-SMSGID: 1gjppS-0002Qh-MP
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

THx for your hints!

 > Your problem could be due to a block layer bug that's been discovered.
 > It should be fixed in 4.19.8+
 > https://lwn.net/Articles/774440/
I looked into the article, and it mentiones, that the bug occurs, when 
no IO scheduler is used, which is not the case for me. So, I would rule 
this out.

 > 'btrfs insp dump-t -b 448888832 <dev>'
 >
 > and remove file names before posting it; this might help a dev sort
 > out what the problem is.
Have done this, though no file names appear there. this is the output:


btrfs inspect-internal dump-tree -b 448888832 /dev/md42
btrfs-progs v4.19.1
leaf 448888832 items 29 free space 1298 generation 68768 owner CSUM_TREE
leaf 448888832 flags 0x1(WRITTEN) backref revision 1
fs uuid 8c6746f0-944a-45c5-90f3-622724d15998
chunk uuid 7fdb3778-4545-405e-84a9-fc3675e913e5
         item 0 key (EXTENT_CSUM EXTENT_CSUM 273782669312) itemoff 15787 
itemsize 496
                 range start 273782669312 end 273783177216 length 507904
         item 1 key (EXTENT_CSUM EXTENT_CSUM 273783177216) itemoff 15783 
itemsize 4
                 range start 273783177216 end 273783181312 length 4096
         item 2 key (EXTENT_CSUM EXTENT_CSUM 273783181312) itemoff 15007 
itemsize 776
                 range start 273783181312 end 273783975936 length 794624
         item 3 key (EXTENT_CSUM EXTENT_CSUM 273783975936) itemoff 15003 
itemsize 4
                 range start 273783975936 end 273783980032 length 4096
         item 4 key (EXTENT_CSUM EXTENT_CSUM 273783980032) itemoff 10575 
itemsize 4428
                 range start 273783980032 end 273788514304 length 4534272
         item 5 key (EXTENT_CSUM EXTENT_CSUM 273788514304) itemoff 5599 
itemsize 4976
                 range start 273788514304 end 273793609728 length 5095424
         item 6 key (EXTENT_CSUM EXTENT_CSUM 273793871872) itemoff 5299 
itemsize 300
                 range start 273793871872 end 273794179072 length 307200
         item 7 key (EXTENT_CSUM EXTENT_CSUM 273794195456) itemoff 5291 
itemsize 8
                 range start 273794195456 end 273794203648 length 8192
         item 8 key (EXTENT_CSUM EXTENT_CSUM 273794203648) itemoff 5099 
itemsize 192
                 range start 273794203648 end 273794400256 length 196608
         item 9 key (EXTENT_CSUM EXTENT_CSUM 273794400256) itemoff 4791 
itemsize 308
                 range start 273794400256 end 273794715648 length 315392
         item 10 key (EXTENT_CSUM EXTENT_CSUM 273794715648) itemoff 4779 
itemsize 12
                 range start 273794715648 end 273794727936 length 12288
         item 11 key (EXTENT_CSUM EXTENT_CSUM 273794990080) itemoff 4683 
itemsize 96
                 range start 273794990080 end 273795088384 length 98304
         item 12 key (EXTENT_CSUM EXTENT_CSUM 273795088384) itemoff 4587 
itemsize 96
                 range start 273795088384 end 273795186688 length 98304
         item 13 key (EXTENT_CSUM EXTENT_CSUM 273795448832) itemoff 4571 
itemsize 16
                 range start 273795448832 end 273795465216 length 16384
         item 14 key (EXTENT_CSUM EXTENT_CSUM 273795465216) itemoff 4551 
itemsize 20
                 range start 273795465216 end 273795485696 length 20480
         item 15 key (EXTENT_CSUM EXTENT_CSUM 273795485696) itemoff 4523 
itemsize 28
                 range start 273795485696 end 273795514368 length 28672
         item 16 key (EXTENT_CSUM EXTENT_CSUM 273795514368) itemoff 4427 
itemsize 96
                 range start 273795514368 end 273795612672 length 98304
         item 17 key (EXTENT_CSUM EXTENT_CSUM 273795612672) itemoff 4315 
itemsize 112
                 range start 273795612672 end 273795727360 length 114688
         item 18 key (EXTENT_CSUM EXTENT_CSUM 273795727360) itemoff 4299 
itemsize 16
                 range start 273795727360 end 273795743744 length 16384
         item 19 key (EXTENT_CSUM EXTENT_CSUM 273795743744) itemoff 4283 
itemsize 16
                 range start 273795743744 end 273795760128 length 16384
         item 20 key (EXTENT_CSUM EXTENT_CSUM 273795760128) itemoff 4267 
itemsize 16
                 range start 273795760128 end 273795776512 length 16384
         item 21 key (EXTENT_CSUM EXTENT_CSUM 273796366336) itemoff 4015 
itemsize 252
                 range start 273796366336 end 273796624384 length 258048
         item 22 key (EXTENT_CSUM EXTENT_CSUM 273797410816) itemoff 3543 
itemsize 472
                 range start 273797410816 end 273797894144 length 483328
         item 23 key (EXTENT_CSUM EXTENT_CSUM 273798201344) itemoff 2931 
itemsize 612
                 range start 273798201344 end 273798828032 length 626688
         item 24 key (EXTENT_CSUM EXTENT_CSUM 273798828032) itemoff 2315 
itemsize 616
                 range start 273798828032 end 273799458816 length 630784
         item 25 key (EXTENT_CSUM EXTENT_CSUM 273799720960) itemoff 2255 
itemsize 60
                 range start 273799720960 end 273799782400 length 61440
         item 26 key (EXTENT_CSUM EXTENT_CSUM 273799782400) itemoff 2199 
itemsize 56
                 range start 273799782400 end 273799839744 length 57344
         item 27 key (EXTENT_CSUM EXTENT_CSUM 273799839744) itemoff 2139 
itemsize 60
                 range start 273799839744 end 273799901184 length 61440
         item 28 key (EXTENT_CSUM EXTENT_CSUM 273799901184) itemoff 2023 
itemsize 116
                 range start 273799901184 end 273800019968 length 118784


Hope, this enables someone to help me recover my stuff.
BR, CHristian
