Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f182.google.com ([209.85.213.182]:42547 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752814AbaAIS2m (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Jan 2014 13:28:42 -0500
Received: by mail-ig0-f182.google.com with SMTP id c10so8291569igq.3
        for <linux-btrfs@vger.kernel.org>; Thu, 09 Jan 2014 10:28:42 -0800 (PST)
Message-ID: <52CEE901.1090207@gmail.com>
Date: Thu, 09 Jan 2014 13:22:57 -0500
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: How does btrfs handle bad blocks in raid1?
References: <CAFvQSYRWBqMdAm-9yWhv4SS1YW-LB71iOZvgkNPc9BG3Wh7erw@mail.gmail.com> <20140109104247.GH15634@carfax.org.uk> <pan$ab233$2067aff9$a13049e6$e769dc55@cox.net> <28EF9764-B846-4AB4-AA88-9A37F106B6C6@colorremedies.com>
In-Reply-To: <28EF9764-B846-4AB4-AA88-9A37F106B6C6@colorremedies.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2014-01-09 13:08, Chris Murphy wrote:
> 
> On Jan 9, 2014, at 5:41 AM, Duncan <1i5t5.duncan@cox.net> wrote:
>> Having checksumming is good, and a second 
>> copy in case one fails the checksum is nice, but what if they BOTH do?
>> I'd love to have the choice of (at least) three-way-mirroring, as for me 
>> that seems the best practical hassle/cost vs. risk balance I could get, 
>> but it's not yet possible. =:^(
> 
> I'm on the fence on n-way. 
> 
> HDDs get bigger at a faster rate than their performance improves, so rebuild times keep getting higher. For cases where the data is really important, backup-restore doesn't provide the necessary uptime, and minimum single drive performance is needed, it can make sense to want three copies.
> 
> But what's the probability of both drives in a mirrored raid set dying, compared to something else in the storage stack dying? I think at 3 copies, you've got other risks that the 3rd copy doesn't manage, like a power supply, controller card, or logic board dying.
> 
The risk isn't as much both drives dying at the same time as one dying
during a rebuild of the array, which is more and more likely as drives
get bigger and bigger.

