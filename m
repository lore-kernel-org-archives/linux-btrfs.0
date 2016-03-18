Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f181.google.com ([209.85.223.181]:35277 "EHLO
	mail-io0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753560AbcCRKZp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 Mar 2016 06:25:45 -0400
Received: by mail-io0-f181.google.com with SMTP id o5so47860389iod.2
        for <linux-btrfs@vger.kernel.org>; Fri, 18 Mar 2016 03:25:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CABxShh-vwxqU5wq+Ouhn8H6ye=7wV4VgNx+fL2JM30H7=i0rWg@mail.gmail.com>
References: <CABxShh-vwxqU5wq+Ouhn8H6ye=7wV4VgNx+fL2JM30H7=i0rWg@mail.gmail.com>
Date: Fri, 18 Mar 2016 10:25:44 +0000
Message-ID: <CABxShh8W8A4PjdT9uUQvmxo_N0VLMc+D-eYyJ3a0N64UoQzXjw@mail.gmail.com>
Subject: Re: btrfs error
From: Paul Harrison <paulharrisonsipad@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Anyone? Would really appreciate a pointer or two!

Thanks

Paul

On Tue, Mar 15, 2016 at 4:00 PM, Paul Harrison
<paulharrisonsipad@gmail.com> wrote:
> Hi all,
>
> I'm new to btrfs, and have just taken over management of this system; can
> anyone point me in the right direction with regard to the following error:
>
> BTRFS error (device sda3): unable to find ref byte nr 402100224 parent 0
> root 256 owner 1 offset
> btrfs: Transaction aborted (error -2)
> BTRFS error (device sda3) in _btrfs_free_extent:5696: errno=-2 No such entry
> BTRFS error (device sda3) in btrfs_run_delayed_refs:2681: errno=-2 No such
> entry
> BTRFS error (device sda3) in cleanup_transaction:1530: errno=-2 No such
> entry
> iTCO_wdt: probe of iTCO_wdt failed with error -16
>
> The filesystem is now read-only, can I recover from this?
>
> I am running SUSE Linux Enterprise 11 SP4 64-bit.
>
> Thanks in advance,
>
> Paul
