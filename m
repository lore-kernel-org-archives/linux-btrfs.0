Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f179.google.com ([209.85.161.179]:34410 "EHLO
        mail-yw0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1426099AbdDVREk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 22 Apr 2017 13:04:40 -0400
Received: by mail-yw0-f179.google.com with SMTP id k11so17283587ywb.1
        for <linux-btrfs@vger.kernel.org>; Sat, 22 Apr 2017 10:04:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170421133957.7kax2ktwhh43nnq2@mailbox.org>
References: <20170421133957.7kax2ktwhh43nnq2@mailbox.org>
From: Chris Murphy <lists@colorremedies.com>
Date: Sat, 22 Apr 2017 11:04:39 -0600
Message-ID: <CAJCQCtR=p362Tuk+FuKSr1q7Bga7n6rpZPxXTyF1RcKmrx94Kw@mail.gmail.com>
Subject: Re: Prevent escaping btrfs quota
To: Christian Brauner <christian.brauner@canonical.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        =?UTF-8?Q?St=C3=A9phane_Graber?= <stgraber@ubuntu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

March 25 thread "Qgroups are not applied when snapshotting a subvol?"

Short answer is:
btrfs subvolume snapshot -i 1/1

The problem being that any user can make snapshots and thus escape the
quota by omitting -i. However for containers, presumably it's some
daemon behind the scene that is actually managing the snapshotting for
use with a new container, so it'd need to become quota aware.



Chris Murphy
