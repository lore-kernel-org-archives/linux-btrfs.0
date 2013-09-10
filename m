Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:36973 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752285Ab3IJPbC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Sep 2013 11:31:02 -0400
Received: by mail-pa0-f46.google.com with SMTP id fa1so7933233pad.33
        for <linux-btrfs@vger.kernel.org>; Tue, 10 Sep 2013 08:31:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130909225023.GU32382@twin.jikos.cz>
References: <522E3A0E.6080504@redhat.com>
	<20130909225023.GU32382@twin.jikos.cz>
Date: Tue, 10 Sep 2013 08:31:01 -0700
Message-ID: <CAN05THQthJPTk6WnfqY+gX5h6sSxW3QneWzn-M1XVPKv_bNsKA@mail.gmail.com>
Subject: Re: btrfs.h and btrfs-progs licensing
From: ronnie sahlberg <ronniesahlberg@gmail.com>
To: dsterba@suse.cz, Andy Grover <agrover@redhat.com>,
        linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@fusionio.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For crc32c you can use this one which is lgpl:
https://github.com/sahlberg/libiscsi/blob/master/lib/crc32c.c


You can use the generator at :
http://www.ross.net/crc/download/crc_v3.txt
to generate this (and others)



On Mon, Sep 9, 2013 at 3:50 PM, David Sterba <dsterba@suse.cz> wrote:
> On Mon, Sep 09, 2013 at 02:13:50PM -0700, Andy Grover wrote:
>> However, as it stands, the kernel's include/uapi/linux/btrfs.h and
>> btrfs-progs are GPLv2, which means that a "libbtrfs" that is based on either
>> of these might also be construed to need to be GPLv2, and any program
>> *using* libbtrfs might also be construed to need to be GPLv2.
>
> Looking at "nm libbtrfs.a" there are rbtree and crc32c symbols included
> in the library, licensed under GPLv2, the rest is pure userspace code and
> the people are around to ask about relicensing.
>
> david
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
