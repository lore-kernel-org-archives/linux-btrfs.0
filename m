Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f170.google.com ([209.85.217.170]:33130 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756736Ab3ANQeS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Jan 2013 11:34:18 -0500
Received: by mail-lb0-f170.google.com with SMTP id j14so3096837lbo.29
        for <linux-btrfs@vger.kernel.org>; Mon, 14 Jan 2013 08:34:17 -0800 (PST)
Message-ID: <50F43386.2030402@gmail.com>
Date: Mon, 14 Jan 2013 16:34:14 +0000
From: Tomasz Kusmierz <tom.kusmierz@gmail.com>
MIME-Version: 1.0
To: Roman Mamedov <rm@romanrm.ru>
CC: Chris Mason <chris.mason@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs for files > 10GB = random spontaneous CRC failure.
References: <50F3E77B.2030901@gmail.com> <20130114145904.GA1387@shiny> <50F422BC.4000901@gmail.com> <20130114222058.4dc90a81@natsu>
In-Reply-To: <20130114222058.4dc90a81@natsu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 14/01/13 16:20, Roman Mamedov wrote:
> On Mon, 14 Jan 2013 15:22:36 +0000
> Tomasz Kusmierz <tom.kusmierz@gmail.com> wrote:
>
>> 1) create a single drive default btrfs volume on single partition ->
>> fill with test data -> scrub -> admire errors.
> Did you try ruling out btrfs as the cause of the problem? Maybe something else
> in your system is corrupting data, and btrfs just lets you know about that.
>
> I.e. on the same drive, create an Ext4 filesystem, copy some data to it which
> has known checksums (use md5sum or cfv to generate them in advance for data
> that is on another drive and is waiting to be copied); copy to that drive,
> flush caches, verify checksums of files at the destination.
>
Hi Roman,

Chris just provided his good old friend "stress.sh" that should do that. 
So I'll dive into more testing :)

Tom.
