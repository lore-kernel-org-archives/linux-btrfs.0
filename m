Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:62761 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755569Ab2HHCi3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Aug 2012 22:38:29 -0400
Received: by vbbff1 with SMTP id ff1so297955vbb.19
        for <linux-btrfs@vger.kernel.org>; Tue, 07 Aug 2012 19:38:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120807174047.GE24635@merlins.org>
References: <20120807174047.GE24635@merlins.org>
Date: Tue, 7 Aug 2012 22:38:28 -0400
Message-ID: <CALJXSJr95YjaBqM6vtOexqxXLokj-2av6k74AvqiEcO=U2RocQ@mail.gmail.com>
Subject: Re: btrfs panic in 3.5.0
From: =?UTF-8?B?SsOpcsO0bWUgUG91bGlu?= <jeromepoulin@gmail.com>
To: Marc MERLIN <marc@merlins.org>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 7, 2012 at 1:40 PM, Marc MERLIN <marc@merlins.org> wrote:
>
> System rebooted ok.

I just want to be sure that you are aware that your hard drive is
currently killing itself. Those READ FPDMA QUEUED mean that your hard
disk is relocatting bad sectors and has problem reading those.
