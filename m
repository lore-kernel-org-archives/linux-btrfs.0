Return-Path: <SRS0=vb8r=PN=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AA66C43387
	for <linux-btrfs@archiver.kernel.org>; Sat,  5 Jan 2019 01:26:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F3BC321871
	for <linux-btrfs@archiver.kernel.org>; Sat,  5 Jan 2019 01:26:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mokrynskyi.com header.i=@mokrynskyi.com header.b="s/4D1u8A"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726212AbfAEB0i (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 4 Jan 2019 20:26:38 -0500
Received: from mx.mokrynskyi.com ([46.4.12.50]:38982 "EHLO mx.mokrynskyi.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725862AbfAEB0i (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 4 Jan 2019 20:26:38 -0500
Received: from localhost (localhost [127.0.0.1])
        by mx.mokrynskyi.com (Postfix) with ESMTP id D96FA2A46
        for <linux-btrfs@vger.kernel.org>; Sat,  5 Jan 2019 01:26:36 +0000 (UTC)
Authentication-Results: mx.mokrynskyi.com (amavisd-new);
        dkim=pass (1024-bit key) reason="pass (just generated, assumed good)"
        header.d=mokrynskyi.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mokrynskyi.com;
         h=content-transfer-encoding:content-language:content-type
        :content-type:in-reply-to:mime-version:user-agent:date:date
        :message-id:organization:from:from:references:to:subject
        :subject; s=dkim; t=1546651596; x=1547515597; bh=zQ8+C61wc2dhhlP
        EqWw23CMSA/GY4qG+5e2wwPuL65Y=; b=s/4D1u8AhSW1iMIttELP3Lw6md3fz50
        gcrungbYKI+eyUAzCltBEv4zlcDlvNKTIq4bM3DBtcSGSUgn10+KcG+JDroHEW5A
        kNuaqEjvFPPEz3Z2Q6u3SN0CjbnOMEImTqyQkDn6bZH2qOSi6GzAjBm4LzcoR+EO
        UhYDT6okSwlg=
X-Virus-Scanned: Debian amavisd-new at mx.mokrynskyi.com
Received: from mx.mokrynskyi.com ([127.0.0.1])
        by localhost (mx.mokrynskyi.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id UNv-MLZXxCte for <linux-btrfs@vger.kernel.org>;
        Sat,  5 Jan 2019 01:26:36 +0000 (UTC)
Received: from [192.168.1.2] (bomann.znet.kiev.ua [176.122.88.128])
        by mx.mokrynskyi.com (Postfix) with ESMTPSA id 579FE2A3E;
        Sat,  5 Jan 2019 01:26:36 +0000 (UTC)
Subject: Re: Unrecoverable btrfs corruption (backref bytes do not match extent
 backref)
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Chris Murphy <lists@colorremedies.com>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>
References: <73e828f0-057c-830e-a6b2-570dccbdf484@mokrynskyi.com>
 <CAJCQCtTJEc8q8hrBG_HRvm1vWQvs5KgcFUKfvXPjxTNZSjd-Sg@mail.gmail.com>
 <aca3ce08-2cc6-9ace-ec3f-a9d963b4dab8@gmx.com>
 <720cad6c-776b-109d-f204-fd94942bfa7c@mokrynskyi.com>
 <6c249b1c-446e-a43b-ea9b-606bfff7cc88@gmx.com>
From:   Nazar Mokrynskyi <nazar@mokrynskyi.com>
Organization: CleverStyle, Ecoisme
Message-ID: <631efcf9-e66a-e464-6137-3a4de7eb662f@mokrynskyi.com>
Date:   Sat, 5 Jan 2019 03:26:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:65.0) Gecko/20100101
 Thunderbird/65.0
MIME-Version: 1.0
In-Reply-To: <6c249b1c-446e-a43b-ea9b-606bfff7cc88@gmx.com>
Content-Type: text/plain; charset=utf-8
Content-Language: uk
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

05.01.19 03:18, Qu Wenruo =D0=BF=D0=B8=D1=88=D0=B5:
> Please don't mount the fs RW, and copy your data out.

I have regular automated backups and wrote initial message from restored =
system already, lesson learned a long time ago.

Next time I'll be smarter and will make partition image prior to doing an=
y operations on it, maybe `balance` did something to it.

It is quite unfortunate that information provided is not useful this time=
. If there any other ideas for tests to run - I'm willing to help.

