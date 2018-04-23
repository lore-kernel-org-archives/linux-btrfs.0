Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f177.google.com ([209.85.223.177]:44095 "EHLO
        mail-io0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750766AbeDWEal (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 23 Apr 2018 00:30:41 -0400
Received: by mail-io0-f177.google.com with SMTP id d11-v6so9027567iof.11
        for <linux-btrfs@vger.kernel.org>; Sun, 22 Apr 2018 21:30:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+2BD2fagcPxJbMCxxEVjSFP-kMMdFZF_vaBkvj0LqKoD6TDDg@mail.gmail.com>
References: <CA+2BD2fagcPxJbMCxxEVjSFP-kMMdFZF_vaBkvj0LqKoD6TDDg@mail.gmail.com>
From: Patrick Mitchell <patricklmitchell9@gmail.com>
Date: Mon, 23 Apr 2018 00:30:39 -0400
Message-ID: <CA+2BD2dSekWDcmh-AfFNJjt-+pYVGKijBruD3gcdJn9mEQ=ahg@mail.gmail.com>
Subject: Re: parent transid verify errors, does mount though, how to recover & proceed
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

P. S.  After making partition-level backup to an image file, which
I'll now restore from, tried "btrfs check --repair".  It didn't fix
any of the parent transid errors, only "fix" was "cache and super
generation don't match, space cache will be invalidated".
