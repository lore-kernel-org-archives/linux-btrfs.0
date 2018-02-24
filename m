Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailout-cust-4.websupport.sk ([37.9.172.248]:48467 "EHLO
        mailout-cust-4.websupport.sk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751289AbeBXLNT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 24 Feb 2018 06:13:19 -0500
Received: from lb-proxy-12.websupport.sk (unknown [10.10.2.12])
        by mail-proxyout-custom-1.websupport.sk (Postfix) with ESMTP id 3zpQSD06QMz5mJ2
        for <linux-btrfs@vger.kernel.org>; Sat, 24 Feb 2018 12:13:14 +0100 (CET)
Received: from pc7ssd (unknown [194.160.195.20])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: marian@prima.pis.sk)
        by lb-proxy-12.websupport.sk (Postfix) with ESMTPSA id 3zpQSB1XrMz5y2k
        for <linux-btrfs@vger.kernel.org>; Sat, 24 Feb 2018 12:13:14 +0100 (CET)
Message-ID: <E9DC5E3A12524BBAA0B7D3BDE7FB87F2@pc7ssd>
From: =?UTF-8?Q?Mari=C3=A1n_Ml=C4=8Doch?= <marian@prima.pis.sk>
To: <linux-btrfs@vger.kernel.org>
Subject: BTRFS RESTORE issue
Date: Sat, 24 Feb 2018 12:13:17 +0100
MIME-Version: 1.0
Content-Type: text/plain;
        format=flowed;
        charset="UTF-8";
        reply-type=original
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,
i requst IRC , but nobody helps.
My primary question is , how mark restored files with ignored errors.

btrfs restore –iv /vol /restorage

this command restores files like charm but no marker for ok and bad files 
(bad crc , bad ...). WHY?
This file system isnt newbie , i mean this is urgent feature.

I restore terabytes miloins files , how after this check bad files ???

Please send me info around this , and add this feature ifnt exist.

I see one way use dump restore filter but how?

btrfs restore –ivD /vol /restorage | grep ??? for bad files

Second question is when files is restored with switch –iv , exist way to 
update metadata in next restore without overwrite? This is for restore next 
urgent feature.

Thanks for info Marian. 

