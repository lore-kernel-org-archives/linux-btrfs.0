Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f169.google.com ([209.85.223.169]:33730 "EHLO
	mail-io0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776AbcCVTmC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Mar 2016 15:42:02 -0400
Received: by mail-io0-f169.google.com with SMTP id c63so73970122iof.0
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Mar 2016 12:42:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160322194854.161e9c4c@jupiter.sol.kaishome.de>
References: <20160322090342.595fefac@jupiter.sol.kaishome.de>
	<56F1068E.6050806@cn.fujitsu.com>
	<20160322194854.161e9c4c@jupiter.sol.kaishome.de>
Date: Tue, 22 Mar 2016 13:42:00 -0600
Message-ID: <CAJCQCtQEutVto5q3Pps+Yx9NBhPFWXBNiX=UMzMWy=uyEDb1wg@mail.gmail.com>
Subject: Re: csum errors in VirtualBox VDI files
From: Chris Murphy <lists@colorremedies.com>
To: Kai Krakow <hurikhan77@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is kinda confusing.

So the gist is that the guest OS is Windows, so the VDI contains an
NTFS file system. Correct? And that VDI is on a Btrfs formatted bcache
device. Correct? Does the VDI have +C xattr set?


Chris Murphy
