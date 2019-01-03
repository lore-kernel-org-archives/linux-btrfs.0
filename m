Return-Path: <SRS0=cNHg=PL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47A52C43387
	for <linux-btrfs@archiver.kernel.org>; Thu,  3 Jan 2019 09:46:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 11FFC206BB
	for <linux-btrfs@archiver.kernel.org>; Thu,  3 Jan 2019 09:46:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AleUPyZl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730563AbfACJqy (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 3 Jan 2019 04:46:54 -0500
Received: from mail-lj1-f169.google.com ([209.85.208.169]:42935 "EHLO
        mail-lj1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728309AbfACJqx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Jan 2019 04:46:53 -0500
Received: by mail-lj1-f169.google.com with SMTP id l15-v6so29189903lja.9
        for <linux-btrfs@vger.kernel.org>; Thu, 03 Jan 2019 01:46:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=wBw1JSxI5wrpT9lLL2ykZdo+1mzWizqp9YOZE3IW1HM=;
        b=AleUPyZlMExJNUifgubYTM/ku+EiTRYS7hTmQKr6AN+3WWVwfCS3bAV7roWjXu2/g7
         3GW/yCernB4pnz92k1NWkLczUF2DgNowb8Qd9EbLhn7N2ECaANVL1CinE+rzqEIg54nw
         7rVpRtoKgijysHg/1/lQlBJ7SDN2B3twOzNrde8GaevwXw8SbtdyIA3rtRQXLDM7ckFn
         J/M9e0XtrpuX/kOY6xitg504V+hzPjF90ogDmXZD9fIp5P1aIsAv5286ZluBsuQaScd3
         k5Ll2VK+FquGG7YA0Pkwn3BgI9N00Ljs5IiedBaaK02U42/usnqFudVAWBlvgFwiXqsi
         l6FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=wBw1JSxI5wrpT9lLL2ykZdo+1mzWizqp9YOZE3IW1HM=;
        b=UmVubAujHtrvTFmw2mmB9Guppp+dujyUHHVRd6lpFx98W+HH2RXIX4AzO0ouROI3Ru
         uiWNq0g8ME/oop1GAgJ412R9SHT82srK6ZBsdMa8iUrqLLa5Ax5KWkd1F8hxC6jL0thS
         AE1GdiCYXwjG4h5v6jvlwIAEDdXIsTZY/vmzyKizYq5erOGegzpCjTfGT7zVqhH6a/KC
         GUyeTvEhkauwM6P1wSWebjCxGbmhZ0U2E8HSEXENfDyg8vJKs8RGmBUeU19V0FPoHDK+
         /t1p7CoUYB+WbEFkcOdOBLzrziVzQB47BLeg78nmqQ/HlemTuZXOQa1p2nV89wMAwILh
         njyw==
X-Gm-Message-State: AJcUukf0/hQtJa4Ec4+QqUW7hgK+ZcuSIOmk08xEMwVn+avBRnyArs36
        VwSW/I0agZUjnrrny89I5Lo=
X-Google-Smtp-Source: ALg8bN5tIbRjaU5dUHIlGuY0urFp64n8eVDEIHaGBeACFE+xKnbQwH7aj8GjidFvv5FRAVnB8ALTmg==
X-Received: by 2002:a2e:9c52:: with SMTP id t18-v6mr21835316ljj.149.1546508811371;
        Thu, 03 Jan 2019 01:46:51 -0800 (PST)
Received: from glet (anon-39-149.vpn.ipredator.se. [46.246.39.149])
        by smtp.gmail.com with ESMTPSA id 6sm11593399lfa.27.2019.01.03.01.46.50
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 03 Jan 2019 01:46:50 -0800 (PST)
Date:   Thu, 3 Jan 2019 10:46:47 +0100
From:   Andrea Gelmini <andrea.gelmini@gelma.net>
To:     Tomasz Chmielewski <tch@virtall.com>
Cc:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        b11g <b11g@protonmail.com>
Subject: Re: BTRFS corruption: open_ctree failed
Message-ID: <20190103094647.GA10578@glet>
References: <155a0e09f60a0605802c459a6e119b36@virtall.com>
 <20190103072740.GA64625@glet>
 <b5df9ec049da6ecd9a4b3617d39d795f@virtall.com>
 <20190103082213.GA74697@glet>
 <ec02023516764c490fdb2fad5f409da5@virtall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ec02023516764c490fdb2fad5f409da5@virtall.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

My last email on this thread: I swear.

I don't want to bother the mailing list about this more.

On Thu, Jan 03, 2019 at 05:29:51PM +0900, Tomasz Chmielewski wrote:

> I could see filesystem corruption on every system using with PPA 4.19 lower
> than .8. Didn't do any kernel boot parameter changes when upgrading from
> 4.18.

gelma@check:~$ uname -a # to use a broken kernel
Linux check 4.19.6-041906-generic #201812030857 SMP Mon Dec 3 13:59:30 UTC 2018 x86_64 x86_64 x86_64 GNU/Linux
gelma@check:~$ lsb_release -a
No LSB modules are available.
Distributor ID: Ubuntu
Description:    Ubuntu 18.04 LTS
Release:        18.04
Codename:       bionic
gelma@check:~$ dmesg|grep -i scheduler
[    1.062769] io scheduler noop registered
[    1.062993] io scheduler deadline registered
[    1.063257] io scheduler cfq registered (default)

But also just having set "none" is not enough.
To trigger it you must force multiqueue.

I usually compile the git kernel, but I destroyed the
fs only when I added:

scsi_mod.use_blk_mq=1

on boot kernel.

Details here:
https://bugzilla.kernel.org/show_bug.cgi?id=201685

Ciao,
Gelma
