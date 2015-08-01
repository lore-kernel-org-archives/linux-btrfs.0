Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f53.google.com ([209.85.213.53]:36198 "EHLO
	mail-vk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115AbbHAR3l (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 1 Aug 2015 13:29:41 -0400
Received: by vkci6 with SMTP id i6so31176423vkc.3
        for <linux-btrfs@vger.kernel.org>; Sat, 01 Aug 2015 10:29:41 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 1 Aug 2015 11:29:40 -0600
Message-ID: <CAJCQCtQJpEVPk_qAUj68qRxoftUyPww0Pm0aYHhkaM51+uOO=g@mail.gmail.com>
Subject: ext4 convert bugs, wiki warning?
From: Chris Murphy <lists@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Does someone with wiki edit capability want to put up a warning about
btrfs-convert problems? I don't think it needs to be a lengthy write
up since the scope of the problem is not clear yet. But since there's
definitely reproduced problems that have been going on for some time
now maybe it'd be a good idea to put up a warning until this is more
stable?

I'm thinking of just a yellow warning "sidebar" like thing that maybe
just says there's been a regression and it's breaking file systems,
sometimes irreparably?


-- 
Chris Murphy
