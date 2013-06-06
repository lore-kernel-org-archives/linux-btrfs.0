Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f177.google.com ([209.85.214.177]:42000 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752721Ab3FFTcz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 6 Jun 2013 15:32:55 -0400
MIME-Version: 1.0
In-Reply-To: <1370280485-10047-2-git-send-email-joern@logfs.org>
References: <1370280485-10047-1-git-send-email-joern@logfs.org>
	<1370280485-10047-2-git-send-email-joern@logfs.org>
Date: Thu, 6 Jun 2013 22:32:55 +0300
Message-ID: <CAHp75VczX+tjqJgNv4uv=BRekm2Gc2i8WHL91vJFWSXWS8-J_A@mail.gmail.com>
Subject: Re: [PATCH 1/2] list: add list_for_each_entry_del
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Joern Engel <joern@logfs.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chris Mason <chris.mason@fusionio.com>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 3, 2013 at 8:28 PM, Joern Engel <joern@logfs.org> wrote:
> I have seen a lot of boilerplate code that either follows the pattern of
>         while (!list_empty(head)) {
>                 pos = list_entry(head->next, struct foo, list);
>                 list_del(pos->list);
>                 ...
>         }
> or some variant thereof.

What the problem to use list_for_each_safe()?


--
With Best Regards,
Andy Shevchenko
