Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qa0-f49.google.com ([209.85.216.49]:39792 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315Ab2FEO7a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Jun 2012 10:59:30 -0400
Received: by qabj40 with SMTP id j40so3429297qab.1
        for <linux-btrfs@vger.kernel.org>; Tue, 05 Jun 2012 07:59:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1791638.Q7YQnvvX5y@fedora16>
References: <CAKyAS7vw6pPz56Y9DeyUQLVeuXq4G2WogEWm+5gANesC0ME35g@mail.gmail.com>
	<CABsxX9JBsOX7sFYvmSjdq5N8pXPDrSv3V4DaRszKdpnBK_KxEA@mail.gmail.com>
	<CAN_LGv0RcA5y6Dyq25_poWxhwxoS7X6CGi71czrJji0E6NHzzg@mail.gmail.com>
	<1791638.Q7YQnvvX5y@fedora16>
Date: Tue, 5 Jun 2012 20:59:27 +0600
Message-ID: <CAN_LGv1G7AoAEUcEVhrw3OreSNwRsdBJrM6455C=LS2SpEXDEA@mail.gmail.com>
Subject: Re: [systemd-devel] systemd-udevd: excessive I/O usage
From: "Alexander E. Patrakov" <patrakov@gmail.com>
To: Diego Calleja <diegocg@gmail.com>
Cc: "Kok, Auke-jan H" <auke-jan.h.kok@intel.com>,
        Peeters Simon <peeters.simon@gmail.com>,
        systemd-devel@lists.freedesktop.org, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2012/6/5 Diego Calleja <diegocg@gmail.com>:
> [resend, for some reason kmail formatted the previous message with html]
>
> On Martes, 5 de junio de 2012 09:50:56 Alexander E. Patrakov escribió:
>> Result: boot from ext4 takes less than 15 seconds, while boot from
>> btrfs takes 9 minutes (or 5 minutes if I disable readahead - the data
>> file is not valid anyway on btrfs).
>
> I also had this problem. It turns out that btrfs was creating the
> space cache from scratch (which takes several minutes) on each boot,
> for some reason. I added the space_cache mount option to fstab,
> and now my system boots fast. I suggest trying it.

It helped me, too - but ext4 is still faster under the typical
"startup under systemd" load type. The difference manifests itself as
GDM login screen sometimes timing out some components of its fancy
version (due to something resembling kernel bug 12309) and falling
back to the simple non-gnome-shell version.

Sorry for hijacking the thread, but the amount of parallelization
achieved by systemd is way too much for a rotating drive from 2007,
especially since some system components like gdm have aggressive
timeouts easily triggered by disk i/o.

-- 
Alexander E. Patrakov
