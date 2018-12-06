Return-Path: <SRS0=+YL1=OP=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D086C04EB8
	for <linux-btrfs@archiver.kernel.org>; Thu,  6 Dec 2018 06:19:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1AF4920838
	for <linux-btrfs@archiver.kernel.org>; Thu,  6 Dec 2018 06:19:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1AF4920838
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=pobox.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728996AbeLFGT4 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 6 Dec 2018 01:19:56 -0500
Received: from resqmta-po-02v.sys.comcast.net ([96.114.154.161]:55922 "EHLO
        resqmta-po-02v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728294AbeLFGT4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 6 Dec 2018 01:19:56 -0500
X-Greylist: delayed 488 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Dec 2018 01:19:56 EST
Received: from resomta-po-17v.sys.comcast.net ([96.114.154.241])
        by resqmta-po-02v.sys.comcast.net with ESMTP
        id Umkfghe7bkRy4Umt2gfGmc; Thu, 06 Dec 2018 06:11:48 +0000
Received: from touchy.whiterc.com ([IPv6:2601:601:1400:69b4:35fb:69c0:6cd9:337d])
        by resomta-po-17v.sys.comcast.net with ESMTPSA
        id Umt1glNnYyJIlUmt1gxX0a; Thu, 06 Dec 2018 06:11:48 +0000
To:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From:   Robert White <rwhite@pobox.com>
Subject: What if TRIM issued a wipe on devices that don't TRIM?
Message-ID: <bca3c064-0df5-a18c-7196-ac12c64141bf@pobox.com>
Date:   Thu, 6 Dec 2018 06:11:46 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfJDY9Ps7QmVa3sWxL1TNTi6H2n+hbX4yMElE9r++R68xuGDrgNkxsiLSZaPZnM/H/ZDTEKhGfIb1aX/HVJYumZ5CVqbXopCMR6gBJ1F7zWp59ddUPSAQ
 7I0aQ+wgUx9ep0hC+j2HkWcRtfRFRaaVu32eINpHq3WR1PPfdD4VbnRs9ozSp9hYc4tsqOPH2Lz+MCfG52pinjQHwSN2mbnFGXaQiJ5EAT43R4876wFNuzIk
 rDNkOF/cCRxyPwt1i6wUPQ==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

(1) Automatic and selective wiping of unused and previously used disk 
blocks is a good security measure, particularly when there is an 
encryption layer beneath the file system.

(2) USB attached devices _never_ support TRIM and they are the most 
likely to fall into strangers hands.

(3) I vaguely recall that some flash chips will take bulk writhes of 
full sectors of 0x00 or 0xFF (I don't remember which) were second-best 
to TRIM for letting the flash controllers defragment their internals.

So it would be dog-slow, but it would be neat if BTRFS had a mount 
option to convert any TRIM command from above into the write of a zero, 
0xFF, or trash block to the device below if that device doesn't support 
TRIM. Real TRIM support would override the block write.

Obviously doing an fstrim would involve a lot of slow device writes but 
only for people likely to do that sort of thing.

For testing purposes the destruction of unused pages in this manner 
might catch file system failures or coding errors.

(The other layer where this might be most appropriate is in cryptsetup 
et al, where it could lie about TRIM support, but that sort of stealth 
lag might be bad for filesystem-level operations. Doing it there would 
also loose the simpler USB use cases.)

...Just a thought...

--Rob White.


