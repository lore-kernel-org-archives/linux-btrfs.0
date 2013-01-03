Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailout06.t-online.de ([194.25.134.19]:37255 "EHLO
	mailout06.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753763Ab3ACSZB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Jan 2013 13:25:01 -0500
Date: 03 Jan 2013 19:20:00 +0100
From: Hullen@t-online.de (Helmut Hullen)
To: linux-btrfs@vger.kernel.org
Message-ID: <CO8iwyguCXB@helmut.hullen.de>
In-Reply-To: <CAE5mzvjswqKhKCSqF2P2gwRtFZ4NDjUR93XFCmG=b4nSe5cKZg@mail.gmail.com>
Subject: Re: Option LABEL
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Reply-To: helmut@hullen.de
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, cwillu,

Du meintest am 03.01.13:

>> But other filesystems don't put the label onto more than 1 device.
>> There's the problem for/with btrfs.

> Other filesystems don't exist on more than one device, so of course
> they don't put a label on more than one device.

Yes, I know.
And let me repeat the problem: programs like "blkid" don't work if more  
than 1 device has the same label.

Viele Gruesse!
Helmut
