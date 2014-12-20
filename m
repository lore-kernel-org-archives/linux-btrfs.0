Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f181.google.com ([209.85.192.181]:37268 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316AbaLTCHy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Dec 2014 21:07:54 -0500
Received: by mail-pd0-f181.google.com with SMTP id v10so2277589pde.12
        for <linux-btrfs@vger.kernel.org>; Fri, 19 Dec 2014 18:07:53 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 19 Dec 2014 18:07:53 -0800
Message-ID: <CACyXjPwb-G3BkW6i7X5K3q5w4Fm8GhYt198KKzX3kqpioUKgxA@mail.gmail.com>
Subject: Can BTRFS handle XATTRs larger than 4K?
From: Richard Sharpe <realrichardsharpe@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi folks,

I need a Linux file system that supports XATTRs up to 64K.

Can BTRFS support that or is XFS the only Linux file system with such support?

-- 
Regards,
Richard Sharpe
(何以解憂？唯有杜康。--曹操)
