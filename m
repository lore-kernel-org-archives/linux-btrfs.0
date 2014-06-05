Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f180.google.com ([74.125.82.180]:45780 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751658AbaFEQNa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 5 Jun 2014 12:13:30 -0400
Received: by mail-we0-f180.google.com with SMTP id q58so1410870wes.11
        for <linux-btrfs@vger.kernel.org>; Thu, 05 Jun 2014 09:13:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAEezp7sxyEP2Bmp9vWB843pb7VQvWyHmG+1uPU_Dk--hhu2LAw@mail.gmail.com>
References: <CAEezp7uMXA3t8-GDVcVzx9An+hPBZmynYZ-wUXzhJuP93czs1w@mail.gmail.com>
 <pan$765af$b28af9a8$903ce16b$940baf34@cox.net> <CAEezp7sxyEP2Bmp9vWB843pb7VQvWyHmG+1uPU_Dk--hhu2LAw@mail.gmail.com>
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Thu, 5 Jun 2014 19:13:08 +0300
Message-ID: <CAGqmi77dGTaZOT8u=XDMnYnDxhNoWhrhjZtHpD35OB28VvY8YQ@mail.gmail.com>
Subject: Re: Very slow filesystem
To: Igor M <igork20@gmail.com>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2014-06-05 18:52 GMT+03:00 Igor M <igork20@gmail.com>:
> One more question. Is there any other way to find out file fragmentation ?
> I just copied 35Gb file on new btrfs filesystem (compressed) and
> filefrag reports 282275 extents found. This can't be right ?
hes, because filefrag show compressed block (128kbite) as one extent.
-- 
Best regards,
Timofey.
