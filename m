Return-Path: <SRS0=Si37=PQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDFE0C43387
	for <linux-btrfs@archiver.kernel.org>; Tue,  8 Jan 2019 19:40:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8D9342063F
	for <linux-btrfs@archiver.kernel.org>; Tue,  8 Jan 2019 19:40:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PpX852Hb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732601AbfAHTkR (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 8 Jan 2019 14:40:17 -0500
Received: from mail-ed1-f48.google.com ([209.85.208.48]:34208 "EHLO
        mail-ed1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732596AbfAHTkQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Jan 2019 14:40:16 -0500
Received: by mail-ed1-f48.google.com with SMTP id b3so5402974ede.1
        for <linux-btrfs@vger.kernel.org>; Tue, 08 Jan 2019 11:40:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-transfer-encoding:content-language;
        bh=GwmOFODXj5NYPNY2OpkDPT81W88sz9FZXhpi1aPhC9A=;
        b=PpX852Hbc/bE3UjJLMwzT2EjGJpXxIylTI9JJNVIuG2uHJcmS2fwNA+KVFbmtLYnQs
         uvSBhEJpBXLRsD/LDtM/E7QACtI5++/zV9avjHdjqh/z3z8x1TRldQOXCvm+OjRriKK/
         bxbuBQ1mIOkmfyrL5gy/4Pve0PZ6afA5CF7ic0npmXnVyyvOWBb+00Vs5p3LULtLgL9I
         KxxlL/CRMxSIhAb1R91xYmr/lJFJmA2rYEEz+I4G3SwA4jYNDBlFwcOtP+WsOPaAKgMm
         l6R03GWRKwrVhWTqC/CyEtNFg7Ssn7HQvTXL0wHuXyW63iulK3W0PNpejL6j3u6QvvZZ
         9uoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-transfer-encoding:content-language;
        bh=GwmOFODXj5NYPNY2OpkDPT81W88sz9FZXhpi1aPhC9A=;
        b=KtTWaWQ12VxanzvUI504OVkDv/0x7EeuKuHz8zZnRJnKoAjCQIv4T4/09VNgTaXXvI
         vassYl1YQi3GNqDwtpa4wWbfYVtNPxb46NxLY2lt2Ozky++4uKCip3fNg+ORd/adXrAm
         qYNjvwf3g4l5rbb8dLRujfwoUzzMoQ3zUne9HGIGMo3swrzRkUK2K4jZbBW/0EvB+e6z
         paiy4zeZ0MG3iVXlRMIiH/Rrt4T8NJDxVPpvD2W1vI6nDFkNrEO6IuFTGD5Oe80+Wg+W
         1Ixlhwz+dbgGMdJKsICd3b11FzGRO6dEi0jD/ZATY05IveCVNqSLpXic/cIyq9e1kl9w
         1Xjw==
X-Gm-Message-State: AJcUukeDPfznRz3pju5UqxsduoWKiheFnxJPLh/ZHsA1e+QcpG2t2+yh
        7WKGgYVLkZPxcG12/vFGiCyyZS9k
X-Google-Smtp-Source: ALg8bN5n9hmSp3TF8BY/PN56S1XbtXFPhoQloHPWFOGevGqiLSLbbQVSGMendvInW+vIZStGf51OZA==
X-Received: by 2002:aa7:d0c5:: with SMTP id u5mr3289936edo.158.1546976413922;
        Tue, 08 Jan 2019 11:40:13 -0800 (PST)
Received: from [172.26.1.3] (085083086107.dynamic.telenor.dk. [85.83.86.107])
        by smtp.googlemail.com with ESMTPSA id j23sm261137edr.89.2019.01.08.11.40.12
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 08 Jan 2019 11:40:13 -0800 (PST)
To:     linux-btrfs@vger.kernel.org
From:   Karsten Vinding <karstenvinding@gmail.com>
Subject: Balance of Raid1 pool, does not balance properly.
Message-ID: <cbffc26e-a57f-e1ad-284c-a54431c4e2f1@gmail.com>
Date:   Tue, 8 Jan 2019 20:40:12 +0100
User-Agent: Mozilla/5.0 (Windows NT 6.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.2
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: da
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hello.

I have a Raid1 pool consisting of 6 drives, 3 3TB disks and 3 2TB disks.

Until yesterday it consisted of 3 2TB disks, 2 3TB disks and one 1TB disk.

I replaced the 1TB disk as the pool was close to full.

Replacement went well, and I ended up with 5 almost full disks, and 1 
3TB disk that was one third full.

So I kicked of a balance, expecting it to balance the data as evenly as 
possible on the 6 disks (btrfs balace start poolname).

The balance ran fine but I ended up with this:

Total devices 6 FS bytes used 5.66TiB
         devid    9 size 2.73TiB used 2.69TiB path /dev/sdf
         devid   10 size 1.82TiB used 1.78TiB path /dev/sdb
         devid   11 size 1.82TiB used 1.73TiB path /dev/sdc
         devid   12 size 1.82TiB used 1.73TiB path /dev/sdd
         devid   13 size 2.73TiB used 2.65TiB path /dev/sde
         devid   15 size 2.73TiB used 817.87GiB path /dev/sdg

The sixth drive sdg, is still only one third full.

How do I force BTRFS to distribute the data more evenly across the disks?

The way BTRFS has done it now, will bring problems, when I write more 
data to the array.


