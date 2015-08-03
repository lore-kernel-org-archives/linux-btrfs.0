Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f44.google.com ([209.85.213.44]:34312 "EHLO
	mail-vk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753741AbbHCTGz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Aug 2015 15:06:55 -0400
Received: by vkca124 with SMTP id a124so45935889vkc.1
        for <linux-btrfs@vger.kernel.org>; Mon, 03 Aug 2015 12:06:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CACsECNdE3zQbHAZstKoZNrqhRVE2Bxj27oTnhOGquzGvY0Eoig@mail.gmail.com>
References: <CACsECNfH3Nc8eTWjmLAiCZ_h1T79A8MwN7PPPQnEGcVL9xBeRw@mail.gmail.com>
	<CACsECNdE3zQbHAZstKoZNrqhRVE2Bxj27oTnhOGquzGvY0Eoig@mail.gmail.com>
Date: Mon, 3 Aug 2015 13:06:54 -0600
Message-ID: <CAJCQCtTPDfzDEDOOpDiiNAOi7sPw3Nj5tRV4TF=uuH1sngiD1A@mail.gmail.com>
Subject: Re: Bug report - btrfs hanging
From: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 3, 2015 at 12:09 PM, Alex <alexinbeijing@gmail.com> wrote:

> 20:03 ~ % uname -a
> Linux alex-ThinkPad-L530 4.1.0-rc3+ #2 SMP Sun Jul 5 22:24:05 CAT 2015
> x86_64 x86_64 x86_64 GNU/Linux

4.1.0 is not mainline anymore, so I don't see a mid release candidate
of it being relevant because those rc's become "old" inside of a
couple weeks. I suggest using 4.1.4 which is the current stable
version of that series, and it has quite a few Btrfs patches.

4.2.0rc5 is current mainline and you could test against that too if you wish.


-- 
Chris Murphy
