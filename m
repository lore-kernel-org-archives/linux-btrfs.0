Return-Path: <SRS0=FrL0=PV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A752EC43387
	for <linux-btrfs@archiver.kernel.org>; Sun, 13 Jan 2019 10:19:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 66C952064C
	for <linux-btrfs@archiver.kernel.org>; Sun, 13 Jan 2019 10:19:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UXS7VtWu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726598AbfAMKTS (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 13 Jan 2019 05:19:18 -0500
Received: from mail-ed1-f68.google.com ([209.85.208.68]:44104 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726578AbfAMKTS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 13 Jan 2019 05:19:18 -0500
Received: by mail-ed1-f68.google.com with SMTP id y56so16388321edd.11
        for <linux-btrfs@vger.kernel.org>; Sun, 13 Jan 2019 02:19:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-transfer-encoding:content-language;
        bh=7PZQ1PFQIeusPNOiYfiRrKLO8E8hfbTnNLyeFxm0bp0=;
        b=UXS7VtWuYcWLq+BTTdN+n2xEBx5VdaEG9Lu0Yj1ykNF2i0Ik3cntFXbNTWZUPhJ0fY
         kXtcbrEC/yrg/dOcGxrrXr73ki9oyyNlZBqvq6fHnbAduT6HzphTIc+Pwt3kLFd9iubl
         q/OeUhTeaWuAQ2b+XO1PXvPoNfg4v4QK7NWViDe7bQpyj0T3Vn5hN0GwS1r7qhzG7ZFE
         aUjPMl91b1j0aO1b5C4PfzX/xh0d40r2rlG7M1NaQCqL+0xxf/TypMum/gYYZkhqQHov
         zkypDy0uLTDvwRUdLsJ9aNBtE/5Rpaf63dxRwmF8RtGJ4M0FCFRDXPoVJduzlwViaNzo
         QjGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-transfer-encoding:content-language;
        bh=7PZQ1PFQIeusPNOiYfiRrKLO8E8hfbTnNLyeFxm0bp0=;
        b=NQ9t9e8D0liwgV1k3oIm22oX51R9YxMV5Xz0/DG/qGSn2wBqoeYcTOetmzNpjphYHW
         XheNpBJhEyVcWQZaDW0vsXcjTPhHTQn6xyi5ORBU2ZngmAaEob0ILMS+BcmyENC+H0xl
         kwr3WjmqBK/Bz3JPlAYI1wvYQOR27MO89Amp/MfMHOoUAi7z57nxXGD5oC+yPM6QOIML
         FaruHj/fl4hR/5o8RHfCGBr/kTevVv5R3zTJbl8tNu2UD0HocA7N24JnIpAMplJq+dvX
         w+sdIzgeK3lS3wAqWqWSOuavLOiEYuh7x3hWHTakauh+UGYBLYD/KzT1CHShp0LD/qx/
         1z1Q==
X-Gm-Message-State: AJcUukeCcYf/vzKpoRZf9DR/iwJ6P6dhBFvu0oBPUXAlQLL3hJ3XN1l4
        Q656eOXBxqxF6PzOuZr1znQksJ3U
X-Google-Smtp-Source: ALg8bN5F5OyTaRr8zbIhlqkJw035YRBcaaGYxAPTifKhh8zn+8WW6XlkTNVVfBI6ouoUtrZIGbS3+Q==
X-Received: by 2002:a50:b8e5:: with SMTP id l92mr18863293ede.294.1547374756145;
        Sun, 13 Jan 2019 02:19:16 -0800 (PST)
Received: from [192.168.254.12] (ip5b42439c.dynamic.kabel-deutschland.de. [91.66.67.156])
        by smtp.googlemail.com with ESMTPSA id c12sm3369286edi.52.2019.01.13.02.19.14
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 13 Jan 2019 02:19:15 -0800 (PST)
To:     "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From:   Tobias Reinhard <trtracer@gmail.com>
Subject: Retrieving
Message-ID: <4472aad4-86cb-7ce2-6055-1ff8d6955969@gmail.com>
Date:   Sun, 13 Jan 2019 11:19:04 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.3
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-GB
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi,

I want to read the complete CSUM-Tree from userspace. I tried it via the 
ioctl. This is what the code looks like:

struct btrfs_sv2_args sv2_args;
int fd = open(filename, O_RDONLY);
sv2_args.key.tree_id = BTRFS_CSUM_TREE_OBJECTID;
sv2_args.key.min_objectid = 0;
sv2_args.key.max_objectid = -1;
sv2_args.key.min_offset = 0;
sv2_args.key.max_offset = -1;
sv2_args.key.min_transid = 0;
sv2_args.key.max_transid = -1;
sv2_args.key.min_type = BTRFS_CSUM_ITEM_KEY;
sv2_args.key.max_type = BTRFS_CSUM_ITEM_KEY;
sv2_args.key.nr_items = -1;
sv2_args.buf_size = sizeof(sv2_args.buf);
ioctl(fd, BTRFS_IOC_TREE_SEARCH_V2, &sv2_args);

But the device is not small and I hit the limit of the 
btrfs_sv2_args.buf which seems to be 16 MB.

How can I get the *complete* CSUM-Tree?

Limiting to offset does not work (My first idea was to do it this way 
and get it in chunks).

Limiting to a single transid does not work as well because even one 
transid is larger than the limit.

Kernel is 4.15.

Any help would be appreciated.

Best Regards

Tobias

