Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f181.google.com ([209.85.223.181]:49211 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932824Ab3FROCG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Jun 2013 10:02:06 -0400
Received: by mail-ie0-f181.google.com with SMTP id x12so10017821ief.40
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Jun 2013 07:02:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPQsFSVtLvvdaZ2QHigSRT40QgHLGGAGiDjR-HkrYh7+LdUU2A@mail.gmail.com>
References: <CAPQsFSVtLvvdaZ2QHigSRT40QgHLGGAGiDjR-HkrYh7+LdUU2A@mail.gmail.com>
Date: Tue, 18 Jun 2013 08:02:06 -0600
Message-ID: <CAE5mzvgnKOBk6MusRUnS6c4Jp_SYDo=Re+K_ZvBGX+xCj3iLOw@mail.gmail.com>
Subject: Re: My multi-device btrfs (3*2TB) won't mount anymore.
From: cwillu <cwillu@cwillu.com>
To: Retro Pirate <theretropirate@googlemail.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Does anything show up in dmesg when you mount?

If mount just hangs, do an alt-sysrq-w, and then post what that sends to dmesg.
