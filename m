Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f52.google.com ([209.85.213.52]:36044 "EHLO
        mail-vk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752382AbdHPXch (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 Aug 2017 19:32:37 -0400
Received: by mail-vk0-f52.google.com with SMTP id u133so17297844vke.3
        for <linux-btrfs@vger.kernel.org>; Wed, 16 Aug 2017 16:32:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CADJPUQ9awnz30XzGZLGQAUhAqeH5ek6stDN5N5JTzc3dGtdiug@mail.gmail.com>
References: <CADJPUQ9awnz30XzGZLGQAUhAqeH5ek6stDN5N5JTzc3dGtdiug@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Wed, 16 Aug 2017 17:32:36 -0600
Message-ID: <CAJCQCtQPMNnC4wHfubV1aHstdUnZXQoRMuss85=_ZAv51qFpSw@mail.gmail.com>
Subject: Re: qcow2 images make scrub believe the filesystem is corrupted.
To: Paulo Dias <paulo.miguel.dias@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>>>
On Tue, Aug 15, 2017 at 7:12 PM, Paulo Dias <paulo.miguel.dias@gmail.com> wrote:
Device Model:     Samsung SSD 850 EVO M.2 500GB
Serial Number:    S33DNX0H812686V
LU WWN Device Id: 5 002538 d4130d027
Firmware Version: EMT21B6Q
>>>

Unfortunately no firmware updates listed with Samsung for this model.
It's worth filing a bug report with them, and then try not using
either fstrim or discard for a while and see if the problem reoccurs.
If not, then that suggests trim bug in the firmware. If it does still
occur it could just be defective hardware.

Does smartctl -x reveal any issues?



-- 
Chris Murphy
