Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:37438 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751746AbdHCJ72 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Aug 2017 05:59:28 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1ddCuP-0008Fr-99
        for linux-btrfs@vger.kernel.org; Thu, 03 Aug 2017 11:59:13 +0200
To: linux-btrfs@vger.kernel.org
From: Lutz Vieweg <lvml@5t9.de>
Subject: Re: RedHat 7.4 Release Notes: "Btrfs has been deprecated" - wut?
Date: Thu, 03 Aug 2017 11:59:04 +0200
Message-ID: <olus52$sb4$1@blaine.gmane.org>
References: <84806456-eed9-00b9-b3f6-99e46cefba33@swiftspirit.co.za> <CAJCQCtRywY4iZnexCHRyToaZkBi=Ot3Cft3Q_6fGBorrAfaB+A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
In-Reply-To: <CAJCQCtRywY4iZnexCHRyToaZkBi=Ot3Cft3Q_6fGBorrAfaB+A@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 08/03/2017 12:22 AM, Chris Murphy wrote:
> Also more interesting is this Stratis project that started up a few months ago:
> https://github.com/stratis-storage/stratisd
>
> Which also includes this design document:
> https://stratis-storage.github.io/StratisSoftwareDesign.pdf

This concept, if successfully implemented, does not seem to achieve
anything beyond "hide the complexity of its implementation from the user".

No actual new functionality, no reason to assume any additional robustness
or stability, and certainly not a new filesystem,  just yet-another-wrapper.

Keeping users from understanding the complexity of a storage system
they use is not a benefit for all but the most trivial use cases.

And I find it symptomatic that the section "D-Bus Access Control" in
StratisSoftwareDesign.pdf is empty.

> So it's going to use existing device mapper, md, some LVM
> stuff, XFS

That is the only part of the Stratis concept that looks reasonable to me.




