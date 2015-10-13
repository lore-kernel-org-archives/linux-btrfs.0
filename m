Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:37941 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932069AbbJMVVw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 13 Oct 2015 17:21:52 -0400
Received: by wieq12 with SMTP id q12so52664308wie.1
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Oct 2015 14:21:51 -0700 (PDT)
Received: from [192.168.0.182] (dhcp-077-250-162-252.chello.nl. [77.250.162.252])
        by smtp.gmail.com with ESMTPSA id pk7sm5937088wjb.2.2015.10.13.14.21.50
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 13 Oct 2015 14:21:50 -0700 (PDT)
From: Carmine Paolino <carmine@paolino.me>
Content-Type: text/plain; charset=utf-8
Subject: System completely unresponsive after `btrfs balance start -dconvert=raid0 /` and `btrfs fi show /`
Message-Id: <C1BFF62A-9C2E-4A5D-86F9-7F01DDDF8BF6@paolino.me>
Date: Tue, 13 Oct 2015 23:21:49 +0200
To: linux-btrfs@vger.kernel.org
Mime-Version: 1.0 (Mac OS X Mail 9.0 \(3094\))
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

I have an home server with 3 hard drives that I added to the same btrfs filesystem. Several hours ago I run `btrfs balance start -dconvert=raid0 /` and as soon as I run `btrfs fi show /` I lost my ssh connection to the machine. The machine is still on, but it doesn’t even respond to ping: I always get a request timeout and sometimes even an host is down message. Its fans are spinning at full blast and the hard drives’s led are registering activity all the time. I run Plex Home Theater too there and the display output is stuck at the time when I run those two commands. I left it running because I fear to lose everything by powering it down manually.

Should I leave it like this and let it finish? How long it might take? (I have a 250gb internal hard drive, a 120gb usb 2.0 one and a 2TB usb 2.0 one so the transfer speeds are pretty low) Is it safe to power it off manually? Should I file a bug after it?

Any help would be appreciated.

Thanks,
Carmine