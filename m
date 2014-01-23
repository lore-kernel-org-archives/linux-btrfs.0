Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f182.google.com ([74.125.82.182]:48308 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752101AbaAWM2o (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Jan 2014 07:28:44 -0500
Received: by mail-we0-f182.google.com with SMTP id w62so1045592wes.41
        for <linux-btrfs@vger.kernel.org>; Thu, 23 Jan 2014 04:28:43 -0800 (PST)
Message-ID: <52E10B06.4080703@gmail.com>
Date: Thu, 23 Jan 2014 13:28:54 +0100
From: =?ISO-8859-1?Q?Joshua_Sch=FCler?= <joshua.schueler@gmail.com>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Miguel_Negr=E3o?=
	<miguel.negrao-lists@friendlyvirus.org>,
        "list, btrfs" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs send 3.11 vs 3.12
References: <52E0DF6B.2080200@friendlyvirus.org>
In-Reply-To: <52E0DF6B.2080200@friendlyvirus.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am 23.01.2014 10:22, schrieb Miguel Negrão:
> Hi
> 
> Sending snapshots incrementally started to fail on the 3.11 kernel
>  on my system after I once booted with 3.12 and did the incremental
>  send of a snapshot. After when I booted back to 3.11 I can no 
> longer send the snapshots incrementally based on the last one sent
>  (I could still send based on the last one sent from 3.11), 
> although booting again to 3.12 I can send me fine again.
> 
> It this intenteded ?
> 
> best,
> 

Hi Miguel,

btrfs guarantees backward compatibility since 3.13(?), but never
guaranteed forward compatibility. So it is not yet supported to mount
the fs with an older kernel once it was mounted with a newer one.
Especially when using features that are under heavy development right now.

Also try to keep your kernel up to date (3.13 is out since a few days)

Joshua
