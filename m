Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:33709 "EHLO
        mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751677AbdDNPdk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Apr 2017 11:33:40 -0400
Received: by mail-io0-f193.google.com with SMTP id k87so18980601ioi.0
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Apr 2017 08:33:39 -0700 (PDT)
Message-ID: <58F0EBD1.70905@gmail.com>
Date: Fri, 14 Apr 2017 11:33:37 -0400
From: "J. Hart" <jfhart085@gmail.com>
Reply-To: jfhart085@gmail.com
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
CC: quwenruo@cn.fujitsu.com, o.freyermuth@googlemail.com
Subject: Re: btrfs send extremely slow (almost stuck)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

on 30.08.2016 at 02:48 Qu Wenruo wrote :
 > Not the first, but although still few.
 > There is a xfstest case submitted for it, and even before the test 
case, there are already report from IRC.
 > Anyway, I'll add Cc for you after the new IRC patch is out.

Please count me in.

I have this occur when I'm backing up a file server I use to hold 
reflinked incrementals from client machines.  Backing up from clients to 
server is very quick (mere seconds, no incrementals there), but backup 
of the server volume itself is very slow even with limited changes.  
With clone detection enabled, that backup takes nearly seven hours.  
Sending a complete volume to a blank filesystem (so no reflinks are 
present at the destination) is a matter of only a few minutes.

Many thanks to Hermann Schwarzler whose suggestion led me onto this.

J. Hart

