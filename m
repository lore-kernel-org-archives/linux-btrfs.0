Return-Path: <SRS0=1mW1=O2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3E96C43387
	for <linux-btrfs@archiver.kernel.org>; Mon, 17 Dec 2018 12:52:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7204220874
	for <linux-btrfs@archiver.kernel.org>; Mon, 17 Dec 2018 12:52:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="p3SPfnrB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727203AbeLQMwV (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 17 Dec 2018 07:52:21 -0500
Received: from mail-oi1-f178.google.com ([209.85.167.178]:40569 "EHLO
        mail-oi1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726785AbeLQMwV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 17 Dec 2018 07:52:21 -0500
Received: by mail-oi1-f178.google.com with SMTP id t204so10031947oie.7
        for <linux-btrfs@vger.kernel.org>; Mon, 17 Dec 2018 04:52:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=eamPBzuhPt/V68XxkzY8Qwhd9zwHlRzHiilX8qSd6U0=;
        b=p3SPfnrBDz1wwXQaVJGQU21HK62EtMR+zHHxTjPS9vs6dQGML9OnqfiepQI097bW/z
         IY5FOIU58YWrKKG2DM6C9MT6+I5CWQvKAqKQplmn9bDeY9pYVR1lQzFFzb/FZaPb7aG0
         oq7NP4Edeapb9+nmcgUE3fufC+pAruCafAM4g4rBrwpq0AnstU8Z8yElJFQJUkGA+u5x
         DeHjDFXr2J9n1PF6ft+b1TMLVCDNoD3G0SWkrT6LWUUP55K/D8hnAcRy+uOn3LgVQqR1
         kM0kn/tSqQPvRx8dSZ3UJREkuNCxuZqWV2syt66008DD2YICXHKZ7lBS22amWH4B+0ht
         HDRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=eamPBzuhPt/V68XxkzY8Qwhd9zwHlRzHiilX8qSd6U0=;
        b=VeUFDTnRxfOSJ2gG3WetstAM9/3Za0gVX8IyuKhxw8QS+TOTPiB7VLUwSyYhuyCiaH
         eu+Yl32mV9yza/HstVmXpimZSzJ/mQOUuJKqJEk1VU+3HivX9SLwldzmop+ZVFtefGig
         Ehtz5si5QHgfYXzWq2oukgBZJHXbh6msW9PQqPMKpnPpv+FXnKyRAYmVWPal8cPsjtrx
         m/zsERNo46a3maxIW3VGjuoFSQ82Zl60yL+JsnoLJPgv4AEwRd+ULaDBqhBsx0rWgIIi
         sGa7T6918TBSThiIR3P9RhP6p6O6aR37l56XNBZqJfAhAhFQxyKwRjqSneD99C5RXa3d
         6d8g==
X-Gm-Message-State: AA+aEWY+5E5Nzm2q9G3qD9R7VwVmD1gm0wQBxsrpcbgJ7oO7A46IbEv0
        L6Udtd5RfwgPf/IzDw/aX2fsHk/cSND4Yv0paNzozg==
X-Google-Smtp-Source: AFSGD/VgUJkMoZLP4xT3cta02AxwafS/g4Mo0jxiOjDcEnfAhh0XuaHDUophGdK9DOaWup3Fn3722MZ0PrrNLmPklYw=
X-Received: by 2002:aca:5406:: with SMTP id i6mr5477961oib.344.1545051139870;
 Mon, 17 Dec 2018 04:52:19 -0800 (PST)
MIME-Version: 1.0
From:   Raymond Jennings <shentino@gmail.com>
Date:   Mon, 17 Dec 2018 04:51:43 -0800
Message-ID: <CAGDaZ_qug36TLzvQA47Pvo1t5pVkJdx7FhDYpc2LYa3eAWDiuQ@mail.gmail.com>
Subject: mkfs.btrfs vs btrfs-convert
To:     linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Just curious, but does btrfs-convert support all the same options as mkfs.btrfs?

If not, should it?
