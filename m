Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ve0-f179.google.com ([209.85.128.179]:39823 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755558AbaFRVT3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Jun 2014 17:19:29 -0400
Received: by mail-ve0-f179.google.com with SMTP id sa20so1471065veb.10
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Jun 2014 14:19:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPLrYESSX+D5tnY_qWcz0B+xUyyT1Ut-ALM=b9TfehACUq82GA@mail.gmail.com>
References: <CAPLrYESSX+D5tnY_qWcz0B+xUyyT1Ut-ALM=b9TfehACUq82GA@mail.gmail.com>
Date: Wed, 18 Jun 2014 23:19:28 +0200
Message-ID: <CAK5rZE7Gx2H1Fg=bNBqwNV1iDFnLNxu9B+odGUAeEeR2eO8bEQ@mail.gmail.com>
Subject: Re: btrfs on whole disk (no partitions)
From: Imran Geriskovan <imran.geriskovan@gmail.com>
To: =?ISO-8859-2?Q?Daniel_Cegie=B3ka?= <daniel.cegielka@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 6/18/14, Daniel Cegiełka <daniel.cegielka@gmail.com> wrote:
> I created btrfs directly to disk using such a scheme (no partitions):
> cd /mnt
> btrfs subvolume create __active
> btrfs subvolume create __active/rootvol
> Everything works fine. Is such a solution is recommended? In my
> opinion, the creation of the partitions seems to be completely
> unnecessary if you can use btrfs.

Partitionless and subvolumeless desktop setup (everything is in
default subvolume) is operational here since kernel 3.10 (now 3.14).
No issues.

Regards, Imran
