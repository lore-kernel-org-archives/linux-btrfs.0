Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f173.google.com ([209.85.223.173]:34457 "EHLO
        mail-io0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752651AbeCUQvJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Mar 2018 12:51:09 -0400
Received: by mail-io0-f173.google.com with SMTP id r18so7447013ioa.1
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Mar 2018 09:51:09 -0700 (PDT)
MIME-Version: 1.0
From: Menion <menion@gmail.com>
Date: Wed, 21 Mar 2018 17:50:48 +0100
Message-ID: <CAJVZm6dkZmSpnV3wz4sfOMzMCP36Mrt+-2J7o0mU4z=dEYQqQQ@mail.gmail.com>
Subject: Status of RAID5/6
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all
I am trying to understand the status of RAID5/6 in BTRFS
I know that there are some discussion ongoing on the RFC patch
proposed by Liu bo
But it seems that everything stopped last summary. Also it mentioned
about a "separate disk for journal", does it mean that the final
implementation of RAID5/6 will require a dedicated HDD for the
journaling?
Bye
