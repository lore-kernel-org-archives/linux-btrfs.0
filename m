Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f42.google.com ([209.85.192.42]:60713 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752409AbaFEPwJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 5 Jun 2014 11:52:09 -0400
Received: by mail-qg0-f42.google.com with SMTP id q107so1907484qgd.29
        for <linux-btrfs@vger.kernel.org>; Thu, 05 Jun 2014 08:52:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <pan$765af$b28af9a8$903ce16b$940baf34@cox.net>
References: <CAEezp7uMXA3t8-GDVcVzx9An+hPBZmynYZ-wUXzhJuP93czs1w@mail.gmail.com>
	<pan$765af$b28af9a8$903ce16b$940baf34@cox.net>
Date: Thu, 5 Jun 2014 17:52:07 +0200
Message-ID: <CAEezp7sxyEP2Bmp9vWB843pb7VQvWyHmG+1uPU_Dk--hhu2LAw@mail.gmail.com>
Subject: Re: Very slow filesystem
From: Igor M <igork20@gmail.com>
To: Duncan <1i5t5.duncan@cox.net>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

One more question. Is there any other way to find out file fragmentation ?
I just copied 35Gb file on new btrfs filesystem (compressed) and
filefrag reports 282275 extents found. This can't be right ?

On Thu, Jun 5, 2014 at 5:05 AM, Duncan <1i5t5.duncan@cox.net> wrote:
> Igor M posted on Thu, 05 Jun 2014 00:15:31 +0200 as excerpted:
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
