Return-Path: <SRS0=hHgh=PT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E481FC43387
	for <linux-btrfs@archiver.kernel.org>; Fri, 11 Jan 2019 22:04:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B35F220878
	for <linux-btrfs@archiver.kernel.org>; Fri, 11 Jan 2019 22:04:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GhtciA8K"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726255AbfAKWEk (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 11 Jan 2019 17:04:40 -0500
Received: from mail-ed1-f54.google.com ([209.85.208.54]:36233 "EHLO
        mail-ed1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725767AbfAKWEk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 11 Jan 2019 17:04:40 -0500
Received: by mail-ed1-f54.google.com with SMTP id f23so14266075edb.3
        for <linux-btrfs@vger.kernel.org>; Fri, 11 Jan 2019 14:04:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=jDR6eGFqtSTaoU05NxJDfXQPglJBPFJxAq2f/X/S8oQ=;
        b=GhtciA8KXLEMlOGwgQC9jygafSS8YCjmEouI3lCMSEx8dSMrt7LxYHX9alp3rsqbso
         vlTmVoik60gGPrzcvJ1txDIbWOisag9Wc99he1xx0OMyUd7SLsV6IeG/uI23+0Nb27Wt
         b8Ze9R33Cb9OP1SVfIAtc9+a8AyoyJ8gYy3ZiglWuILMMV6yc6yq1Nmw03dXagaoZeMi
         uy0oK9o/TcXct7DJP2c473b8Pjb9dzGi30yvmILPDzWsHdd2W8+XOjxrhJ85a2Yb5bJ3
         ny8TOKPzeCZQB6/qlV3SoA+eeukv4imPPaZS9G+C9GVh6GKBzU7AltffAfcC+uL1Bkx/
         s6RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=jDR6eGFqtSTaoU05NxJDfXQPglJBPFJxAq2f/X/S8oQ=;
        b=WhaW6sEvMGcKKKXKcaO2daJQfoyKxECTxIQ5HZdQCdwTRSIH8N7tpAT4GpSTGCeYsl
         7xQW+jCFcCdZOXHGgQZkZFreiJOHmMq80y/voaMtKwOtm161ZdzhN8EAykc79YE2Wc2r
         ElWuPA5zIDLkG0q51DgfQSxN0Cu8ioko+0VjPEmX+zuVyJWaM5IbhNYGObt83sS6JTRQ
         7kBds8q5USnC28XGW9LHIXqxXeMqXb61hfg+bFj8ARZQpAqezIwFiKsBWB9jsfYmjX9z
         eLMqeCv+e5FXndDjEJZqdtOu8UjDhLVOQy54d3HiXOvSzHLv+teApnINSQu7A2e0Cy3b
         ZEHQ==
X-Gm-Message-State: AJcUukfXH4qXlPDC6QXJYoc0nkYHQResVTeoVmj6xTZIawVTgKPzhlun
        iklen/YIRNDIsxrhRQNoeLxpxI/x
X-Google-Smtp-Source: ALg8bN4Ssa509wGnw1Z8fLJcLKowNQBlkEG2irPMTPzGUU6D91FQJrcPgEfFaouO7RYL9Bh4VL1K+A==
X-Received: by 2002:a17:906:1a49:: with SMTP id j9-v6mr12649377ejf.45.1547244277644;
        Fri, 11 Jan 2019 14:04:37 -0800 (PST)
Received: from [172.26.1.3] (085083086107.dynamic.telenor.dk. [85.83.86.107])
        by smtp.googlemail.com with ESMTPSA id l51sm2689634edb.36.2019.01.11.14.04.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 11 Jan 2019 14:04:36 -0800 (PST)
Subject: Re: Balance of Raid1 pool, does not balance properly.
To:     Peter Becker <floyd.net@gmail.com>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>
References: <cbffc26e-a57f-e1ad-284c-a54431c4e2f1@gmail.com>
 <64cf0762-bd59-3d77-8aca-94622233767f@gmail.com>
 <CAEtw4r1we4ctoTwvExFWwc1WFgtBJXYXOizNZrrzqyBGbHCv-A@mail.gmail.com>
 <24856b7a-e4ca-bf12-f70b-7f016142e6b2@gmail.com>
 <CAEtw4r1-YEotbHF-SF_N12by=d+6h=hwb9u8Rt6RFHeGZaw=Pw@mail.gmail.com>
From:   Karsten Vinding <karstenvinding@gmail.com>
Message-ID: <9a1ac92f-7b92-e9bd-69ab-67d3f47eb887@gmail.com>
Date:   Fri, 11 Jan 2019 23:04:34 +0100
User-Agent: Mozilla/5.0 (Windows NT 6.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.2
MIME-Version: 1.0
In-Reply-To: <CAEtw4r1-YEotbHF-SF_N12by=d+6h=hwb9u8Rt6RFHeGZaw=Pw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: da
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Thanks for all your suggestions.


I will save your instructions for future reference and use.

The current complete balance is 90% done, and the data are now perfectly 
evenly distributed across the drives.

Vielen danke für deine hilfe :)
