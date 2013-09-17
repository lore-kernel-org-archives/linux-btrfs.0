Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ve0-f172.google.com ([209.85.128.172]:35651 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753492Ab3IQSxt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Sep 2013 14:53:49 -0400
Received: by mail-ve0-f172.google.com with SMTP id oz11so4708644veb.31
        for <linux-btrfs@vger.kernel.org>; Tue, 17 Sep 2013 11:53:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <523873FC.20504@mur.at>
References: <5236E1FF.4080900@mur.at>
	<5238343F.3020802@mur.at>
	<20130917111809.GA16032@panda>
	<52384A08.40404@mur.at>
	<523873FC.20504@mur.at>
Date: Tue, 17 Sep 2013 14:53:48 -0400
Message-ID: <CAFvQSYS7U6VdYeUa-BocBq2tgQuyg1Z_eqpO=6UkcER2a1_p-g@mail.gmail.com>
Subject: Re: rootfs crash
From: Clemens Eisserer <linuxhippy@gmail.com>
To: =?UTF-8?Q?Jogi_Hofm=C3=BCller?= <jogi@mur.at>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Jogi,

When I tried to recovered a broken btrfs-parition, I encountered the
same errors you did - btrfs restore seems to be a bit broken.

What helped was to:
a. comment out the free()-calls which led to crashes
b. re-run "btrfs restore" to account for the crashes which happen
elsewhere, hopefully it will progress each run a little further as it
did for me.

Regards, Clemens
