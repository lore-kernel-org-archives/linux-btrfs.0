Return-Path: <SRS0=zp8L=SK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D664EC10F13
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Apr 2019 12:44:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A029C20883
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Apr 2019 12:44:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="X7W/JfUS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726573AbfDHMoH (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 8 Apr 2019 08:44:07 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:37252 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbfDHMoH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Apr 2019 08:44:07 -0400
Received: by mail-io1-f65.google.com with SMTP id x7so10876967ioh.4
        for <linux-btrfs@vger.kernel.org>; Mon, 08 Apr 2019 05:44:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=US1OQBUvsSjEYSU8AjED3ClvzZmaB++kJa8uwLWz1pg=;
        b=X7W/JfUSIYEVhD/xwJ9LQwwV2O/ceUDYleqtlY4wvesipkrxgsoKwYvKry90x6jPEP
         mpDZKiH1dIL5w8w5vNXN/kb+woDMk/9rIFckdtFZAFIFC8+F/ADgfZfA6jnEkO6QiNGn
         sWub5L/AZCdpijChEXcRbERFKkLiAkVyU/nQO4jDSZ6jzoZ9HPz5jUVTSPn9ED1DDwUl
         mpF7WKIaN1vYiT1Ic72cmMXAplY3UyyXtQGLS1ZLNBrWzrQ9CcufzthMBAs8iG53qiP5
         EUL+SSviQo79Oc5qL74i+MVt5i/Ep1xQOApxheSEP1Vbw8T7rHqFt8RAjAQMrXBaWe28
         QL0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=US1OQBUvsSjEYSU8AjED3ClvzZmaB++kJa8uwLWz1pg=;
        b=P1CmndxWq94mw0YAxGsm8qXmpD7JfO3IjTidpptqu+d1+UeSSvDwwi0v5FuPwoo+Gp
         NXsZeOUXw0nOed78yGc7ZCUIW4N+upapxMEzFDLgz4AV01fq9mNWWyaIwI6nvBNdro2M
         P778cga928Wdd+8Nm89Jvm2wJDErXsjYwD9Lm7zTEGGUNoXOhu859HCqkoFGVVTdsxlX
         o287JwJI7aA3M0Zt87LK8NFpEsfjZ2hTL/xJOeHEeVj0b5lRfaIQen+hXBfR7jMdNXX+
         5bJuyCHUQhOXDI5MlurkvhtAU23AzUyHUBzj2TR0HtwhLK0A7CYsnQlFmrQHgdKBFSUP
         SjwQ==
X-Gm-Message-State: APjAAAUz0/FcnIFvWiyUM4iGYivUMOzD0d3LUS7PNYyeGy3Gs3Oc2xaa
        WesDqjBmxkfx3IkiXAHBAyiaH6lEZ+k=
X-Google-Smtp-Source: APXvYqwfHZJqFTe4nD53zR249lweWoNueoV6sc5Gguv+/2Cl8pwj8pquZu0KkVopgEi4mMCEz/XjuQ==
X-Received: by 2002:a5d:9a8d:: with SMTP id c13mr1743626iom.195.1554727446255;
        Mon, 08 Apr 2019 05:44:06 -0700 (PDT)
Received: from [191.9.209.46] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by smtp.gmail.com with ESMTPSA id v10sm11061775iob.30.2019.04.08.05.44.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Apr 2019 05:44:05 -0700 (PDT)
Subject: Re: Cryptographically verifying a btrfs subvolume
To:     Leonid Bloch <lbloch@janustech.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Cc:     "bo.li.liu@oracle.com" <bo.li.liu@oracle.com>
References: <adac7db8-aed6-9573-ec09-4acd5059801e@janustech.com>
From:   "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <25abc057-4ff8-5a73-ee4b-0afda4fab16d@gmail.com>
Date:   Mon, 8 Apr 2019 08:44:03 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <adac7db8-aed6-9573-ec09-4acd5059801e@janustech.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 2019-04-08 07:27, Leonid Bloch wrote:
> Hi List,
> 
> Can you suggest a way of cryptographically verifying the content of a
> btrfs subvolume, besides the naïve approach, of running a cryptographic
> hash function on the output of btrfs send?
Running BTRFS on top of dm-integrity and dm-crypt with them set up to 
provide AEAD-style encryption comes to mind as an option, and would 
actually provide a much higher level of verification than just verifying 
the content of a subvolume (it will verify the entire filesystem).
> 
> Back in 2014, an RFC patch was sent to allow using sha256 instead of
> crc32c for checksumming.
> (https://patchwork.kernel.org/patch/5363311)
> It was not merged. Had it been merged, one could just check the return
> value of btrfs scrub, instead of checksumming the whole btrfs send
> output, correct?
In theory yes, provided you just want hashes and not an HMAC.
