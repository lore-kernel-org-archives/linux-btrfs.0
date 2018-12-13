Return-Path: <SRS0=1olR=OW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A4F7C65BAE
	for <linux-btrfs@archiver.kernel.org>; Thu, 13 Dec 2018 04:07:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D177720811
	for <linux-btrfs@archiver.kernel.org>; Thu, 13 Dec 2018 04:07:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ieU7wt45"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D177720811
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726564AbeLMEHx (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 12 Dec 2018 23:07:53 -0500
Received: from mail-wm1-f41.google.com ([209.85.128.41]:39249 "EHLO
        mail-wm1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726226AbeLMEHx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Dec 2018 23:07:53 -0500
Received: by mail-wm1-f41.google.com with SMTP id f81so892893wmd.4
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Dec 2018 20:07:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=u7CGIwYXPu3l6xCzTjqt0UjAlBRSczFnXY7wDgbmDTw=;
        b=ieU7wt45guOaOW8ynXWWc8Y0m0Pd53hIy3XAM1OcUEMfrC6ZZzKgzPX+M8TW4m6RKB
         4g2ymTof93Su8z6cj8PvjAV5A/Uvw1FFB6otnW4WzwImwgLfSnbyFLA0Lbe02WogbCoC
         wMX23RDIlA9TO0FwivjwGoJVqy9idrx4OkzmSch+a3ZSpmFRdHJijmkxopdyPHHIoSVc
         Wr2nQ76/AvP+wMmpWwUSbrtkidFqMe5KoQmLBfsIm+MdzrFNgRPiMVU5HshBAfE3vzNq
         lpUznLtFtjenWiZuPQUg1s4Be3EYmPrtNpTlpr4bJ2xAjXifrQSKVqEX6DFbUU+Sy6ZL
         tGxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=u7CGIwYXPu3l6xCzTjqt0UjAlBRSczFnXY7wDgbmDTw=;
        b=H8dOd+GCt/B+1TdvNqN2+2mggPoYppav9BTgqZFcjYZaWjhGh9fjnGDQYtNtjL7Ghe
         haZkTCJ7NlJWc8YLFsuuvKNd4spi1F76UELpeUtQhHifDeCRq1wQt1jnhT+3nUsKa/hB
         +ly9oN9ug3tDOtXuhsND7lZBQNxOGRc7s2kNXS9Vry7h4u+nXplS1Bh+qniwJt5QtyMd
         hno7R3ZZ475Zynglb9/ekAinHyXpUuO0sJFlnvePJb89QsJAB8JyY7a3mc63CDA6CURD
         6CpdJ+Z6w8jDJ+YvlVozAS9oTsXoP8YMyr/lf2Ue/q3yV9oWjVp5lq7HC2p4a4BdErJ8
         x1Bg==
X-Gm-Message-State: AA+aEWamaZPiqc0Nzn25+9/wD4FuV2o8Q4wvrH4HKpiGVYX1vfy2wJgo
        bySRptk0+kr/gcnOebRpdYoWXa/a
X-Google-Smtp-Source: AFSGD/XL5W86Gs/R6vk9TbZ64C2MaTeMQB+5rW48VzuMZE+nuSW6yydUEXfZpygD7OW1vVHTTM0/qQ==
X-Received: by 2002:a1c:b515:: with SMTP id e21mr8716392wmf.82.1544674070468;
        Wed, 12 Dec 2018 20:07:50 -0800 (PST)
Received: from [172.16.66.62] ([197.224.37.98])
        by smtp.googlemail.com with ESMTPSA id l197sm2725067wma.44.2018.12.12.20.07.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 12 Dec 2018 20:07:49 -0800 (PST)
From:   Zia Nayamuth <zedestructor@gmail.com>
To:     Nathan Dehnel <ncdehnel@gmail.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: SATA/SAS mixed pool
References: <CAEEhgEtryrEBv-PgZ5VkXEUcmXhx7JCoRrDhyLK5zP0-zOsESw@mail.gmail.com>
Message-ID: <f6fc0cc8-daf7-fc8d-6126-447432a07071@gmail.com>
Date:   Thu, 13 Dec 2018 08:07:46 +0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.3
MIME-Version: 1.0
In-Reply-To: <CAEEhgEtryrEBv-PgZ5VkXEUcmXhx7JCoRrDhyLK5zP0-zOsESw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

I've done it with ZFS and hardraid controllers. I see no reason why 
btrfs should care.

On 2018-12-13 07:31, Nathan Dehnel wrote:
> Is it possible/safe to replace a SATA drive in a btrfs RAID10 pool
> with an SAS drive?
