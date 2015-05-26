Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f181.google.com ([209.85.223.181]:33591 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140AbbEZTtW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 May 2015 15:49:22 -0400
Received: by iebgx4 with SMTP id gx4so100479009ieb.0
        for <linux-btrfs@vger.kernel.org>; Tue, 26 May 2015 12:49:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <556457b8.e72b980a.ee08.ffffce60@mx.google.com>
References: <556457b8.e72b980a.ee08.ffffce60@mx.google.com>
Date: Tue, 26 May 2015 13:49:22 -0600
Message-ID: <CAJCQCtQFyCEn3kdeYOrOyk_vqekNH_MiOyA=WSOxLCoQS6PV1w@mail.gmail.com>
Subject: Re: RAID1: system stability
From: Chris Murphy <lists@colorremedies.com>
To: Timofey Titovets <nefelim4ag@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Without a complete dmesg it's hard to say what's going on. The call
trace alone probably don't show the instigating factor so you may need
to use remote ssh with journalctl -f, or use netconsole to
continuously get kernel messages prior to the implosion.

Chris Murphy
