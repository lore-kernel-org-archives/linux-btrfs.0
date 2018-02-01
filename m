Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f47.google.com ([209.85.218.47]:38267 "EHLO
        mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751715AbeBAVkj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 1 Feb 2018 16:40:39 -0500
Received: by mail-oi0-f47.google.com with SMTP id j15so11378376oii.5
        for <linux-btrfs@vger.kernel.org>; Thu, 01 Feb 2018 13:40:38 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CALvFGyCYKs_MMB5st-nm463_UBcA859iBDHX8xjRX8eCME7Ytw@mail.gmail.com>
References: <CALvFGyCYKs_MMB5st-nm463_UBcA859iBDHX8xjRX8eCME7Ytw@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Thu, 1 Feb 2018 14:40:37 -0700
Message-ID: <CAJCQCtQQAa1wSPSrw34iYMRE=NijpaTOpTmywY=Et7G=uCEPCg@mail.gmail.com>
Subject: Re: btrfs - kernel warning
To: Patrik Ostrihon <patrik.ostrihon@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Oh and to be super clear, do not use --repair with 'btrfs check' until
there's a dev recommendation to try it. It should be safe, but is
still sometimes fragile in the multiple device case.


---
Chris Murphy
