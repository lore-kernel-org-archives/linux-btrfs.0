Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:39773 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751900AbdJ3LM4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 30 Oct 2017 07:12:56 -0400
Message-Id: <1509361975.3034035.1155386528.03A00DFD@webmail.messagingengine.com>
From: Kai Hendry <hendry@iki.fi>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Date: Mon, 30 Oct 2017 19:12:55 +0800
References: <1507456690.745489.1131538472.25270157@webmail.messagingengine.com>
 <CAJCQCtRnbz5WGqZEO3b8a+3B2gDbG_zioqWEVoJz_dD0SB=6Ww@mail.gmail.com>
 <0a3e71f7-1a8e-9a4f-7470-4c5cc2fb11a0@gmail.com>
 <1507858974.1236555.1137202920.267B449B@webmail.messagingengine.com>
 <1509174195.600847.1153723936.0D8751F2@webmail.messagingengine.com>
 <8cff4fc5-6a33-e076-bfdb-d40dca8023ed@gmx.com>
 <1509247255.1470208.1154302000.6571EE79@webmail.messagingengine.com>
 <a92d6d6d-e059-63e3-ea67-6fe192291fee@gmx.com>
In-Reply-To: <a92d6d6d-e059-63e3-ea67-6fe192291fee@gmx.com>
Subject: Re: USB upgrade fun
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, 29 Oct 2017, at 06:02 PM, Qu Wenruo wrote:
> If so, mount it, do minimal write like creating an empty file, to update
> both superblock copies, and then try fix-device-size.

Tried that, and it didn't work. Made a recording:
https://youtu.be/SFd3QscNT6w
