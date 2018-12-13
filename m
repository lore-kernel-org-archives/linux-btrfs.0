Return-Path: <SRS0=1olR=OW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9813C65BAE
	for <linux-btrfs@archiver.kernel.org>; Thu, 13 Dec 2018 03:31:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6D74720811
	for <linux-btrfs@archiver.kernel.org>; Thu, 13 Dec 2018 03:31:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mGQ3K01L"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6D74720811
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726500AbeLMDbP (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 12 Dec 2018 22:31:15 -0500
Received: from mail-wr1-f50.google.com ([209.85.221.50]:45239 "EHLO
        mail-wr1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726372AbeLMDbP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Dec 2018 22:31:15 -0500
Received: by mail-wr1-f50.google.com with SMTP id t6so297614wrr.12
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Dec 2018 19:31:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=4SxlS6FF970olQCjE8HDzeDPPTOAMyHbG5YyA+1MEvY=;
        b=mGQ3K01LB95pb4jVwDDXqQyq17eigqLqxRtH/J0YQfXudEUZRRJRpfqhgU81NbsEXT
         PRq+9pLiP016NzsgASTSU1ZMkaYhRr0qmi2AwbnNAr0mUkNG0xUY9mndov9cuksMYdeW
         PZx/LRZpRQVwB4B46I7oDsIolbz7fc90VL19qlF4/nT1NJ1lpHYYJ+rlWtOxlYby1Fgz
         OuevEkD6VAWBhvchkPcruGQU2/nYsVNKSuOthZangl2IyivG5G+llCZn7s1dj+yNPgKq
         3hXVUCv3013xducyL9dN/CFxJmZ8anRG9KjQ4tvtB38GRSd4puxHAe+7BQh/hnbub4my
         GYzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=4SxlS6FF970olQCjE8HDzeDPPTOAMyHbG5YyA+1MEvY=;
        b=hX975ufjILnz04QKjSwIbFCSfC2ePGfIQOv2JZS8jrpfsGpiiVAguRys/TnA++ngjQ
         yQcUyeQBIlumYZAK4lLebyqWS2oID3oqIeLj1A36/UQ7tFMj0B+0xkqgUQw6j5jm1q+n
         3TQeeQo+DXqhDkAY+22s5QRO9gvukcgKO2++P9vWX5z7+cgnyPkKIHJSDpWwmJ/zX0Fd
         BRKi1PNOndrJ+hgP+YYJcijNJH9nnbReyGGnaAPqkp4ViA4dRgWEWuueOHnMWUzJw8xz
         uW6H1c407aKzPrbSuqoi8XYnfPC/rGIaA55njTX7vVVrf1do3253BWCNxRQxWr++br0+
         lyzQ==
X-Gm-Message-State: AA+aEWYSrkl0Iht5A/NlrYyQJXJdzJBgx9EXW/pD7rrBCtlhvgTDOJKI
        Th0cyDvuYvbF/Ohq+h1VV8VW3B87ND9D1zEL1UxQDg==
X-Google-Smtp-Source: AFSGD/X49Tz6Yf/NFhAiQ1MoVcQ3NGMHP/vZVSRGAvs2jF/KlcOCgsBI7YNkiKFjpyFSpjc3b9hCbGxqcU/OOCrhBH0=
X-Received: by 2002:a05:6000:14f:: with SMTP id r15mr20845489wrx.53.1544671873812;
 Wed, 12 Dec 2018 19:31:13 -0800 (PST)
MIME-Version: 1.0
From:   Nathan Dehnel <ncdehnel@gmail.com>
Date:   Wed, 12 Dec 2018 21:31:02 -0600
Message-ID: <CAEEhgEtryrEBv-PgZ5VkXEUcmXhx7JCoRrDhyLK5zP0-zOsESw@mail.gmail.com>
Subject: SATA/SAS mixed pool
To:     linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Is it possible/safe to replace a SATA drive in a btrfs RAID10 pool
with an SAS drive?
