Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:48903 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757870Ab2FENyP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Jun 2012 09:54:15 -0400
Received: by weyu7 with SMTP id u7so3589369wey.19
        for <linux-btrfs@vger.kernel.org>; Tue, 05 Jun 2012 06:54:14 -0700 (PDT)
From: Diego Calleja <diegocg@gmail.com>
To: "Alexander E. Patrakov" <patrakov@gmail.com>
Cc: "Kok, Auke-jan H" <auke-jan.h.kok@intel.com>,
        Peeters Simon <peeters.simon@gmail.com>,
        systemd-devel@lists.freedesktop.org, linux-btrfs@vger.kernel.org
Subject: Re: [systemd-devel] systemd-udevd: excessive I/O usage
Date: Tue, 05 Jun 2012 15:49:20 +0200
Message-ID: <1791638.Q7YQnvvX5y@fedora16>
In-Reply-To: <CAN_LGv0RcA5y6Dyq25_poWxhwxoS7X6CGi71czrJji0E6NHzzg@mail.gmail.com>
References: <CAKyAS7vw6pPz56Y9DeyUQLVeuXq4G2WogEWm+5gANesC0ME35g@mail.gmail.com> <CABsxX9JBsOX7sFYvmSjdq5N8pXPDrSv3V4DaRszKdpnBK_KxEA@mail.gmail.com> <CAN_LGv0RcA5y6Dyq25_poWxhwxoS7X6CGi71czrJji0E6NHzzg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

[resend, for some reason kmail formatted the previous message with html]

On Martes, 5 de junio de 2012 09:50:56 Alexander E. Patrakov escribió:
> Result: boot from ext4 takes less than 15 seconds, while boot from
> btrfs takes 9 minutes (or 5 minutes if I disable readahead - the data
> file is not valid anyway on btrfs).

I also had this problem. It turns out that btrfs was creating the 
space cache from scratch (which takes several minutes) on each boot,
for some reason. I added the space_cache mount option to fstab,
and now my system boots fast. I suggest trying it.
