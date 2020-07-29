Return-Path: <SRS0=lAVn=BI=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.4 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5606BC433DF
	for <linux-btrfs@archiver.kernel.org>; Wed, 29 Jul 2020 13:52:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3496322D72
	for <linux-btrfs@archiver.kernel.org>; Wed, 29 Jul 2020 13:52:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=render-wahnsinn.de header.i=@render-wahnsinn.de header.b="ZtS7dGGY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726979AbgG2Nwq (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 29 Jul 2020 09:52:46 -0400
Received: from mail.render-wahnsinn.de ([176.9.123.116]:44444 "EHLO
        mail.render-wahnsinn.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726336AbgG2Nwp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 29 Jul 2020 09:52:45 -0400
X-Greylist: delayed 376 seconds by postgrey-1.27 at vger.kernel.org; Wed, 29 Jul 2020 09:52:45 EDT
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id C58CB4B0A3
        for <linux-btrfs@vger.kernel.org>; Wed, 29 Jul 2020 15:46:27 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=render-wahnsinn.de;
        s=dkim; t=1596030387; h=from:subject:date:message-id:to:mime-version:content-type:
         content-transfer-encoding:in-reply-to:references;
        bh=gLTa/2t95Jnc8jkjve887RlHwa7DoISJ3JKEULSB8+M=;
        b=ZtS7dGGYNvCu5kDRwBykYrr1v5fq/CB0Lppnpd+y7BfZ18rwfh1MT9Knbu+5w84P4m3IK8
        NWvHElSASLjNFApn4FtPXC5sopUNihyLSuftJICxmMSzLEo23GGRbMVoD2uexZymlws+MQ
        d81hQgJAJ6VLjLMullvbnJ3w7e6V22mYUZi77/vuBoqYNKRWKUTW1AvHNIeA/MJKV3eCTW
        fctkr4eDgKc7QL6DNZ0jrR9tfvizZnme2AUAYEOGbIB85nM8I1ecwd7PNoz578i6jfk4h1
        mZBrAVhDsM+3t5hCdV8gPzd8WHoWcdvO1vMdZ0Cv+44Nblt8NeJKrGqGv89ONg==
Subject: Re: using btrfs subvolume as a write once read many medium
To:     linux-btrfs@vger.kernel.org
References: <VI1PR02MB58697B26A91E68507032D9CDAE700@VI1PR02MB5869.eurprd02.prod.outlook.com>
From:   Robert Krig <robert.krig@render-wahnsinn.de>
Message-ID: <024b267e-d4aa-59bb-4b0c-10b807218bdf@render-wahnsinn.de>
Date:   Wed, 29 Jul 2020 15:46:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <VI1PR02MB58697B26A91E68507032D9CDAE700@VI1PR02MB5869.eurprd02.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Last-TLS-Session-Version: TLSv1.3
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 29.07.20 09:02, spaarder wrote:
> Hello,
>
> With all the ransomware attacks I am looking for a "write once read
> many" (WORM) solution, so that if an attacker manages to get root
> access on my backup server, it would be impossible for him to
> delete/encrypt my backups.
>
> Using btrbk I already have readonly daily snapshots on my backupserver.
> Is there any way to password protect the changing of the properties of
> these subvolumes, so an attacker could not just simply set the RO
> property to false? Any support for a feature request?
>
> Big thanks for this MAGNIFICENT filesystem!!
>
>

If an attacker gets root access to your server, then there is not much 
you can do to prevent them from deleting backups. Your best protection 
against something like that is backing up to multiple destinations.

