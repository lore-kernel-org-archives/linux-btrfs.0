Return-Path: <SRS0=+rOy=PS=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27A6DC43387
	for <linux-btrfs@archiver.kernel.org>; Thu, 10 Jan 2019 18:21:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ED36E20675
	for <linux-btrfs@archiver.kernel.org>; Thu, 10 Jan 2019 18:21:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="n/NFGltH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731074AbfAJSVf (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 10 Jan 2019 13:21:35 -0500
Received: from mail-ed1-f45.google.com ([209.85.208.45]:45165 "EHLO
        mail-ed1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731005AbfAJSVe (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 10 Jan 2019 13:21:34 -0500
Received: by mail-ed1-f45.google.com with SMTP id d39so10955699edb.12
        for <linux-btrfs@vger.kernel.org>; Thu, 10 Jan 2019 10:21:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=oXAEJ7f7DX/Lc7Kk1dj4iTpxYp7yNyMwRjzUByez3rk=;
        b=n/NFGltHBY0IsmTlXCfHGpesI9bwycawtOigsnYwCdE03L2lYeLFMouqxYyTjqexUU
         rzl5w6aRH27nb25h1/5Xaa7zlYFeihY+0WSeo6m5HzxSXApmnRbq+6APDy0XWkDel5O0
         dr44/AmyeJO+J4hk/3XOYMXa7queNyML+/IvZ/PnKJu8ZGynYJH2+rchwLw05Q6WhIpv
         vmpdq9Odk9BQJ7vtyxGOCEzqu6xaKpxZdWYjR35nOG4Vc+d+1KcmNfzMn7aTq/5SwLvr
         xvAfetXBRSSVDSYfnTY3aA/Y0O5L+Uqb0bJ8uKf8ykdZrxxmD0jbAAmje6PH1WpYbpAz
         HOhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=oXAEJ7f7DX/Lc7Kk1dj4iTpxYp7yNyMwRjzUByez3rk=;
        b=YvdtS7uXYqadn9YH2Y5Xox9JGjkrpdYnHBGW7sb9xspK5e2KkRPM3Iz/Jn9eGbyH6B
         4vPuwMURrNmv8H6QeRZ0xmuDoy15AHz6bjAmvX7xhfmrkBge3q65W2GT8HonOWOdSPML
         MRfs3MepC9p/DKsSR9qIIKI6Zefg3zpp2qWnfbLqjbr6FxHOIjz5mivwvxrAdc981qwc
         gM1+ZUpQ5WhUgKiSsbijF5PfyL4dGsCcA0qQ4YubBjTPjaHuXFPXcS35hV/3mp38H840
         4zPjGQh9p1042pAVJChmFMOMmBslbWI4pydLIg9E3igoIHh2BC7yndWfxTzajEF/1eAs
         dlmA==
X-Gm-Message-State: AJcUukc8+Q7kmLgjutMaZ99XzIpSi81yYj64nGWWmSHhA5rHBRPUbeFT
        HYOYMH+ApWFt6fVjMyQOjG4pH3SC
X-Google-Smtp-Source: ALg8bN5wV19kFfbYQ3iX+zIfahEXx8dEyQpUyyDxaQo1fpSJw7et1hSRVfEdIf00A41FeGlnvCUoMQ==
X-Received: by 2002:a50:a458:: with SMTP id v24mr10569575edb.241.1547144491297;
        Thu, 10 Jan 2019 10:21:31 -0800 (PST)
Received: from [172.26.1.3] (085083086107.dynamic.telenor.dk. [85.83.86.107])
        by smtp.googlemail.com with ESMTPSA id g20sm1697342edr.47.2019.01.10.10.21.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 10 Jan 2019 10:21:30 -0800 (PST)
Subject: Re: Balance of Raid1 pool, does not balance properly.
To:     Peter Becker <floyd.net@gmail.com>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>
References: <cbffc26e-a57f-e1ad-284c-a54431c4e2f1@gmail.com>
 <64cf0762-bd59-3d77-8aca-94622233767f@gmail.com>
 <CAEtw4r1we4ctoTwvExFWwc1WFgtBJXYXOizNZrrzqyBGbHCv-A@mail.gmail.com>
From:   Karsten Vinding <karstenvinding@gmail.com>
Message-ID: <24856b7a-e4ca-bf12-f70b-7f016142e6b2@gmail.com>
Date:   Thu, 10 Jan 2019 19:21:27 +0100
User-Agent: Mozilla/5.0 (Windows NT 6.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.2
MIME-Version: 1.0
In-Reply-To: <CAEtw4r1we4ctoTwvExFWwc1WFgtBJXYXOizNZrrzqyBGbHCv-A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: da
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Thanks for the answer.

I had already tried "

btrfs balance start -musage=75 -dusage=75 /mnt

It only reallocated 3 blocks.

But after I had moved some data, I ran it with 90, and it realocated a lot more.

I have a new balance running, and this time it seems to be doing its job. At least data is distributed more evenly across disks.

Its not done yet, but its looking fine.


