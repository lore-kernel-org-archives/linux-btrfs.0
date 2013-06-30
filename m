Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ve0-f179.google.com ([209.85.128.179]:48089 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751980Ab3F3UKc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 30 Jun 2013 16:10:32 -0400
Received: by mail-ve0-f179.google.com with SMTP id d10so3194141vea.38
        for <linux-btrfs@vger.kernel.org>; Sun, 30 Jun 2013 13:10:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4774295.3Q3X7zsTmb@vfr>
References: <11441914.sRzrmH57Vq@bheem>
	<4774295.3Q3X7zsTmb@vfr>
Date: Sun, 30 Jun 2013 22:10:30 +0200
Message-ID: <CAFvQSYQJOCuM7Ov+7dGCO_i4eEPMfdTBRMf0QV=GhypAdhWd1A@mail.gmail.com>
Subject: Re: unclean shutdown and space cache rebuild
From: Clemens Eisserer <linuxhippy@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

> I suspect this is, at least in part, related to severe fragmentation
> in /home.

In his cause those issues are only present after an unclean shutdown -
whereas fragmentation would show its effect after every reboot.

Regards, Clemens
