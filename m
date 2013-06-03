Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f175.google.com ([74.125.82.175]:62946 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920Ab3FCEIS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Jun 2013 00:08:18 -0400
Received: by mail-we0-f175.google.com with SMTP id t59so163616wes.20
        for <linux-btrfs@vger.kernel.org>; Sun, 02 Jun 2013 21:08:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <51ABFB3E.6050408@chinilu.com>
References: <51AB5974.3080803@chinilu.com>
	<20130603012848.GA26016@liubo.jp.oracle.com>
	<51ABFB3E.6050408@chinilu.com>
Date: Mon, 3 Jun 2013 01:08:17 -0300
Message-ID: <CAA+gEbZkpMfo9-Gj9K1KC-s4-_ehy_uA9sMPDjZOON6FBWx3Fw@mail.gmail.com>
Subject: Re: Is there a way to flag specific directories "nodatacow"?
From: "A. C. Censi" <accensi@gmail.com>
To: george@chinilu.com
Cc: bo.li.liu@oracle.com, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jun 2, 2013 at 11:11 PM, George Mitchell <george@chinilu.com> wrote:
>
> So I want to try forcing "nodatacow" on this directory and see what happens.
> If that doesn't work, I suppose the next step will be to place this one
> directory on an ext4 filesystem and mount it externally to the btrfs
> /var/log.


I have the same kind of errors in ext4 file system (ArchLinux 64-bit
in a Macbook Air). To me they seem to be related to power loss events,
caused by battery depletion when sleeping for long time.

Any way besides long time intialization of journalctl displays, there
is no error in dmesg or /var/log/files. The errors should be related
to log metadata info.


--
A. C. Censi
accensi [em] gmail [ponto] com
accensi [em] montreal [ponto] com [ponto] br
