Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:36332 "EHLO
	mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932538AbcFCNrf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Jun 2016 09:47:35 -0400
Received: by mail-wm0-f47.google.com with SMTP id n184so126995763wmn.1
        for <linux-btrfs@vger.kernel.org>; Fri, 03 Jun 2016 06:47:35 -0700 (PDT)
Subject: Re: Recommended why to use btrfs for production?
To: Martin <rc6encrypted@gmail.com>
References: <CAGQ70Yc=HHxJspMCKFBpEURRu=53pZW3k3rVDVO3QPGP_b9Tkw@mail.gmail.com>
 <aeade1fe-825c-6fc2-7f6d-85f4c5400b38@gmail.com>
 <CAGQ70YeZzDgiT_v1Z0eGcWsn8prnji30hCkyjrBg8vNziLUkiQ@mail.gmail.com>
Cc: linux-btrfs@vger.kernel.org
From: Julian Taylor <jtaylor.debian@googlemail.com>
Message-ID: <57518A73.5030201@googlemail.com>
Date: Fri, 3 Jun 2016 15:47:31 +0200
MIME-Version: 1.0
In-Reply-To: <CAGQ70YeZzDgiT_v1Z0eGcWsn8prnji30hCkyjrBg8vNziLUkiQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/03/2016 03:31 PM, Martin wrote:
>> In general, avoid Ubuntu LTS versions when dealing with BTRFS, as well as
>> most enterprise distros, they all tend to back-port patches instead of using
>> newer kernels, which means it's functionally impossible to provide good
>> support for them here (because we can't know for sure what exactly they've
>> back-ported).  I'd suggest building your own kernel if possible, with Arch
>> Linux being a close second (they follow upstream very closely), followed by
>> Fedora and non-LTS Ubuntu.
>
> Then I would build my own, if that is the preferred option.
>

Ubuntu also provides newer kernels for their LTS via the Hardware 
Enablement Stack:

https://wiki.ubuntu.com/Kernel/LTSEnablementStack

So if you can live with about 6 month time lag and shorter support for 
the non-lts versions of those kernels that is a good option.
As you can see 16.04 currently provides 4.4 and the next update will 
likely be 4.8.
