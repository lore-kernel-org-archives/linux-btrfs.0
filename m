Return-Path: <SRS0=k9FD=SI=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0B32C10F06
	for <linux-btrfs@archiver.kernel.org>; Sat,  6 Apr 2019 11:37:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 63E6320879
	for <linux-btrfs@archiver.kernel.org>; Sat,  6 Apr 2019 11:37:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kaoqe7Wd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726661AbfDFLh1 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 6 Apr 2019 07:37:27 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:43818 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726646AbfDFLh1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 6 Apr 2019 07:37:27 -0400
Received: by mail-pl1-f193.google.com with SMTP id m10so4466819plt.10;
        Sat, 06 Apr 2019 04:37:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=jCVAcAx5PzL2CkaimkvS9HfyL96u8zDrfg5ykf85oL0=;
        b=kaoqe7Wd5z5Y2uj43KIztiSy8JPnUsvoxmMmIBx39yOrRYMr2zIEq+2kCn+5GlffG2
         gaxpoZLWiTFdyJyLkExL/InV0CV+3iNlcEGWKE4KBWDtJZBsHE/b/EPwCnJvBYYAhl09
         uIGKTm6l7uBbc7uxJvQ6BrC0x/l2nbPuJ6zI5IhYtACjOaannPqxD+IvVj1R7YIQZdgh
         Z9dfkLfTKbwFFWcv8BClz2OoYIXUsEanPT2HJobesUTJ/13xRVkD3qkHTfjTXyVgge/c
         x4syuwzqH1ooCt67FXCaxTRzAcC4BubNKtyv0p43SJpHG2DOMf+9cMVIpKWIMBg/FZHl
         LT5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=jCVAcAx5PzL2CkaimkvS9HfyL96u8zDrfg5ykf85oL0=;
        b=CUimB6G8T8nTySL2Q0WyqgH4WxHt4T0dE5yQF+/Ftf2rN11salkn0RUeA4vy/cdN56
         HAWO4nOuobHhkyydJUK9jXO+pZPZjnl6pHeNKkATPJKhwnnjEQvagP5rHcb7jRkC4orb
         p9p0bK6VMVpvylKYcAh6/2/CnGs2UjG8P1AhZkPGDielfD2oAEu1aoopz8bShycyPJPZ
         zZSNTEoA8Qa6A3ZDWF7OcJFD58s9KHEan/W4y87PReYfHC6Nxp++7KOKyegeDJHK+c2Q
         vpkLzKJXDecXn8xvNiGZ9Qav0dd4Ec0wc7sC32F2DLLeOgRNDyv+IlTqcZbcY8z5Z84T
         KfLA==
X-Gm-Message-State: APjAAAUa1SYBzRXjh5GTeVxu2VA9jwYhdDNvlDm+HUU6Dk9Nx8t/zSEZ
        dW9SK7cJF8ZcfZ8Hv3rf4dk=
X-Google-Smtp-Source: APXvYqy2ptCFfv+RuropRsWF5jnjLh3UhGioRgezS29WszU6BR7zFw82HaanMZ9YTFx4+4rniA/5Ow==
X-Received: by 2002:a17:902:f084:: with SMTP id go4mr17963835plb.235.1554550646313;
        Sat, 06 Apr 2019 04:37:26 -0700 (PDT)
Received: from localhost ([128.199.137.77])
        by smtp.gmail.com with ESMTPSA id t5sm28714996pfh.141.2019.04.06.04.37.23
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 06 Apr 2019 04:37:25 -0700 (PDT)
Date:   Sat, 6 Apr 2019 19:37:18 +0800
From:   Eryu Guan <guaneryu@gmail.com>
To:     Anand Jain <Anand.Jain@oracle.com>
Cc:     fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3] fstests: btrfs verify hardening agaist duplicate fsid
Message-ID: <20190406113718.GF2824@desktop>
References: <1540571900-24768-1-git-send-email-anand.jain@oracle.com>
 <799893ab-763e-7aa7-9e2b-2f1218d29b13@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <799893ab-763e-7aa7-9e2b-2f1218d29b13@oracle.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Apr 02, 2019 at 01:58:23PM +0800, Anand Jain wrote:
> 
> Eryu,
> 
>  This patch isn't integrated yet.

Sorry for missing that, and thanks for reminding! I've applied the
patch. Thanks!

Eryu
