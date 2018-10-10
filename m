Return-Path: <SRS0=ayZ+=MW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95862C43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Oct 2018 04:48:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4491A2086E
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Oct 2018 04:48:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nGD/b8+Q"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4491A2086E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727253AbeJJMIK (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 10 Oct 2018 08:08:10 -0400
Received: from mail-ed1-f51.google.com ([209.85.208.51]:34870 "EHLO
        mail-ed1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726647AbeJJMIK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 10 Oct 2018 08:08:10 -0400
Received: by mail-ed1-f51.google.com with SMTP id y19-v6so3700060edd.2
        for <linux-btrfs@vger.kernel.org>; Tue, 09 Oct 2018 21:47:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:from:subject:openpgp:autocrypt:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=AU0ETs6RQ7k+EQhy5R6UNWpNA76GWVjpNl1GDbZSSqA=;
        b=nGD/b8+Q8OH70VRfpS5cUz6T4tuGzOa8UfN0tpD6FHZuyr22hj79eGjwNwOIGoMsZz
         CqlU2/ZGv6r9qF8/WINKNfobOJOHLosroe3Lxq0BOZtKkEsBQBVfG+gMhTPd//aflAKb
         6fOGIwpS++7WWBc0RgMz5tzVY7LQBWVaXmeQaJb29FPdNxsPPv6wPDIQM+3L17dd4bhX
         jpt8K0JS+Vlqc0kQvdnaLrcc7zcRvu1SQncBVdxnPWEFMh4vtird+hkaoLTS8R16JRPx
         jTvN6XrmEtc/tIpvsSWlrJ1nIkXWWIKjQr4SxeMzAKysjJmu8ddHYT6lOBQSz/b5cG4p
         zSGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:openpgp:autocrypt:message-id
         :date:user-agent:mime-version:content-language
         :content-transfer-encoding;
        bh=AU0ETs6RQ7k+EQhy5R6UNWpNA76GWVjpNl1GDbZSSqA=;
        b=FuzdIvXe3TH+kg+UzmhRFfnzjJLrTlhLhWVxGF4s1GnJeFlMQsR4u0hMEsfttYWJoT
         0HnbYWeylXFNRx0t9Trxox9lzStf5eG6yt+dwnBZcmP6S2yI/uYyhWZJcjNNdbksDY2n
         25P5pIV5jgR6O6RErLsLO6KLqabnKYq8fCh7OaujLFUm3dNUTvUH2NDbQBz+DdotBT1A
         OoAiSiuuzBdTRtA2rXAirWErfJGRAi9mGXg7KYaNkUYIxbGwwcL7s/WVqjve4ZIKaz9o
         lcj+L+nc3GX6aiJuWfUot19khcM0FOcbqAOl4IW68lJQf3hE2dB+3no10jnSE8N4KpHv
         DxgA==
X-Gm-Message-State: ABuFfoh/YWjxtGe8+uMI19iEKBhp5llwKJQvKj7RKE9x2T2SDEvJDsCk
        riktz93DuA0IjtYH62M85ehAAS2T
X-Google-Smtp-Source: ACcGV62LpqCxVRzsWTeW0deVNuSOVoCpSq34Idqrarwy5DthYORjeBNS2fgB6VIAJg5bL+LUEstCCA==
X-Received: by 2002:a50:87ba:: with SMTP id a55-v6mr39798246eda.140.1539146869991;
        Tue, 09 Oct 2018 21:47:49 -0700 (PDT)
Received: from ?IPv6:2001:985:c353:1:69e7:48fa:7f9:ef69? ([2001:985:c353:1:69e7:48fa:7f9:ef69])
        by smtp.gmail.com with ESMTPSA id m25-v6sm7050086edc.86.2018.10.09.21.47.48
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 09 Oct 2018 21:47:49 -0700 (PDT)
To:     linux-btrfs@vger.kernel.org
From:   Shapranov Vladimir <equidamoid@gmail.com>
Subject: Recovery options for damaged beginning of the filesystem
Openpgp: preference=signencrypt
Autocrypt: addr=equidamoid@gmail.com; prefer-encrypt=mutual; keydata=
 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
 3Cxxga9Zl1uP8zliiheUbg==
Message-ID: <1a39748c-19de-5fdc-f8ee-efdced880df4@gmail.com>
Date:   Wed, 10 Oct 2018 06:47:48 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.11; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi,

I've got a filesystem with first ~50Mb accidentally dd'ed.

"btrfs check" fails with a following error (regardless of "-s"):
checksum verify failed on 21037056 found FC8A6557 wanted 2F51D090
checksum verify failed on 21037056 found FC8A6557 wanted 2F51D090
checksum verify failed on 21037056 found 1EDD5E47 wanted 222F7E7F
checksum verify failed on 21037056 found 1EDD5E47 wanted 222F7E7F
bytenr mismatch, want=21037056, have=13515002166904211737
ERROR: cannot read chunk root
ERROR: cannot open file system

"mount -o ro /dev/sdf1 /mnt/tmp" fails, while "mount -o ro,subvol=X /mnt/tmp" succeeds for "/" and couple subvolumes.

I can even ls the root directory, but at some point something can't be read anymore and following errors appear in dmesg:
[385647.999981] btrfs_dev_stat_print_on_error: 158686 callbacks suppressed
[385648.079187] BTRFS error (device sdd1): bdev /dev/sdf1 errs: wr 0, rd 22094847, flush 0, corrupt 0, gen 0
[385648.193733] BTRFS error (device sdd1): bdev /dev/sdf1 errs: wr 0, rd 22094848, flush 0, corrupt 0, gen 0

Also it is worth mentioning that after corruption one of the subvolumes was mounted read-write and possibly some files were written.

Is there any chance to recover the FS?



-- 
Best regards,
Vladimir
