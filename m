Return-Path: <SRS0=9zVn=MX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87C96C28CF8
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 22:36:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1AAD420835
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 22:36:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="w+Ieg9bz"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1AAD420835
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=colorremedies.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726568AbeJLGFs (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 12 Oct 2018 02:05:48 -0400
Received: from mail-lf1-f47.google.com ([209.85.167.47]:39178 "EHLO
        mail-lf1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725913AbeJLGFs (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 Oct 2018 02:05:48 -0400
Received: by mail-lf1-f47.google.com with SMTP id w21-v6so7916839lff.6
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Oct 2018 15:36:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:sender:in-reply-to:references:from:date:message-id
         :subject:to:cc;
        bh=aEk80ntt4J+8akfk2D5fRpnjQlFZTQmfNscCutN0GnA=;
        b=w+Ieg9bziZTvVyQny/eolAAf6dD5VxrBtGUW74odVoHsFK1C0/CVIGoJ16VdGKi/mp
         yAvJzu/M4n+6PkC9tfAtzJeiW3HXl0XkvX0+BFJjpKkWU5ZrBfFJXgQnJBstZCahaIgH
         fYTGJKVS2F0tvulmjVWkl34+BkakPa0CFLY03H2bqEeKgg5+o9ZJaokOIBNSLyEMoQtq
         7S86PC7rbj6zX6HE1w54mRCcEGaIeCP2nUE+d+/lMANe6ruYshpwoUmg1dQE/Zfi2LaG
         p5pZHdcpoNPcAdRKyPmEQGa0HY7+iJR/XJdThycoVxFDge2tFj4Se9kWceDXylgeWEVv
         HUCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:sender:in-reply-to:references:from
         :date:message-id:subject:to:cc;
        bh=aEk80ntt4J+8akfk2D5fRpnjQlFZTQmfNscCutN0GnA=;
        b=Bhg/1m2GP/R/+5Y6tFbG9tjqQVxTbldWxYvzlYLLq5Abazx22t7RlmFw2o/2PWh3gB
         2JQhmO9MO8aNkcX5WH3kzIWt1TzhECQOG6syKEzhMZalxnpsTsjURi/WLdNVhY17USW+
         r01EjZH43d+/WuwUs9n9Vi1q6UerjJTv1silbQwHCTF4g+xaR7vBBVhNFRajcREg4XhO
         ryMQFTlm6pcjLXMq2B6o6c+k7ymOid0sCjOpPpTFxZNmRF9bZlPd7uJ7pssgVDjuRHQX
         UWVtQPFpLOMOY+EY8AmS0R3mdGdfx4vVCXu3z/h8x/TwHFYIYszCEiO5faN22XjcuzEq
         voaA==
X-Gm-Message-State: ABuFfoj4RVxQozxlNSG2w7A2D7abUngcFcQgizFAl+MDPcpHmyi7g81h
        yk4l8aT8sjmH0g1Uako8k+UUhkEpUjmZYKvaujPrXkf3
X-Google-Smtp-Source: ACcGV60g9Pd4w+w4FsS9jm4hzD/ryK2/4NBTjwNpM+GvSP5VcfpuzpGD/c6I4gSgJ4/RTV61OKzWWdbS17BeQS407cc=
X-Received: by 2002:a19:1447:: with SMTP id k68-v6mr2173258lfi.4.1539297385583;
 Thu, 11 Oct 2018 15:36:25 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ab3:1999:0:0:0:0:0 with HTTP; Thu, 11 Oct 2018 15:36:25
 -0700 (PDT)
X-Originating-IP: [69.7.113.20]
In-Reply-To: <4610292ca252e23c9da2791ae1acf194@t-5.eu>
References: <4610292ca252e23c9da2791ae1acf194@t-5.eu>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Thu, 11 Oct 2018 16:36:25 -0600
X-Google-Sender-Auth: ixrI_ynnU8cQ14T1-bNoNzs0RwY
Message-ID: <CAJCQCtRoN=0oQyiwOPhkO6ZwqQL+Qjsm_mue8aoMWPsg2b7OQQ@mail.gmail.com>
Subject: Re: errors reported by btrfs-check
To:     =?UTF-8?Q?J=C3=BCrgen_Herrmann?= <t-5@t-5.eu>
Cc:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

What version of btrfs-progs?
