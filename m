Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ve0-f177.google.com ([209.85.128.177]:59263 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754034AbaCCRiu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Mar 2014 12:38:50 -0500
Received: by mail-ve0-f177.google.com with SMTP id sa20so3954860veb.36
        for <linux-btrfs@vger.kernel.org>; Mon, 03 Mar 2014 09:38:49 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CA6506DF-0B47-4874-AB63-AFC471C73622@colorremedies.com>
References: <CAFvQSYQ0YvG=kJER-C7fkqyfrM0gVOQortC-=VRe680KyXqkEA@mail.gmail.com>
	<CA6506DF-0B47-4874-AB63-AFC471C73622@colorremedies.com>
Date: Mon, 3 Mar 2014 18:38:49 +0100
Message-ID: <CAFvQSYRKOsheGNVTEQfD3mdEZbke0UTxQ16ittYTfCo+c9T87A@mail.gmail.com>
Subject: Re: Filesystem extremly fragmented after scrub
From: Clemens Eisserer <linuxhippy@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

> Some general notes .. VM images ...  While NOCOW will prevent COW ...

As mentioned the VM is configured to access the partition where linux
is installed directly.
So btrfs is not used as filesystem on the host machine, but rather on
the guest which writes directly to disk (so no other filesystem is
interfering here).

>  I'm not sure about fsck (presumably btrfsck),
>  but filefrag does not know about btrfs compression yet

My bad, this was fsck from my ext2 boot partition ;)

I wonder why  my filesystem got so painfully slow after scrub.
Is there any useful measure to determine how badly fragmented a btrfs volume is?

Thanks and best regards, Clemens
