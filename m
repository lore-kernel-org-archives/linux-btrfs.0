Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f180.google.com ([209.85.216.180]:49900 "EHLO
        mail-qt0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751138AbdJOBTY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 14 Oct 2017 21:19:24 -0400
Received: by mail-qt0-f180.google.com with SMTP id k31so25766038qta.6
        for <linux-btrfs@vger.kernel.org>; Sat, 14 Oct 2017 18:19:24 -0700 (PDT)
MIME-Version: 1.0
From: Cerem Cem ASLAN <ceremcem@ceremcem.net>
Date: Sun, 15 Oct 2017 04:19:23 +0300
Message-ID: <CAN4oSBcZmqh+iK7Qyd4VBcOhQDfZVAu2B7_1pL60UKCb_oX3zg@mail.gmail.com>
Subject: Why isnt NOCOW attributes propogated on snapshot transfers?
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

`btrfs send | btrfs receive` removes NOCOW attributes. Is it a bug or
a feature? If it's a feature, how can we keep these attributes if we
need to?
