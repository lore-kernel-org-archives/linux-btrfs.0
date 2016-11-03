Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f47.google.com ([209.85.215.47]:33540 "EHLO
        mail-lf0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757745AbcKCOVU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Nov 2016 10:21:20 -0400
Received: by mail-lf0-f47.google.com with SMTP id c13so39777366lfg.0
        for <linux-btrfs@vger.kernel.org>; Thu, 03 Nov 2016 07:21:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <06d901d235dc$ee308480$ca918d80$@sigma-it.ru>
References: <053201d235cc$e62439e0$b26cada0$@sigma-it.ru> <CAEtw4r31p7YmB8mq9qGpu=mW=KmLMBeP7EdfS0YbpzA9CfrMxw@mail.gmail.com>
 <06d901d235dc$ee308480$ca918d80$@sigma-it.ru>
From: Peter Becker <floyd.net@gmail.com>
Date: Thu, 3 Nov 2016 15:21:17 +0100
Message-ID: <CAEtw4r1BXKOVOTqVTdoBZDE2N4pb88x6fATMCeKErtoy3RwC-w@mail.gmail.com>
Subject: Re: Problem with btrfs snapshots
To: =?UTF-8?B?0JTQvNC40YLRgNC40Lkg0J3QtdGH0LDQtdCy?=
        <d.nechaev@sigma-it.ru>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

(copy for mainlinglist)

2016-11-03 15:16 GMT+01:00 Дмитрий Нечаев <d.nechaev@sigma-it.ru>:
Yes. We tried "sync" in our script but it doesn't help. It works only
then we make one snapshot at a time. Even if we use "sync" before and
after creating snapshot, it doesn't help.
