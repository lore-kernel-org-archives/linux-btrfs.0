Return-Path: <SRS0=Zicy=M3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47F55C04AA5
	for <linux-btrfs@archiver.kernel.org>; Mon, 15 Oct 2018 14:24:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DC4E920644
	for <linux-btrfs@archiver.kernel.org>; Mon, 15 Oct 2018 14:24:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nhIa+Stq"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DC4E920644
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726599AbeJOWJm (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 15 Oct 2018 18:09:42 -0400
Received: from mail-lj1-f169.google.com ([209.85.208.169]:42266 "EHLO
        mail-lj1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726561AbeJOWJl (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 15 Oct 2018 18:09:41 -0400
Received: by mail-lj1-f169.google.com with SMTP id y71-v6so17667009lje.9
        for <linux-btrfs@vger.kernel.org>; Mon, 15 Oct 2018 07:24:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=n5NbJBmxg03A49I8nXO0qbJRqlzRTbx9/GRsjPdET40=;
        b=nhIa+StqvXLfLDd363g8PfuSPuNTikwlw2pVOzw5linE0Fd30z7K//+C1F7En+WKyr
         qwZoO3koWoKUF0qzKJg1gJnk07wwRDGECt6dDboWTELvF9dzdKnlhnOhUFuHDsgGFCt8
         75/2v2Iw1zyz9kxm5KTtdVUNzdwgdkaZq0hSQmpWhDEmDL2AdXL95oSf6F6Vtsxgon9n
         2dVyhY7SJfa5DBGUa89+DXWViqmvtMpTh9RochNBsWjkDU/hFgqGyDk78XwJLtat8aye
         nfYXJJI/4S79N64UQ0CT1zDqIVXGtA9m9iQrN6Lpkwu5o8J5f0rlXX7WcwjAxOmPyXZ+
         MfLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=n5NbJBmxg03A49I8nXO0qbJRqlzRTbx9/GRsjPdET40=;
        b=Xye/rdXQIqqRmj+W6iTCbS621YFX9pAxwEz/GbFL4QonFTRu7v7WYYPnwl9LflutXC
         Yxnsb7lj2CRM13Kjqs4osn7uwDmo5v5tmQ8nISYrk6sYpOy9jfYkIArj8wAaWXyk1/WF
         kgdW5ZD0dJcHXTrkccaHoVsY/fAwJdTNOFVOD6NvpLQIa4usB1W7HwN6H2K7ztrflY2V
         8Iamvt+uJXrpST+Uf9ebZWHwWXW80yIQe08vnNWv8E8015/v8kfz2k3LBPxKcwhPb/g8
         nnFXtJJm4kdVt3UPTirLp8tln4jJraLcmmm7uUrtuvHCs5tPTfBfjcMATm+FncUV05nz
         zt/w==
X-Gm-Message-State: ABuFfogvNStCwfsMbml953g5g1Ui8VuE/Mn60+o8T78LPQynTppBEBXd
        dCSShGZQVW60E4STaHz40iicMa3m
X-Google-Smtp-Source: ACcGV60J4o1w7f4R+GR+cs3Hfb5K0CssQN6/iuUKhxwR0PFFoeZqSNmazoDZXw3Te64g0mpPwZn7Ng==
X-Received: by 2002:a2e:3c1a:: with SMTP id j26-v6mr11132504lja.172.1539613450239;
        Mon, 15 Oct 2018 07:24:10 -0700 (PDT)
Received: from erp07.git.ru ([94.79.3.84])
        by smtp.gmail.com with ESMTPSA id m132-v6sm2229474lfg.24.2018.10.15.07.24.09
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1 cipher=AES128-SHA bits=128/128);
        Mon, 15 Oct 2018 07:24:09 -0700 (PDT)
Date:   Mon, 15 Oct 2018 17:24:08 +0300
From:   Anton Shepelev <anton.txt@gmail.com>
To:     linux-btrfs@vger.kernel.org
Subject: Interpreting `btrfs filesystem show'
Message-Id: <20181015172408.1b3867debea3951fb7014ee4@gmail.com>
X-Mailer: Sylpheed 3.5.0 (GTK+ 2.24.23; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hello, all

While trying to resolve free space problems, and found that
I cannot interpret the output of:

> btrfs filesystem show

Label: none  uuid: 8971ce5b-71d9-4e46-ab25-ca37485784c8
        Total devices 1 FS bytes used 34.06GiB
        devid    1 size 40.00GiB used 37.82GiB path /dev/sda2

How come the total used value is less than the value listed
for the only device?

-- 
()  ascii ribbon campaign - against html e-mail
/\  http://preview.tinyurl.com/qcy6mjc [archived]
