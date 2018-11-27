Return-Path: <SRS0=/x7k=OG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8622C43441
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 15:39:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7B46C20873
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 15:39:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="W/+NGtf1"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7B46C20873
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730086AbeK1Ch2 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 27 Nov 2018 21:37:28 -0500
Received: from mail-yb1-f194.google.com ([209.85.219.194]:34986 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729099AbeK1Ch2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Nov 2018 21:37:28 -0500
Received: by mail-yb1-f194.google.com with SMTP id z2-v6so9227898ybj.2
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Nov 2018 07:39:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=S6Elp4NFfke0QQsoPwhcn/h0p0nd+i9ekx1HTW9boiA=;
        b=W/+NGtf1OEHvH5oIgR3imraBxpHP0L9KbmMaaZBc8qJamakUXOuAkXxZnHQUgIR8nk
         wTeYOVokBVvKhILzJEEp5BtZR3puneSxY+1j81aXkuQDoDp8zu/da7KVy67mKu1402hG
         MC4MElOkP/qPUjuO9mrJgEtEwYhOopkgPluJ4QYKr7X3q96kYHpTUyb+nmeUvMtavoP9
         l4Z90n2Pwlw6c/LkfMkAQvG+dv96K4v6u/tbW/I5PHhr9w0WtZfoSOn/41wukA/AaIhP
         UTt0V7Is9TwCwGsL1MOPJqEWGxUALNbyp2/tnzSJKhiYoOybMp/zHzhaMrXkurWNvySo
         jWyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=S6Elp4NFfke0QQsoPwhcn/h0p0nd+i9ekx1HTW9boiA=;
        b=B/9REwB1CU45gwjNSCf9scwxOk0nXsRrf1Fxp2ToTFp2GxQ3xquF1NOreAXpzsnxuB
         sy72ruVBvEIYqhLnStCGqwAQrt3+7ZEIo/P4XOH6xZeSpaeXDceFOMOPBs8IHLjV2wlt
         pt1ISNrGTrNS3uHlRqSVEnQiiOTFTuxjGZvNSlpakBOhMt/ZmSKbP6m2ePEYehVAawpI
         uCtOzwyskflzKS4klZqh5uYQ5Wz22C2VQb+/TfUDBsKe1gFNLwpe5jDXkVbCHj94ctwJ
         Td0ATrrBfYAhgX+aAgAWPzRVY3Fw+HUh+MTvco/JmyUIkYGrdPVFw1M7V3JCv/hLaOdq
         3BOg==
X-Gm-Message-State: AA+aEWboDjEmokFGqalZvLpQqzjiXvOPDqOPGIZ55bbxfXQP8zwNBvoo
        fiptzC+SUD4jgl7Iepye2MiBqQ==
X-Google-Smtp-Source: AFSGD/WVRncgy7XwNlKIJLzFH8fXceke9mlqXEONSRYPaMx37nZzLov6eog/TSk/4ivqR0tOBoqssQ==
X-Received: by 2002:a25:7811:: with SMTP id t17-v6mr32789144ybc.479.1543333150298;
        Tue, 27 Nov 2018 07:39:10 -0800 (PST)
Received: from localhost ([2620:10d:c091:180::1:6a02])
        by smtp.gmail.com with ESMTPSA id u4sm3115191ywl.29.2018.11.27.07.39.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Nov 2018 07:39:09 -0800 (PST)
Date:   Tue, 27 Nov 2018 10:39:08 -0500
From:   Josef Bacik <josef@toxicpanda.com>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com, Josef Bacik <jbacik@fb.com>
Subject: Re: [PATCH 3/6] btrfs: cleanup extent_op handling
Message-ID: <20181127153907.g24qgcvewplzlpun@macbook-pro-91.dhcp.thefacebook.com>
References: <20181121185912.24288-1-josef@toxicpanda.com>
 <20181121185912.24288-4-josef@toxicpanda.com>
 <c292598c-233c-09aa-7674-42a3eca8830c@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c292598c-233c-09aa-7674-42a3eca8830c@suse.com>
User-Agent: NeoMutt/20180716
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Nov 22, 2018 at 12:09:34PM +0200, Nikolay Borisov wrote:
> 
> 
> On 21.11.18 г. 20:59 ч., Josef Bacik wrote:
> > From: Josef Bacik <jbacik@fb.com>
> > 
> > The cleanup_extent_op function actually would run the extent_op if it
> > needed running, which made the name sort of a misnomer.  Change it to
> > run_and_cleanup_extent_op, and move the actual cleanup work to
> > cleanup_extent_op so it can be used by check_ref_cleanup() in order to
> > unify the extent op handling.
> 
> The whole name extent_op is actually a misnomer since AFAIR this is some
> sort of modification of the references of metadata nodes. I don't see
> why it can't be made as yet another type of reference which is run for a
> given node.
> 

It would change the key for a metadata extent reference for non-skinny metadata,
and it sets the FULL_BACKREF flag.  Since it really only changes flags now we
could probably roll that into it's own thing, but that's out of scope for this
stuff.  Thanks,

Josef
