Return-Path: <SRS0=Zicy=M3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35A51C04AA5
	for <linux-btrfs@archiver.kernel.org>; Mon, 15 Oct 2018 14:42:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EA31F2083C
	for <linux-btrfs@archiver.kernel.org>; Mon, 15 Oct 2018 14:42:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="acZBedQq"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EA31F2083C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726942AbeJOW2X (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 15 Oct 2018 18:28:23 -0400
Received: from mail-lj1-f177.google.com ([209.85.208.177]:34750 "EHLO
        mail-lj1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726614AbeJOW2X (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 15 Oct 2018 18:28:23 -0400
Received: by mail-lj1-f177.google.com with SMTP id j17-v6so17752673lja.1
        for <linux-btrfs@vger.kernel.org>; Mon, 15 Oct 2018 07:42:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:subject:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=t43v8fNUR6wbdIowiOSPldwOjJ4bsSC5wSh4vCn6YRE=;
        b=acZBedQqJHpbVq6TNROdnDFKbABYvEykyd0V0YdqhVIqwJ5VJzXssg/2LjlbJ995xM
         w6qFuA5Lb/hIj31AzBoSMGkvdN4cTbv/2oAh2QsYITxlHBdiQnRC1IAN/M0h0gPGVHhZ
         T2vGRIpz2yf5HWxYMqNtXRrB+1PoaX5qKLhWwVhYZJWLht1NLe8CXrDh7Mn6JkeEgigO
         cI89fLg/Rz3OSLEP3TqGM1ZgqsakkrsN5BwN7+C41ryoBDf+fdIc7H1IZOD7Pyx1EFU/
         IZnGi5mz1ABhi33RxhwyIdbKoqnnJA+RocRqFcTsX9aK9FPKRAnVNgaAt+CRswRY+4ej
         j8Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=t43v8fNUR6wbdIowiOSPldwOjJ4bsSC5wSh4vCn6YRE=;
        b=jy1MHuOrtPgrp4tDK9hC6V1wkAD2cGVofsVIudKcOcalU9yTZzOb1C5b/6y+q6JnuR
         KIxgeKkoZZv1UBgmQ13iqqHn+cYjlFA63uZM38KaOF+UuiNoFxf3nEpd0p2W2zQe6eJl
         I+X5CD1k4YUX5XAArXm9dVu/MqIPDpj2vSGNjNwItIejrMIpHItlFAPbHmO5u6U4XyCW
         0QwkUWCfuhs0J71+Grod6xL3lW2mLUC8hMw0xq/0a40wm7xB/qwzWCCTq173bB5Sa9mK
         DzcoNcN0lkdWGggfUrG3tVf8mRStHXvUrfaIJvwjAgo2AZUPYkeSmYrYdFu9WDlWDMh+
         VDRA==
X-Gm-Message-State: ABuFfojMzUYPDqacHd0uWN4vr/+Y6AXZG3tw8RYSiLlG4z+WEguPEiWx
        nayUybjXB0ZH4a/75as5kMhxm6uY
X-Google-Smtp-Source: ACcGV63DloZR9b5400hUF5MIpu/faxM9fuHu9GYWa/CrVFFf8WgHBWex9HEQfR4jvL35Ad9gRz2brA==
X-Received: by 2002:a2e:8884:: with SMTP id k4-v6mr10890088lji.145.1539614567766;
        Mon, 15 Oct 2018 07:42:47 -0700 (PDT)
Received: from erp07.git.ru ([94.79.3.84])
        by smtp.gmail.com with ESMTPSA id h87-v6sm2526521lji.9.2018.10.15.07.42.38
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1 cipher=AES128-SHA bits=128/128);
        Mon, 15 Oct 2018 07:42:39 -0700 (PDT)
Date:   Mon, 15 Oct 2018 17:42:38 +0300
From:   Anton Shepelev <anton.txt@gmail.com>
To:     linux-btrfs@vger.kernel.org
Subject: Re: Interpreting `btrfs filesystem show'
Message-Id: <20181015174238.cb240bc0df3efffb92cec42a@gmail.com>
In-Reply-To: <20181015174040.6f4962336386d8549026908c@gmail.com>
References: <20181015172408.1b3867debea3951fb7014ee4@gmail.com>
        <20181015142641.GD9538@carfax.org.uk>
        <20181015174040.6f4962336386d8549026908c@gmail.com>
X-Mailer: Sylpheed 3.5.0 (GTK+ 2.24.23; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hugo Mills to Anton Shepelev:

>>While trying to resolve free space problems, and found
>>that I cannot interpret the output of:
>>
>>> btrfs filesystem show
>>
>>Label: none  uuid: 8971ce5b-71d9-4e46-ab25-ca37485784c8
>>        Total devices 1 FS bytes used 34.06GiB
>>        devid    1 size 40.00GiB used 37.82GiB path /dev/sda2
>>
>>How come the total used value is less than the value
>>listed for the only device?
>
>   "Used" on the device is the mount of space allocated.
>"Used" on the FS is the total amount of actual data and
>metadata in that allocation.
>
>   You will also need to look at the output of "btrfs fi
>df" to see the breakdown of the 37.82 GiB into data,
>metadata and currently unused.
>
>See
>https://btrfs.wiki.kernel.org/index.php/FAQ#Understanding_free_space.2C_using_the_original_tools for the details

Thank you, Hugo, understood.  mount/amount is a very fitting
typo :-)

Does the standard `du' tool work correctly for btfrfs?

-- 
()  ascii ribbon campaign - against html e-mail
/\  http://preview.tinyurl.com/qcy6mjc [archived]
