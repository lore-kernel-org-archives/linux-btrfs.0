Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f45.google.com ([209.85.213.45]:33288 "EHLO
        mail-vk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750768AbdESG76 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 19 May 2017 02:59:58 -0400
Received: by mail-vk0-f45.google.com with SMTP id x71so7475977vkd.0
        for <linux-btrfs@vger.kernel.org>; Thu, 18 May 2017 23:59:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170517014131.8549-1-fdmanana@kernel.org>
References: <20170517014131.8549-1-fdmanana@kernel.org>
From: "Lakshmipathi.G" <lakshmipathi.g@gmail.com>
Date: Fri, 19 May 2017 12:29:57 +0530
Message-ID: <CAKuJGC8MYiFZHNKv_MrmojF6gQhF=G53jbrXT-YxqLLkUrmxgg@mail.gmail.com>
Subject: Re: [PATCH 2/2] btrfs-progs: test for restoring multiple devices fs
 into a single device
To: fdmanana@kernel.org
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Looks fine, just couple of minor feedback.

> +run_check $SUDO_HELPER $TOP/mkfs.btrfs -f $loop1 $loop2

Please add quotation around variable in the script, as suggested in
tests/README.md 'Coding style, best practices' section. This section
is added recently, we are updating older scripts.

> +
> +# Cleanup loop devices.
> +run_check $SUDO_HELPER losetup -d $loop1
> +run_check $SUDO_HELPER losetup -d $loop2
> +rm -f dev1 dev2
> +
> +# Compare the file digests.
> +[ $orig_md5 == $new_md5 ] || _fail "File digests do not match"

"Cleanup loop devices" can be done after comparing file integrity?
This way, if integrity fails, the setup will be there to debug
further. thanks.

-- 
----
Cheers,
Lakshmipathi.G
