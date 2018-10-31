Return-Path: <SRS0=X8W1=NL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56A10C0044C
	for <linux-btrfs@archiver.kernel.org>; Wed, 31 Oct 2018 18:48:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DCB392081B
	for <linux-btrfs@archiver.kernel.org>; Wed, 31 Oct 2018 18:48:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=libero.it header.i=@libero.it header.b="jf8Sy9+5"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DCB392081B
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=libero.it
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730654AbeKADr3 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 31 Oct 2018 23:47:29 -0400
Received: from smtp-31-i6.italiaonline.it ([213.209.14.31]:34814 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730647AbeKADr3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 31 Oct 2018 23:47:29 -0400
Received: from venice.bhome ([94.38.190.186])
        by smtp-31.iol.local with ESMTPA
        id HvXFghEN3y5nZHvXFgVeXd; Wed, 31 Oct 2018 19:48:09 +0100
x-libjamoibt: 1601
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=libero.it; s=s2014;
        t=1541011689; bh=AyWWkMrlGseCWW23QuUO88MWbFm1pn+7Q0meYHFrPiM=;
        h=Reply-To:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=jf8Sy9+5AvBhUg3mqH1f2tiJSGrDoKyykSV5+dfk49ZrJOSi3ZxLGB+o5CzsYncrs
         eMJsFNk5wvBu6wTtNwZ/QpnLVCAk/zSEvE/ckqB+0ja/3nLbt66iq7nKxxk5A5L34H
         29V3f73rGwrsyXbhiPsFmCgjkcTbBGSAmek7f5BPfj4kb9VlJkly3twFgJtfjoY29B
         +JpFyvh/4LS3mUspohwVZ6imbFws7NVV9ps6EL3NlxiMkPAgD4Xyat0kPn3NIU+0vs
         PCSkDVZXr6xKlo/UaCC7Kekv4yoHKTCYje6zrj0ETcDB4IRTmITFs+bnMFJG9ZENEw
         Cv9toW8y4WXWw==
X-CNFS-Analysis: v=2.3 cv=T+ddsMCQ c=1 sm=1 tr=0
 a=Z2/BCD3YYo5x+DFFvTHCfA==:117 a=Z2/BCD3YYo5x+DFFvTHCfA==:17
 a=IkcTkHD0fZMA:10 a=hX1rdf5SwghmsjxBXREA:9 a=QEXdDO2ut3YA:10
Reply-To: kreijack@inwind.it
Subject: Re: [PATCH V10] Add support for BTRFS raid5/6 to GRUB
To:     Daniel Kiper <dkiper@net-space.pl>
Cc:     Nick Terrell <terrelln@fb.com>,
        "grub-devel@gnu.org" <grub-devel@gnu.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <20181018175541.9532-1-kreijack@libero.it>
 <20181022110245.GB12705@router-fw-old.i.net-space.pl>
 <2F6AF0F1-DD4A-4406-9319-431CB1783BF5@fb.com>
 <20181031120623.GA13223@router-fw-old.i.net-space.pl>
From:   Goffredo Baroncelli <kreijack@libero.it>
Openpgp: preference=signencrypt
Autocrypt: addr=kreijack@libero.it; prefer-encrypt=mutual; keydata=
 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
Message-ID: <71116ba1-997d-44ed-54fa-4b6eff5d8cdd@libero.it>
Date:   Wed, 31 Oct 2018 19:48:08 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20181031120623.GA13223@router-fw-old.i.net-space.pl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfBjM0NDTHDdV4Zgf1oJWsBhk2xVqAUXdUjM4Z3LO2u1xnRDGwJGK5N4AOslEa8XZvARNAHumLpNrz75XsUbWyozCu/m8P8k2YlJxiDLxTCvYzJ49TTip
 +qrWdy7HlAvpATwl5K/nNAVlAhMOWYF1TGTcoY3BkJZ9PpprZTHQ4EZbE1BVePNEWFNnTs/fbImmmgrHDbV2gXhkYB207hRva+siGSNyfsSoc3DG4ExdjALE
 Ej4i0KzJvO8xGZuosIS6zOIquY6phfM/mbRPFmNiTQY=
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 31/10/2018 13.06, Daniel Kiper wrote:
[...]
> 
> v11 pushed.
> 
> Goffredo, thank you for doing the work.

Great ! Many thanks for your support !!

> 
> Nick, you can go ahead and rebase yours patchset.
> 
> Daniel
> 

BR
G.Baroncelli
-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
