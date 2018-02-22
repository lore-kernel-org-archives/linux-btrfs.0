Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ot0-f175.google.com ([74.125.82.175]:37780 "EHLO
        mail-ot0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751794AbeBVXwf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Feb 2018 18:52:35 -0500
Received: by mail-ot0-f175.google.com with SMTP id e64so6273978ote.4
        for <linux-btrfs@vger.kernel.org>; Thu, 22 Feb 2018 15:52:34 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAG+QAKXX95w4gtRCqjDkUJoSqgVOM2qEX4oDsb-C_gGbY3+w6A@mail.gmail.com>
References: <CAG+QAKXX95w4gtRCqjDkUJoSqgVOM2qEX4oDsb-C_gGbY3+w6A@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Thu, 22 Feb 2018 16:52:33 -0700
Message-ID: <CAJCQCtTnTTN2t=J5=YThBd3Yb=tVfHBrODMnyZPWbuj9wQKSrg@mail.gmail.com>
Subject: Re: fs was hung and sort of full
To: Rich Rauenzahn <rrauenza@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If there's no hung task listed in dmesg you could try to do sysrq+t to
find out what everything's up to, although then you have to learn how
to parse the result.


Chris Murphy
