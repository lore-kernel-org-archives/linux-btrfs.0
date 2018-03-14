Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f65.google.com ([209.85.213.65]:44441 "EHLO
        mail-vk0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750862AbeCNQR1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Mar 2018 12:17:27 -0400
MIME-Version: 1.0
In-Reply-To: <20180314154248.GL32007@twin.jikos.cz>
References: <1520970622-19535-1-git-send-email-s.mesoraca16@gmail.com> <20180314154248.GL32007@twin.jikos.cz>
From: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Date: Wed, 14 Mar 2018 17:17:06 +0100
Message-ID: <CAJHCu1LFy+dpAvBw+Qgp-wCOg8=Fx8NUM-ovVSMjfoGf9E7sMw@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: drop a VLA in btrfs_check_super_csum()
To: dsterba@suse.cz, Salvatore Mesoraca <s.mesoraca16@gmail.com>,
        linux-kernel@vger.kernel.org,
        Kernel Hardening <kernel-hardening@lists.openwall.com>,
        linux-btrfs@vger.kernel.org, Chris Mason <clm@fb.com>,
        David Sterba <dsterba@suse.com>, Josef Bacik <jbacik@fb.com>,
        Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2018-03-14 16:42 GMT+01:00 David Sterba <dsterba@suse.cz>:
> We already have a patch for that from a few days ago, but thanks anyway.
>
> https://patchwork.kernel.org/patch/10277901/

Oh.. OK

Best regards,

Salvatore
