Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f53.google.com ([209.85.215.53]:34302 "EHLO
        mail-lf0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935991AbcJQQyC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 17 Oct 2016 12:54:02 -0400
Received: by mail-lf0-f53.google.com with SMTP id b81so293901610lfe.1
        for <linux-btrfs@vger.kernel.org>; Mon, 17 Oct 2016 09:53:55 -0700 (PDT)
Received: from [192.168.1.44] (ppp109-252-90-102.pppoe.spdop.ru. [109.252.90.102])
        by smtp.gmail.com with ESMTPSA id h99sm8115933lji.39.2016.10.17.09.53.52
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 17 Oct 2016 09:53:53 -0700 (PDT)
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Subject: What are "parent" and "parent_uuid" in "btrfs sub list"?
Message-ID: <e39fb389-7ce1-2913-941b-aefa05a26fd1@gmail.com>
Date: Mon, 17 Oct 2016 19:53:51 +0300
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I try to understand how to build a tree of snapshots (i.e. - which
subvolume was used to snapshot/clone other subvolume). What is the
correct way to determine it? In particular, "btrfs sub list -p" always
prints something for "parent snapshot", while btrfs sub list -q" only
prints parent_uuid for actual snapshots (i.e. for subvolumes I know are
snapshots). Are "parent" and "parent_uuid" related to each other? Of
not, what do they mean?
