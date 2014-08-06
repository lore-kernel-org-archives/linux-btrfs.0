Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.miceliux.com ([81.4.104.92]:39170 "EHLO mx2.miceliux.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753675AbaHFQ3V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Aug 2014 12:29:21 -0400
Received: from localhost (localhost [127.0.0.1])
	by mx2.miceliux.com (Postfix) with ESMTP id 3C1E5122DE5
	for <linux-btrfs@vger.kernel.org>; Wed,  6 Aug 2014 18:22:58 +0200 (CEST)
Received: from mx2.miceliux.com ([127.0.0.1])
	by localhost (mx2.miceliux.com [127.0.0.1]) (amavisd-new, port 10028)
	with ESMTP id 3cjqQSjFNevt for <linux-btrfs@vger.kernel.org>;
	Wed,  6 Aug 2014 18:22:53 +0200 (CEST)
Received: from xenon.miceliux.com (xenon.miceliux.com [IPv6:2001:470:7950:10::2])
	(using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: juan.orti@miceliux.com)
	by mx2.miceliux.com (Postfix) with ESMTPSA id CEA23122DE2
	for <linux-btrfs@vger.kernel.org>; Wed,  6 Aug 2014 18:22:53 +0200 (CEST)
From: Juan Orti Alcaine <juan.orti@miceliux.com>
To: linux-btrfs@vger.kernel.org
Subject: Re: btrfs send/receive does not preserve +C (nocow) attribute
Date: Wed, 06 Aug 2014 18:22:52 +0200
Message-ID: <1651217.HJVXSU4rSp@xenon.miceliux.com>
In-Reply-To: <20140806155652.GA569@asusntb.lan>
References: <20140806155652.GA569@asusntb.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

El Miércoles, 6 de agosto de 2014 17:56:52 Jakub Klinkovský escribió:
> I've been testing btrfs send/receive, and to my surprise, the +C (nocow)
> attribute I have set on directory for virtual machines images is not
> preserved. Is this expected? Having found no information about this issue,
> I'm asking here.
> 
> Info:
> $ uname -a
> Linux asusntb 3.15.8-1-ARCH #1 SMP PREEMPT Fri Aug 1 08:51:42 CEST 2014
> x86_64 GNU/Linux $ btrfs --version
> Btrfs v3.14.2-dirty
> 
> Both source and target btrfs filesystems are mounted with the same mount
> options:
>   rw,nosuid,nodev,noatime,compress=lzo,space_cache,autodefrag,commit=60
> 
> $ lsattr ~/virtual_machines/
> ---------------C virtual_machines/archlinux-btrfs.raw
> ---------------C virtual_machines/archlinux.raw
> ---------------C virtual_machines/winxp.raw
> 
> $ lsattr /media/backup/virtual_machines/2014-08-06/
> ----------------
> /media/backup/virtual_machines/2014-08-06/archlinux-btrfs.raw
> ---------------- /media/backup/virtual_machines/2014-08-06/archlinux.raw
> ---------------- /media/backup/virtual_machines/2014-08-06/winxp.raw
> 
> Regards,
> 
> --
> jlk

Nor do file capabilities get preserved:
https://bugzilla.kernel.org/show_bug.cgi?id=68891
